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
        $("#work_building").show();
    } else {
        $("#work_building").hide();
    }
})

$(document).on("change", "#request_work_type", function () {
    var workBuilding = $(this).val();
    if (workBuilding === "other") {
        $("#work_type").show();
    } else {
        $("#work_type").hide();
    }
})