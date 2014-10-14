$(document).ready(function() {
  $(".beth").popover();
  $(".bet_submit_new").on("click", function() {
    var data = {};
    data['team1goals'] = $(this).parent().parent().find('.first_goals').val();
    data['team2goals'] = $(this).parent().find('.second_goals').val();
    data['game_id'] = $(this).parent().parent().attr('id');
    data['league_id'] = $('.championship').attr('id');
    data['score'] = 0;
    //console.log($(this).parent().parent().attr('id'));
    console.log(data);
    $.ajax({
        type: "POST",
        url: '/bets.json',
        dataType: 'json',
        data: data
    })
  })
});
