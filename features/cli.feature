Feature: CLI
  CLI functions

  Scenario: Show version
    When I run `chulai version`
    Then the output should contain "chulai 0.0.1"
