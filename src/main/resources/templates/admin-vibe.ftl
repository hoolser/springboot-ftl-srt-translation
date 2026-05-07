<!DOCTYPE html>
<html lang="en" data-bs-theme="dark">
<head>
    <title>Admin - Add Vibe</title>
    <link rel="stylesheet" href="/css/bootstrap5.3.0.min.css">
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
</head>
<body class="bg-dark text-light p-5">
    <div class="container">
        <a href="/" class="btn btn-secondary mb-3">Back to Home</a>
        <h2>Add a New Vibe</h2>
        <div class="mb-3 mt-4">
            <label for="vibeText" class="form-label">Vibe Text</label>
            <textarea class="form-control" id="vibeText" rows="3"></textarea>
        </div>
        <button id="addVibeBtn" class="btn btn-success">Add Vibe</button>
        <div id="statusMessage" class="mt-3"></div>

        <hr class="mt-5 mb-5"/>

        <h3>Existing Vibes</h3>
        <#if vibes?? && (vibes?size > 0)>
            <ul class="list-group mt-3">
                <#list vibes as v>
                    <li class="list-group-item text-light">
                        <strong>#${v.id!}</strong>: ${v.text!}
                    </li>
                </#list>
            </ul>
        <#else>
            <p class="text-muted mt-3">No vibes found in the index yet.</p>
        </#if>
    </div>
    <script>
        document.getElementById("addVibeBtn").addEventListener("click", function() {
            const text = document.getElementById("vibeText").value;
            if (!text) return;
            const csrfToken = document.querySelector("meta[name='_csrf']").getAttribute("content");
            const csrfHeader = document.querySelector("meta[name='_csrf_header']").getAttribute("content");
            fetch("/vibes/api", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json",
                    [csrfHeader]: csrfToken
                },
                body: JSON.stringify({text: text})
            }).then(response => {
                if (response.ok) {
                    document.getElementById("statusMessage").innerHTML = "<div class='alert alert-success'>Vibe added properly! Refreshing page...</div>";
                    setTimeout(() => window.location.reload(), 1000);
                } else {
                    document.getElementById("statusMessage").innerHTML = "<div class='alert alert-danger'>Error adding vibe!</div>";
                }
            }).catch(e => {
                document.getElementById("statusMessage").innerHTML = "<div class='alert alert-danger'>An error occurred.</div>";
            });
        });
    </script>
</body>
</html>
