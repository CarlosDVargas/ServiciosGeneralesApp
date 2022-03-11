$(document).on("change", "#request_requester_type", function () {
    var requesterType = $(this).val();
    if (requesterType === "student") {
        $(".student-info").show();
    } else {
        $(".student-info").hide();
    }
})

$(document).on("change", "#request_work_building", function () {
    var workBuilding = $(this).val();
    if (workBuilding === "other") {
        $("#work-building-field").val();
        $("#work_building").show();
    } else {
        $("#work_building").hide();
    }
})

$(document).ready(function () {
    $("#work-building-field").val($("#request_work_building").val());
    $("#work-type-field").val($("#request_work_type").val());
})

$(document).on("change", "#request_work_type", function () {
    var workType = $(this).val();
    if (workType === "other") {
        $("#work-type-field").val();
        $("#work_type").show();
    } else {
        $("#work_type").hide();
    }
})