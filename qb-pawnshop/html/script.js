window.addEventListener('message', function(event) {
    if (event.data.action === "open") {
        document.getElementById("app").classList.remove("hidden");

        let pawnList = document.getElementById("pawn-list");
        pawnList.innerHTML = "";
        event.data.pawnItems.forEach(item => {
            let btn = document.createElement("button");
            btn.innerText = `${item.item} - $${item.price}`;
            btn.onclick = () => fetch(`https://${GetParentResourceName()}/sellItem`, {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ item: item.item })
            });
            pawnList.appendChild(btn);
        });

        let meltList = document.getElementById("melt-list");
        meltList.innerHTML = "";
        event.data.meltItems.forEach(item => {
            let btn = document.createElement("button");
            btn.innerText = `${item.item}`;
            btn.onclick = () => fetch(`https://${GetParentResourceName()}/meltItem`, {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ item: item.item })
            });
            meltList.appendChild(btn);
        });
    }
});

function closeUI() {
    document.getElementById("app").classList.add("hidden");
    fetch(`https://${GetParentResourceName()}/close`, { method: "POST" });
}
