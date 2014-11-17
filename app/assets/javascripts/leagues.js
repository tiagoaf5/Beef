var friends_object1 = "<span class=\"friend-obj btn btn-primary\">";
var friends_object2 = "     <i onclick=\"removeUser(this)\" class=\"remove-user glyphicon glyphicon-remove\"></i></span>";

var championship_object1 = "<span class=\"championship-obj btn btn-primary\">";
var championship_object2 = "     <i onclick=\"removeChampionship(this)\" class=\"remove-user glyphicon glyphicon-remove\"></i></span>";

var dismissable_error1 = "<div class=\"alert alert-danger alert-dismissible\" role=\"alert\"><button type=\"button\" class=\"close\" data-dismiss=\"alert\"><span aria-hidden=\"true\">&times;</span><span class=\"sr-only\">Close</span></button>";
var dismissable_error2 = "</div>";

var friends_added = [];
var championships_added = [];

var init = function() {
    $("#league_users").val('');
    $("#league_championships").val('');
    $(".beth").popover();

    $(".bet_submit_new").on("click", function() {
        var data = {};
        data['team1_goals'] = $(this).parent().parent().find('.first_goals').val();
        data['team2_goals'] = $(this).parent().parent().find('.second_goals').val();
        data['game_id'] = $(this).parent().parent().attr('id');
        data['league_id'] = $('.championship').attr('id');
        var data2 = {};
        data2['bet'] = data;
        //console.log($(this).parent().parent().attr('id'));
        $.ajax({
            type: "POST",
            url: '/bets.json',
            dataType: 'json',
            data: data2
        }).done(function() {
            location.reload();
        });
    });

    $(".bet_submit_edit").on("click", function() {
        var data = {};
        var id = $(this).parent().attr('id');
        data['team1_goals'] = $(this).parent().parent().find('.first_goals').val();
        data['team2_goals'] = $(this).parent().parent().find('.second_goals').val();
        var data2 = {};
        data2['bet'] = data;
        //console.log($(this).parent().parent().attr('id'));
        $.ajax({
            type: "PUT",
            url: "/bets/" + id + ".json",
            dataType: 'json',
            data: data2
        }).done(function() {
            location.reload();
        });
    });

    $("#friends").autocomplete({
        source: '/get_users/' + $("#friends").val(),
        minLength: 2
    });

    $(".add_friend").click(function(event) {
        event.preventDefault();
        var f = $("#friends");
        if(friends_added.indexOf(f.val()) != -1 || !validateEmail(f.val())) {
            $("#friends-container").addClass("has-error");
            return;
        }

        $("#friends_added").append(friends_object1 + f.val() + friends_object2);
        friends_added.push(f.val());
        $("#league_users").val(friends_added);
        console.log(friends_added);
        f.val('');
        $("#friends-container").removeClass("has-error");
    });

    $(".add_championship").click(function(event) {
        console.log($("#friends").val());
        event.preventDefault();
        var f = $("#championship");
        if(championships.indexOf(f.val()) == -1 || championships_added.indexOf(f.val()) != -1) {
            $("#championship-container").addClass("has-error");
            return;
        }

        $("#championships_added").append(championship_object1 + f.val() + championship_object2);
        championships_added.push(f.val());
        $("#league_championships").val(championships_added);
        //console.log(championships_added);
        f.val('');
        $("#championship-container").removeClass("has-error");
    });

    $("#championship").autocomplete({
        source: championships
    });

    $('form').submit(function() {
        var valuesToSubmit = {};
        valuesToSubmit['league'] = {};
        valuesToSubmit['league']['name'] = $('#league_name').val();
        valuesToSubmit['league']['score_correct'] = $('#league_score_correct').val();
        valuesToSubmit['league']['score_difference'] = $('#league_score_difference').val();
        valuesToSubmit['league']['score_prediction'] = $('#league_score_prediction').val();
        //console.log(friends_added);
        //console.log(friends_added.length);

        /*console.log(user_ids);

        var championship_ids = [];
        for(var i = 0; i < championships_added.length; i++) {
            championship_ids.push(championships2[championships_added[i]]);
        }
        console.log(championship_ids);*/

        valuesToSubmit['league']['users'] = friends_added;
        valuesToSubmit['league']['championships'] = championships_added;
        console.log(valuesToSubmit);
        $.ajax({
            type: "POST",
            url: '/leagues.json',
            headers: {
                'X-Transaction': 'POST',
                'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
            },
            data: valuesToSubmit,
            dataType: "JSON" // you want a difference between normal and ajax-calls, and json is standard
        }).done(function(json){
            console.log(json);
            window.location.href = '/leagues/' + json['id'];
        }).fail(function(error) {
            var errorArray = error.responseText.replace(/\[|\]|"|/g,'').split(',');
            console.log(errorArray);
            for(var i = 0; i < errorArray.length; i++) {
                $("#errors").append(dismissable_error1 + errorArray[i] + dismissable_error2);
            }
            console.log(error);
        });
        return false; // prevents normal behaviour
    });

    $(".score_correct_helper").tooltip();
    $(".score_diff_helper").tooltip();
    $(".score_prediction_helper").tooltip();

};

function removeUser(obj) {
    var elem = $(obj).parent().text().replace(/ /g,'').replace(/(\r\n|\n|\r)/gm,'');
    friends_added.splice(friends_added.indexOf(elem), 1);
    $("#league_users").val(friends_added);
    $(obj).parent().remove();
}

function removeChampionship(obj) {
    var elem = $(obj).parent().text().replace(/ /g,'').replace(/(\r\n|\n|\r)/gm,'');
    championships_added.splice(championships_added.indexOf(elem), 1);
    $("#league_championships").val(championships_added);
    $(obj).parent().remove();
}

function mybetsEdit() {
    $(".not-editable").hide();
    $(".editable").show();
    $("#btn-edit-mybets").hide();
    $("#btn-save-mybets").show();
    $("#btn-cancel-mybets").show();
}

function mybetsSave() {
    $("#btn-save-mybets").hide();
    $("#btn-cancel-mybets").hide();
    $("#img-loading-mybets").show();

    var x = $(':input').serializeArray();
    var championshipId = $('.championship').attr("id");
    var array = {};

    array["championship_id"] = championshipId;
    array["bets"] = [];


    for(var i = 0; i < x.length; i = i+2) {
        var tmp = x[i]["name"].split("-");
        var betid = tmp[1];
        var gameid = tmp[2];
        var goals1 = x[i]["value"];
        var goals2 = x[i+1]["value"];

        if(betid !== undefined) {
            var bet  = {};
            bet["bet_id"] = betid;
            bet["game_id"] = gameid;
            bet["team1_goals"] = goals1;
            bet["team2_goals"] = goals2;

            array["bets"].push(bet);
        }
        else {
            console.log("tmp :" + tmp);
            console.log("No bet yet");
        }

    }

    console.log("*" + JSON.stringify(array) + "*");



    $.ajax({
        url: "/bets/update_multiple.json",
        type: "POST",
        data: JSON.stringify(array),
        dataType: "json",
        beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
        success: function (result) {
            console.log(result);

            for(var i = 0; i < x.length; i++) {
                $('input[name="' + x[i]["name"] + '"]').parent().prev().html(x[i]["value"]);
            }

            setTimeout(function() {
                $("#img-loading-mybets").hide();
                $("#btn-edit-mybets").show();
                $(".editable").hide();
                $(".not-editable").show();

            }, 1000);

        },
        error: function(a,b,c) {
            console.log(a);
            console.log(b);
            console.log(c);
        }
    });
}

function mybetsCancel() {
    $("#btn-save-mybets").hide();
    $("#btn-cancel-mybets").hide();
    $("#btn-edit-mybets").show();

    $(".editable").hide();
    $('.editable>input').each(function() {
        $(this).val($(this).parent().prev().html());
    });

    $(".not-editable").show();
}

function validateEmail(email) {
    var re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    return re.test(email);
}

$(document).ready(init);
$(document).on('page:load', init);