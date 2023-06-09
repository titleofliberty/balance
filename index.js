const jetpack = require("fs-jetpack");
const dayjs = require('dayjs');

var win = nw.Window.get();
var selectedDate = new Date();
var months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];

function togglePanel() {
    var pnl = $("#panel");
    console.log(pnl);
}

function calPopulate(date) {
    selectedDate = date;
    var step = selectedDate.startOf("month").startOf("week");
    var calDates = $(".cal-date");

    $("#cal-month").text(months[selectedDate.month()]);
    $("#cal-year").text(selectedDate.year());
    calDates.each(function (index) {
        $(this).data("date", step.format("YYYY-MM-DD"));
        $(this).text(step.date());
        console.log(step.month(), selectedDate.month());
        if (step.month() != selectedDate.month()) {
            $(this).addClass("text-secondary");
        }
        else {
            $(this).removeClass("text-secondary");
            if (step.date() == selectedDate.date()) {
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
        step = step.add(1, "day");
        console.log(step);
    });
}

function calToday() {
    calPopulate(dayjs());
}

function calGoTo(date) {
    console.log("calGoTo", date);
    calPopulate(dayjs(date));
}

$(".cal-date").on("click", function () {
    calGoTo($(this).data("date"));
});

calPopulate(dayjs("2021-01-01"));

win.setPosition("center");