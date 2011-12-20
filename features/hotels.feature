Feature: Hotels
  As a developer
  In order to use the EAN API in my application
  I need to be able to manipulate hotel information

  Scenario Outline: Listing available hotels
    Given I have an API key
    When I submit a request to find <number_of_results> hotels in <location>
    Then I want to receive <number_of_results> hotels with their respective information

    Examples:

    | number_of_results | location             |
    | 10                | Boston, USA          |
    | 8                 | Dublin, Ireland      |
    | 1                 | London, UK           |

  Scenario Outline: Requesting more information about a given hotel
    Given I have an API key
    When I submit a request to find more information about a hotel with id <id>
    Then I want to receive more information about that hotel

    Examples:

    | id      |
    | 252897  |
    | 273655  |
    | 174272  |
