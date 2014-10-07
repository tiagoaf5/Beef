require 'test_helper'

class GamesControllerTest < ActionController::TestCase
  setup do
    @game = games(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:games)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create game" do
    assert_difference('Game.count') do
      post :create, game: { championship_id: @game.championship_id, team1_goals: @game.team1_goals, team1_name: @game.team1_name, team2_goals: @game.team2_goals, team2_name: @game.team2_name, time: @game.time }
    end

    assert_redirected_to game_path(assigns(:game))
  end

  test "should show game" do
    get :show, id: @game
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @game
    assert_response :success
  end

  test "should update game" do
    patch :update, id: @game, game: { championship_id: @game.championship_id, team1_goals: @game.team1_goals, team1_name: @game.team1_name, team2_goals: @game.team2_goals, team2_name: @game.team2_name, time: @game.time }
    assert_redirected_to game_path(assigns(:game))
  end

  test "should destroy game" do
    assert_difference('Game.count', -1) do
      delete :destroy, id: @game
    end

    assert_redirected_to games_path
  end
end
