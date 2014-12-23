Feature: Game's result

  Scenario Outline: The bet result was updated
    Given The <game> I <betted> ended
    When I visit my bet's page
    Then I should see the <points> I won/lost
  Examples:
    |game|betted|points|
    |1   |true  |0     |