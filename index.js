const jetpack = require("fs-jetpack");
const dayjs = require('dayjs');

var win = nw.Window.get();
var selectedDate = new Date();
var months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];

function calPopulate(date) {
    selectedDate = date;
    var calDates = $(".cal-date");
    var step = selectedDate.startOf("month").startOf("week");

    $("#cal-month").text(months[selectedDate.month()]);
    $("#cal-year").text(selectedDate.year());
    calDates.each(function (index) {
        $(this).data("date", step.format("YYYY-MM-DD"));
        $(this).text(step.date());
        $(this).removeClass("fw-bold");
        $(this).removeClass("border");
        $(this).removeClass("border-2");
        $(this).removeClass("text-secondary");
        if (step.month() != selectedDate.month()) {
            $(this).addClass("text-secondary");
        }
        else {
            if (step.date() == selectedDate.date()) {
                $(this).addClass("fw-bold");
                $(this).addClass("border");
                $(this).addClass("border-2");
            }
        }   
        step = step.add(1, "day");
    });
}

function calToday() {
    calPopulate(dayjs());
}

function calGoTo(date) {
    calPopulate(dayjs(date));
}

function calMonth(go) {
    if (go == "prev") {
        calPopulate(selectedDate.subtract(1, "month"));
    }
    else if (go == "next") {
        calPopulate(selectedDate.add(1, "month"));
    }
}

function calYear(go) {
    if (go == "prev") {
        calPopulate(selectedDate.subtract(1, "year"));
    }
    else if (go == "next") {
        calPopulate(selectedDate.add(1, "year"));
    }
}

$(".cal-date").on("click", function () {
    calGoTo($(this).data("date"));
});

calPopulate(dayjs("2021-01-01"));

win.setPosition("center");