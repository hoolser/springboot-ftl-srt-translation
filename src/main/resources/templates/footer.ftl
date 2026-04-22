<footer style="text-align: center; margin-top: 50px; padding: 20px; font-size: 0.9em; color: #6c757d; border-top: 1px solid #444;">
    <div style="margin-bottom: 10px;">
        &copy; 2026 Anastasios Tsoukas. All rights reserved.
    </div>
    <#if isAdmin?? && isAdmin>
        <div style="margin-top: 5px;">
            <a href="/admin-contact" style="color: #4CAF50; text-decoration: none; border: 1px solid #4CAF50; padding: 5px 10px; border-radius: 4px; display: inline-block; transition: all 0.3s ease;">
                &#9993; Contact Us
            </a>
        </div>
    </#if>
</footer>
