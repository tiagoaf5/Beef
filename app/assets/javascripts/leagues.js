$(document).ready(function() {
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
        console.log(data);
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
        console.log(data);
        $.ajax({
            type: "PUT",
            url: "/bets/" + id + ".json",
            dataType: 'json',
            data: data2
        }).done(function() {
            location.reload();
        });
    })
});