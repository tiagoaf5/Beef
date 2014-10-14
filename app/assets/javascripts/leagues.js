$(document).ready(function() {
  $(".beth").popover();
  $(".bet_submit_new").on("click", function() {
    var data = {};
    data['team1goals'] = $(this).parent().find('.first_goals').val();
    data['team2goals'] = $(this).parent().parent().find('.second_goals').val();
    data['game_id'] = $(this).parent().attr('id');
    //console.log($(this).parent().parent().attr('id'));
    //console.log(data);
    $.ajax({
        type: "POST",
        url: '/bets/new.json',
        dataType: 'json',
        data: data
    })
  })
});
