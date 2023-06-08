const jetpack = require("fs-jetpack");
var win = nw.Window.get();


function togglePanel() {
    var pnl = $("#panel");
    console.log(pnl);
}

function calDates() {
    var today = new Date().toISOString();
    var dates = $(".cal-date");
    dates.each(function (index) {
        var date = $(this).attr("data-date");
        if (date.slice(5, 7) != today.slice(5, 7)) {
            $(this).addClass("text-secondary");
        }
        else {
            $(this).removeClass("text-secondary");
            if (date.slice(8, 10) == today.slice(8, 10)) {
                $(this).addClass("fw-bold");
                $(this).addClass("border");
                $(this).addClass("border-2");
            }
            else {
                $(this).removeClass("fw-bold");
                $(this).removeClass("border");
                $(this).removeClass("border-2");
            }
        }        
    });
}

calDates();

win.setPosition("center");