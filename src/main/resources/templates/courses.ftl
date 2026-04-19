<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${title!}</title>
    <!-- Use the existing CSS dependencies from your project -->
    <link href="/css/bootstrap5.3.0.min.css" rel="stylesheet" />
    <link href="/css/styles.css" rel="stylesheet" />
    <!-- Custom simpler styles for the demo -->
    <style>
        body { padding: 20px; }
        .course-card { margin-bottom: 15px; }
        /* Simple modal fix */
        .modal { background: rgba(0,0,0,0.5); }
    </style>
    <meta name="_csrf" content="${_csrf.token!}"/>
    <meta name="_csrf_header" content="${_csrf.headerName!}"/>
</head>
<body>

<div style="text-align: center; margin-bottom: 30px;">
    <a href="/" aria-label="Home Page" style="display: inline-block;">
      <img src="/images/logo2-shrunk.webp" alt="Logo" style="max-width:400px; height: auto;">
    </a>
</div>
<hr style="border: none; height: 2px; background-color: #28a745; margin: 20px 0;">

<div class="container">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1>Courses</h1>
        <div>
            <div class="input-group">
                <input type="text" id="searchTitle" class="form-control" placeholder="Search title (*)">
                <input type="text" id="searchDesc" class="form-control" placeholder="Search description (*)">
                <button class="btn btn-outline-secondary" type="button" onclick="searchCourses()">Search</button>
            </div>
        </div>
        <#if isAdmin?? && isAdmin>
            <button class="btn btn-primary" onclick="document.getElementById('addCourseModal').style.display='block'; document.getElementById('addCourseModal').classList.add('show');">Add Course</button>
        </#if>
    </div>

    <!-- Course List -->
    <div class="row" id="courseList">
        <!-- Courses will be populated here via AJAX -->
        <div class="col-12 text-center text-muted" id="loadingMsg">Loading courses...</div>
    </div>
</div>

<!-- Add Course Modal -->
<div class="modal fade" id="addCourseModal" tabindex="-1" aria-labelledby="addCourseModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="addCourseModalLabel">Add a New Course</h5>
                <button type="button" class="btn-close" onclick="closeModal()" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="addCourseForm">
                    <div class="mb-3">
                        <label for="courseId" class="form-label">Course ID</label>
                        <input type="text" class="form-control" id="courseId" required>
                    </div>
                    <div class="mb-3">
                        <label for="courseName" class="form-label">Title</label>
                        <input type="text" class="form-control" id="courseName" required>
                    </div>
                     <div class="mb-3">
                        <label for="courseDesc" class="form-label">Description</label>
                        <textarea class="form-control" id="courseDesc" rows="3" required></textarea>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="closeModal()">Close</button>
                <button type="button" class="btn btn-primary" onclick="submitCourse()">Save Course</button>
            </div>
        </div>
    </div>
</div>

<!-- Required Scripts -->
<script>
    // Fetch and display courses on load
    document.addEventListener("DOMContentLoaded", loadCourses);

    function displayCourses(data) {
        const courseList = document.getElementById("courseList");
        courseList.innerHTML = ''; // clear loading state
        if (!data || data.length === 0) {
            courseList.innerHTML = '<div class="col-12 text-center text-muted">No courses found.</div>';
            return;
        }

        data.forEach(course => {
            const id = course.id;
            const title = course.title || 'Untitled';
            const desc = course.description || 'No description available';

            let deleteBtn = '';
            <#if isAdmin?? && isAdmin>
                deleteBtn = '<button class="btn btn-sm btn-outline-danger" onclick="deleteCourse(\'' + id + '\')">Delete</button>';
            </#if>

            const cardHtml = `
                <div class="col-md-4 course-card">
                    <div class="card shadow-sm h-100">
                        <div class="card-body">
                            <h5 class="card-title">` + title + `</h5>
                            <h6 class="card-subtitle mb-2 text-muted">ID: `+ id + `</h6>
                            <p class="card-text">` + desc + `</p>
                        </div>
                        <div class="card-footer bg-transparent border-top-0">
                            ` + deleteBtn + `
                        </div>
                    </div>
                </div>
            `;
            courseList.innerHTML += cardHtml;
        });
    }

    function loadCourses() {
        const courseList = document.getElementById("courseList");
        courseList.innerHTML = '<div class="col-12 text-center text-muted" id="loadingMsg">Loading courses...</div>';

        fetch('/courses/api')
            .then(res => res.json())
            .then(data => displayCourses(data))
            .catch(err => {
                console.error("Failed to load courses:", err);
                courseList.innerHTML = '<div class="col-12 text-center text-danger">Failed to load courses. Is OpenSearch running?</div>';
            });
    }

    function searchCourses() {
        const title = document.getElementById("searchTitle").value.trim();
        const desc = document.getElementById("searchDesc").value.trim();

        if (!title && !desc) {
            loadCourses();
            return;
        }

        const courseList = document.getElementById("courseList");
        courseList.innerHTML = '<div class="col-12 text-center text-muted" id="loadingMsg">Searching...</div>';

        let url = '/courses/api/search?';
        const params = [];
        if (title) params.push('title=' + encodeURIComponent(title));
        if (desc) params.push('description=' + encodeURIComponent(desc));
        url += params.join('&');

        fetch(url)
            .then(res => res.json())
            .then(data => displayCourses(data))
            .catch(err => {
                console.error("Failed to search courses:", err);
                courseList.innerHTML = '<div class="col-12 text-center text-danger">Failed to search courses. Is OpenSearch running?</div>';
            });
    }

    function closeModal() {
        const modal = document.getElementById('addCourseModal');
        modal.style.display = 'none';
        modal.classList.remove('show');
    }

    function submitCourse() {
        const id = document.getElementById("courseId").value;
        const title = document.getElementById("courseName").value;
        const desc = document.getElementById("courseDesc").value;

        const csrfToken = document.querySelector('meta[name="_csrf"]').getAttribute('content');
        const csrfHeader = document.querySelector('meta[name="_csrf_header"]').getAttribute('content');

        fetch('/courses/api', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                [csrfHeader]: csrfToken
            },
            body: JSON.stringify({ id: id, title: title, description: desc })
        })
        .then(res => {
            if (res.ok) {
                // close modal
                closeModal();

                // reset form and reload list
                document.getElementById("addCourseForm").reset();
                loadCourses();
            } else {
                alert("Failed to save course. Are you logged in as Admin?");
            }
        })
        .catch(err => console.error(err));
    }

    function deleteCourse(id) {
        if (!confirm("Are you sure you want to delete course ID: " + id + "?")) return;

        const csrfToken = document.querySelector('meta[name="_csrf"]').getAttribute('content');
        const csrfHeader = document.querySelector('meta[name="_csrf_header"]').getAttribute('content');

        fetch('/courses/api/' + id, {
            method: 'DELETE',
            headers: {
                [csrfHeader]: csrfToken
            }
        })
        .then(res => {
            if (res.ok) {
                loadCourses();
            } else {
                alert("Failed to delete. Try logging in as Admin.");
            }
        })
        .catch(err => console.error(err));
    }
</script>

</body>
</html>

