const jetpack = require("fs-jetpack");

var win = nw.Window.get();
var selectedDate = new Date();
var months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];

function togglePanel() {
    var pnl = $("#panel");
    console.log(pnl);
}

function calPopulate(date) {
    selectedDate = date;
    var step = selectedDate;
    var calDates = $(".cal-date");

    step.setDate(1);
    while (step.getDay() != 0) {
        step.setDate(step.getDate() - 1);
    }
    $("#cal-month").text(months[selectedDate.getMonth()]);
    $("#cal-year").text(selectedDate.getFullYear());
    calDates.each(function (index) {
        var y = step.getFullYear();
        var m = step.getMonth();
        var d = step.getDate();
        $(this).data("date", y + "-" + m + "-" + d);
        $(this).text(d);
        console.log(index, selectedDate, step);
        if (m != selectedDate.getMonth()) {
            $(this).addClass("text-secondary");
        }
        else {
            $(this).removeClass("text-secondary");
            if (d == selectedDate.getDate()) {
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
        step.setDate(step.getDate() + 1);
    });
}

calPopulate(new Date(2021, 0, 1));

win.setPosition("center");