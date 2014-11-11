var friends_object1 = "<span class=\"btn btn-primary\">";
var friends_object2 = "     <i onclick=\"removeUser(this)\" class=\"remove-user glyphicon glyphicon-remove\"></i></span>";

var championship_object1 = "<span class=\"btn btn-primary\">";
var championship_object2 = "     <i onclick=\"removeChampionship(this)\" class=\"remove-user glyphicon glyphicon-remove\"></i></span>";

var friends2 = [];
var championships2 = [];

var init = function() {
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
        source: users
    });
    $(".add_friend").click(function(event) {
        event.preventDefault();
        var f = $("#friends");
        console.log(friends2);
        if(users.indexOf(f.val()) == -1 || friends2.indexOf(f.val()) != -1) {
            $("#friends-container").addClass("has-error");
            return
        }

        $("#friends_added").append(friends_object1 + f.val() + friends_object2);
        friends2.push(f.val());
        f.val('');
        $("#friends-container").removeClass("has-error");
    });

    $(".add_championship").click(function(event) {
        event.preventDefault();
        var f = $("#championship");
        if(championships.indexOf(f.val()) == -1 || championships2.indexOf(f.val()) != -1) {
            $("#championship-container").addClass("has-error");
            return
        }

        $("#championships_added").append(championship_object1 + f.val() + championship_object2);
        championships2.push(f.val());
        f.val('');

        $("#championship-container").removeClass("has-error");
    });

/* TODO: a dar erro
    $("#championship").autocomplete({
        source: championships
    });*/

    $('form').submit(function() {
        var valuesToSubmit = {};
        valuesToSubmit['league'] = {};
        valuesToSubmit['league']['name'] = $('.name').val();
        valuesToSubmit['league']['score_correct'] = $('.score_correct').val();
        valuesToSubmit['league']['score_difference'] = $('.score_difference').val();
        valuesToSubmit['league']['score_prediction'] = $('.score_prediction').val();
        valuesToSubmit['league']['users'] = friends2;
        valuesToSubmit['league']['championships'] = championships2;
        console.log(valuesToSubmit);
        $.ajax({
            type: "POST",
            url: $(this).attr('action'), //sumbits it to the given url of the form
            data: valuesToSubmit,
            dataType: "JSON" // you want a difference between normal and ajax-calls, and json is standard
        }).done(function(json){
            console.log("e");
        }).fail(function(error) {
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
    console.log(friends2);
    friends2.splice(friends2.indexOf(elem));
    console.log(friends2);
    $(obj).parent().remove();
}

function removeChampionship(obj) {
    var elem = $(obj).parent().text().replace(/ /g,'').replace(/(\r\n|\n|\r)/gm,'');
    console.log(championships2);
    championships2.splice(championships2.indexOf(elem));
    console.log(championships2);
    $(obj).parent().remove();
}


$(document).ready(init);
$(document).on('page:load', init);