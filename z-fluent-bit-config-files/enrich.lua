-- enrich.lua
-- Adds: status_category, slow_request, threat_detected, threat_type, request_path_clean

function enrich(tag, timestamp, record)

    -- 1. Status category
    local status = tonumber(record["status_code"]) or 0
    if     status >= 500 then record["status_category"] = "5xx_error"
    elseif status >= 400 then record["status_category"] = "4xx_client_error"
    elseif status >= 300 then record["status_category"] = "3xx_redirect"
    elseif status >= 200 then record["status_category"] = "2xx_success"
    else                       record["status_category"] = "other"
    end

    -- 2. Slow request flag (> 2000 ms)
    local rt = tonumber(record["response_time_ms"]) or 0
    record["slow_request"] = (rt > 2000)

    -- 3. Threat detection based on request_path patterns
    local path = record["request_path"] or ""
    local threat = nil

    -- Path traversal
    if path:find("%%2F%%2E%%2E") or path:find("%%5C") or
       path:find("%.%.%%2F") or path:find("%.%.%%5C") or
       path:find("%.%./") or path:find("%.\\.") then
        threat = "path_traversal"

    -- Sensitive file probing
    elseif path:find("[Ww][Ee][Bb]%-[Ii][Nn][Ff]") or
           path:find("web%.xml") or path:find("%.ini") then
        threat = "sensitive_file_probe"

    -- /etc/passwd or similar unix probing
    elseif path:find("%%2Fetc%%2F") or path:find("/etc/passwd") or
           path:find("%%2Fetc%%2Fpasswd") then
        threat = "lfi_attempt"

    -- Windows path injection
    elseif path:find("[Cc]%%3[Aa]") or path:find("[Cc]%%3a") or
           path:find("[Ww]indows") then
        threat = "windows_path_probe"

    -- SQL injection markers
    elseif path:find("%%27") or path:find("'") or
           path:find("%%3[Cc]script") or path:find("<script") then
        threat = "injection_attempt"
    end

    if threat then
        record["threat_detected"] = true
        record["threat_type"]     = threat
    else
        record["threat_detected"] = false
        record["threat_type"]     = "none"
    end

    -- 4. Decode a clean version of the path (just first segment for dashboards)
    local clean = path:gsub("%%[0-9A-Fa-f][0-9A-Fa-f]", "?")
    record["request_path_clean"] = clean

    return 1, timestamp, record
end
