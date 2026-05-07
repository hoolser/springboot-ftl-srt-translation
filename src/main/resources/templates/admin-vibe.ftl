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

        <div class="mt-4 p-3 border border-secondary rounded">
            <h4>Advanced Operations</h4>

            <div class="mb-3 mt-3">
                <label for="bulkFile" class="form-label">Bulk Upload Vibes (TXT file, one vibe per line)</label>
                <div class="input-group">
                    <input class="form-control bg-dark text-light border-secondary" type="file" id="bulkFile" accept=".txt">
                    <button class="btn btn-primary" id="bulkUploadBtn">Upload Bulk</button>
                </div>
            </div>

            <div class="d-flex gap-3">
                <a href="/vibes/export" class="btn btn-info">Export Vibes (TXT)</a>
                <button id="reindexBtn" class="btn btn-warning">Re-index Vibe IDs</button>
            </div>
            <div id="advancedStatusMessage" class="mt-2"></div>
        </div>

        <hr class="mt-5 mb-5"/>

        <h3>Existing Vibes</h3>
        <#if vibes?? && (vibes?size > 0)>
            <ul class="list-group mt-3">
                <#list vibes as v>
                    <li class="list-group-item text-light d-flex justify-content-between align-items-center">
                        <span><strong>#${v.id!}</strong>: ${v.text!}</span>
                        <button class="btn btn-sm btn-danger delete-vibe-btn" data-id="${v.id!}">Remove</button>
                    </li>
                </#list>
            </ul>
        <#else>
            <p class="text-muted mt-3">No vibes found in the index yet.</p>
        </#if>
    </div>
    <script>
        const csrfToken = document.querySelector("meta[name='_csrf']").getAttribute("content");
        const csrfHeader = document.querySelector("meta[name='_csrf_header']").getAttribute("content");

        document.getElementById("addVibeBtn").addEventListener("click", function() {
            const text = document.getElementById("vibeText").value;
            if (!text) return;
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

        // Bulk Upload
        document.getElementById("bulkUploadBtn").addEventListener("click", function() {
            const fileInput = document.getElementById("bulkFile");
            if (!fileInput.files.length) return;

            const formData = new FormData();
            formData.append("file", fileInput.files[0]);

            fetch("/vibes/api/bulk", {
                method: "POST",
                headers: {
                    [csrfHeader]: csrfToken
                },
                body: formData
            }).then(response => {
                if (response.ok) {
                    document.getElementById("advancedStatusMessage").innerHTML = "<div class='alert alert-success'>Bulk added successfully! Refreshing...</div>";
                    setTimeout(() => window.location.reload(), 1000);
                } else {
                    document.getElementById("advancedStatusMessage").innerHTML = "<div class='alert alert-danger'>Error in bulk upload!</div>";
                }
            }).catch(e => {
                document.getElementById("advancedStatusMessage").innerHTML = "<div class='alert alert-danger'>An error occurred during bulk upload.</div>";
            });
        });

        // Reindex
        document.getElementById("reindexBtn").addEventListener("click", function() {
            if (!confirm("Are you sure you want to re-index all vibes? This will recreate the index and assign sequential IDs.")) return;

            fetch("/vibes/api/reindex", {
                method: "POST",
                headers: {
                    [csrfHeader]: csrfToken
                }
            }).then(response => {
                if (response.ok) {
                    document.getElementById("advancedStatusMessage").innerHTML = "<div class='alert alert-success'>Re-indexed successfully! Refreshing...</div>";
                    setTimeout(() => window.location.reload(), 1000);
                } else {
                    document.getElementById("advancedStatusMessage").innerHTML = "<div class='alert alert-danger'>Error reindexing!</div>";
                }
            }).catch(e => {
                document.getElementById("advancedStatusMessage").innerHTML = "<div class='alert alert-danger'>An error occurred.</div>";
            });
        });

        // Delete Individual Vibe
        document.querySelectorAll(".delete-vibe-btn").forEach(btn => {
            btn.addEventListener("click", function() {
                const id = this.getAttribute("data-id");
                if (!confirm(`Are you sure you want to delete vibe #${"$"}{id}?`)) return;

                fetch(`/vibes/api/${"$"}{id}`, {
                    method: "DELETE",
                    headers: {
                        [csrfHeader]: csrfToken
                    }
                }).then(response => {
                    if (response.ok) {
                        alert("Vibe deleted! Don't forget to run 'Re-index' afterwards to close any ID gaps.");
                        window.location.reload();
                    } else {
                        alert("Error deleting vibe!");
                    }
                }).catch(e => {
                    alert("An error occurred while deleting.");
                });
            });
        });
    </script>
</body>
</html>
