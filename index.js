const jetpack = require("fs-jetpack");
const moment = require("moment/moment");
var win = nw.Window.get();


function togglePanel() {
    var pnl = document.getElementById("panel");
    pnl.classList.toggle("pnl-hidden");
    console.log("toggle");
}

win.setPosition("center");