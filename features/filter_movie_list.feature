Feature: display list of movies filtered by various fields
 
  As Ben
  So that I can quickly browse movies
  I want to see movies filtered by certain fields

Background: movies have been added to database

  Given the following movies exist:
  | title                   | rating | location	| quality 	|
  | Aladdin                 | G      | E				| 480p			|
  | The Terminator          | R      | F				| 720p		  |
  | When Harry Met Sally    | R      | G				| 1080p		  |
  | The Help                | PG-13  | H				| 720p		  |
  | Chocolat                | PG-13  | G				| 720p		  |
  | Amelie                  | R      | F				| 480p		  |
  | 2001: A Space Odyssey   | G      | H				| 720p 	 		|
  | The Incredibles         | PG     | G				| 1080p  		|
  | Raiders of the Lost Ark | PG     | F				| 720p  		|
  | Chicken Run             | G      | E				| 480p  		|

  And  I am on the BensPotatoes home page

Scenario: ratings -- restrict to movies with 'PG' or 'R' ratings
	When I check the following ratings: PG, R
	When I uncheck the following ratings: PG-13, NC-17, G
	When I check the following locations: E, F, G, H
	When I check the following encodings: 480p, 720p, 1080p
	When I press "filter_submit"
	Then I should see "The Incredibles"
	And I should see "Raiders of the Lost Ark"
	And I should see "The Terminator"
	And I should see "When Harry Met Sally"
	And I should see "Amelie"
	And I should not see "Aladdin"
	And I should not see "The Help"
	And I should not see "Chocolat"
	And I should not see "2001: A Space Odyssey"
	And I should not see "Chicken Run"

Scenario: location -- restrict to movies located on 'F:\'
	When I check the following ratings: PG, R, PG-13, NC-17, G
	When I check the following locations: F
	When I uncheck the following locations: E, G, H
	When I check the following encodings: 480p, 720p, 1080p
	When I press "filter_submit"
	Then I should see "The Terminator"
	And I should see "Amelie"
	And I should see "Raiders of the Lost Ark"
	And I should not see "Aladdin"
	And I should not see "When Harry Met Sally"
	And I should not see "The Help"
	And I should not see "Chocolat"
	And I should not see "2001: A Space Odyssey"
	And I should not see "The Incredibles"
	And I should not see "Chicken Run"

Scenario: quality -- restrict to movies encoded at '1080p'
	When I check the following ratings: PG, R, PG-13, NC-17, G
	When I check the following locations: E, F, G, H	
	When I check the following encodings: 1080p
	When I uncheck the following encodings: 480p, 720p
	When I press "filter_submit"
	Then I should see "When Harry Met Sally"
	And I should see "The Incredibles"
	And I should not see "Aladdin"
	And I should not see "The Terminator"
	And I should not see "The Help"
	And I should not see "Chocolat"
	And I should not see "Amelie"
	And I should not see "2001: A Space Odyssey"
	And I should not see "Raiders of the Lost Ark"
	And I should not see "Chicken Run"

Scenario: ratings, location, quality -- restrict to movies with 'R' rating located on 'E:\' encoded at '720p'
	When I check the following ratings: R
	When I uncheck the following ratings: PG, PG-13, NC-17, G
	When I check the following locations: E
	When I uncheck the following locations: F, G, H
	When I check the following encodings: 720p
	When I uncheck the following encodings: 480p, 1080p
	Then I should not see "Aladdin"
	And I should not see "The Terminator"
	And I should not see "When Harry Met Sally"
	And I should not see "The Help"
	And I should not see "Chocolat"
	And I should not see "Amelie"
	And I should not see "2001: A Space Odyssey"
	And I should not see "The Incredibles"
	And I should not see "Raiders of the Lost Ark"
	And I should not see "Chicken Run"