<div style="text-align: center; margin: 40px auto; padding: 20px; max-width: 800px; background-color: rgba(255, 255, 255, 0.05); border-radius: 10px; border-left: 5px solid #28a745;">
<#--    <h3 style="color: #28a745; margin-bottom: 10px;">?? Random Vibe ??</h3>-->
    <div id="vibeContainer">
        <button id="fetchVibeBtn" style="background-color: #28a745; color: white; padding: 10px 22px; border: none; border-radius: 25px; cursor: pointer; font-size: 15px; font-weight: bold; transition: all 0.3s ease; box-shadow: 0 4px 6px rgba(0,0,0,0.3);">
            🌿 Get a Random Vibe 🍃
        </button>
        <p id="vibeText" style="font-size: 1.2em; font-style: italic; display: none; margin-top: 15px;"></p>
        <p id="vibeError" style="color: #e74c3c; display: none; margin-top: 15px;"></p>
    </div>
</div>
<script>
    document.getElementById("fetchVibeBtn").addEventListener("click", function() {
        const textEl = document.getElementById("vibeText");
        const errorEl = document.getElementById("vibeError");
        textEl.style.display = "none";
        errorEl.style.display = "none";
        fetch("/vibes/random")
            .then(response => {
                if (!response.ok) {
                    throw new Error("Unavailable");
                }
                return response.json();
            })
            .then(data => {
                if (data && data.text) {
                    textEl.innerText = '"' + data.text + '"';
                    textEl.style.display = "block";
                }
            })
            .catch(error => {
                errorEl.innerText = "Sorry, OpenSearch is currently down or no vibes available.";
                errorEl.style.display = "block";
            });
    });
</script>
