-- -----------------------------------------------------------------------------
--
-- ECE 356 Project
-- serverside testcases
-- 
-- Walter Alejandro Lam Astudillo	walamast
-- Bruce Nguyen						b34nguye
-- Darius Andrew Wigglesworth		dawiggle
--
-- This file contains testcases to test the server-side schema
-- According to Piazza @896 "All you need to test is that you can do the following:

-- Basic Select commands, Basic Updates Basic Insert Remove a row and its FKs.

-- You do not need to test your CLI, just ensure the commands are working."
--

-- TEST 1) 
-- What's is being tested: 	
select 'TEST 1: Select Production Company Names of a movie that is part of both MoviesIMDB.csv and MoviesTMDB.csv' as '';
-- Input/setup: 
-- While movies on MoviesIMDB.csv provides only 1 production company for a unique movie, MoviesTMDB.csv could provide multiple. 
-- SQL code that considers MoviesTMDB runs after the MoviesIMDB one. 
select distinct(companyName) as 'Production company names for Paradox' from Movies inner join MovieProductionCompany using (movieID) Where title = 'Paradox';
-- Expected output:	This should return multiple production if Paradox is part of both datasets 			
-- Status: 			PASS 

-- TEST 2) 
-- What's is being tested:
select 'TEST 2: Select Production Company Name of a movie that is only part of MoviesIMDB.csv' as '';
-- Input/setup: 
-- Assuming L'enfant de Paris is only part of MoviesIMDB
select distinct(companyName) as "Production company names for L'enfant de Paris" from Movies inner join MovieProductionCompany using (movieID) Where title = "L'enfant de Paris";
-- Expected output: This query should return only 1 production company 
-- Status: 			PASS 

-- TEST 3) 
-- What's is being tested:
select 'TEST 3: Select Production Company Names of a movie that is only part of MoviesTMDB.csv' as '';
-- Input/setup: 
-- This type of query could return +1 production company names 
select distinct(companyName) as "Production company names for Dracula: Dead and Loving It" from Movies inner join MovieProductionCompany using (movieID) Where title = "Dracula: Dead and Loving It";
-- Expected output: For this movie, there are 2 production companies
-- Status: 			PASS 

-- TEST 4) 
-- What's is being tested:
select 'TEST 4: No duplicated tuples (movieID, genre) in MovieGenre' as '';
-- Input/setup: 
-- No duplicated tuples (movieID, genre) in MovieGenre due to the enforcement of the primary key (movieID, genre) on it 
select count(*) as 'count all (movieID, genre) tuples' FROM MovieGenre;
select distinct count(*) as 'count distinct (movieID, genre) tuples' FROM MovieGenre;
-- Expected output: Counts must be the same for the following commands as all duplicated entries should be deleted due to the primary key (movieID, genre) 
-- Status: 			PASS

-- TEST 5) 
-- What's is being tested:
select 'TEST 5: No duplicated tuples (movieID, language) in MovieLanguage' as '';
-- Input/setup: 
-- No duplicated tuples (movieID, language) in MovieLanguagedue to the enforcement of the primary key (movieID, language) on it 
select count(*) as 'count all (movieID, language) tuples' FROM MovieLanguage;
select distinct count(*) as 'count distinct (movieID, language) tuples' FROM MovieLanguage;
-- Expected output: Counts must be the same for the following commands as all duplicated entries should be deleted due to the primary key (movieID, language)
-- Status: 			PASS

-- TEST 6) 
-- What's is being tested:
select 'TEST 6: Select 5 distinct movies titles in English' as ''; 
-- Input/setup: 
-- There are 11320 movies in English 
select title from Movies inner join MovieLanguage using (movieID) where language = 'English' limit 5;
-- Expected output: 5 movie titles in English 
-- Status: 			PASS

-- TEST 7) 
-- What's is being tested: 
select 'TEST 7: select distinct First names of people whose first name start with Fred' as '';
-- Input/setup: 
-- there are 296 "Fred"(s), but 746 people whose first name is Fred% with 23 different Fred% variations   
with People_distinct as 
	(select distinct name from People where name like 'Fred%'), 
	People_substring as 
	(select substring_index(name, ' ', 1) as ss_name from People_distinct)
select distinct ss_name from People_substring;
-- Expected output: 23 Distinct First names of people whose first name start with Fred
-- Status: 			PASS

-- TEST 8) 
-- What's is being tested: 
select 'TEST 8: select actor/actress name(s) and role(s) given the movie named Miss Jerry' as '';
-- Input/setup:  
-- Assume that we wanna know the name of only the actor/actress of a movie 
with 	personIDformovie as 
			(select distinct(personID) from MovieCrew inner join Movies using(movieID) inner join MovieCast using(personID) where title = 'Miss Jerry'),
		nameActorActress as
			(select personID,name from personIDformovie inner join People using(personID))
select 	name as Name, role as Role from nameActorActress inner join MovieCrew using(personID) group by name, role; 
-- Expected output: Actor(s)/Actress(es) name(s) and role(s)
-- Status: 			PASS


-- TEST 9) 
-- What's is being tested:
select 'TEST 9: Select 10 distinct movie titles associated with the keyword forest' as ''; 
-- Input/setup: 
-- There are 120 distinct movies associated with keyword forest  
select distinct(title) from MovieKeyword inner join Movies using(movieID) where keyword = 'forest' limit 10;
-- Expected output: 10 movie titles associated with the keyword forest 
-- Status: 			PASS

-- TEST 10) 
-- What's is being tested MISS:
select 'TEST 10: Select total votes, mean vote and meadian vote given the movie name "Miss Jerry"' as ''; 
-- Input/setup: 
with 	movieIDforMovieName as 
			(select distinct(movieID),title from Movies where title = 'Miss Jerry'),
		meanVotes as
			(select * from RatingsIMDB union select * from UserRatingsTMDB)
select 	title as 'Movie Title', totalVotes as 'Total votes', meanVote as 'Mean vote', medianVote as 'Median vote' from movieIDforMovieName inner join meanVotes using(movieID);
-- Expected output: movie title, total votes, mean vote and meadian vote
-- Status: 			PASS

-- TEST 11) 
-- What's is being tested: 	
select 'TEST 11: Delete a movie by name, assuming that there is only 1 movie with title X' as '';  
-- Input/setup: 			
delete from Movies where title = 'Amore di madre'; 
-- Expected output:	should delete associated entitiies record(s) from
-- 					MovieCast, MovieCrew, MovieGenre, MovieKeyword, MovieLanguage, MovieProductionCompany, RatingsIMDB, UserRatingDemographics,
-- 					UserRatingsTMDB 
-- Status: 			PASS 

-- TEST 12) 
-- What's is being tested: 	
select 'TEST 12: Delete a movie by name and releaseDate, assuming that a movie name repeats due to different movies being release on different dates' as ''; 
-- Input/setup: 			
delete from Movies where title = 'Cleopatra' and releaseDate =  '2003-08-14 00:00:00'; 
-- Expected output:	should delete associated entitiies record(s) from
-- 					MovieCast, MovieCrew, MovieGenre, MovieKeyword, MovieLanguage, MovieProductionCompany, RatingsIMDB, UserRatingDemographics,
-- 					UserRatingsTMDB for 1 movie and not all movies named "Cleopatra" in this case 		
-- Status: 			PASS

-- TEST 13) 
-- What's is being tested: 
select 'TEST 13: Insert a new movie by movieTitle' as ''; 
-- Input/setup: 
-- Movie is not part of the Movies table
insert into Movies(title) 
	values ('TestMovie'); 
-- Expected output: movie is added to database
-- Status: 			PASS

-- TEST 14) 
-- What's is being tested: 
select 'TEST 14: insert new associated Movie data when movie name is known' as '';
-- Input/setup: 
-- this query  only works when it is run after test 10 
-- MySQL supports LAST_INSERT_ID(), an it is only used for testing purposes
-- a better implementation is when the movieID for 1 movie is already known
insert into MovieCast(movieID, personID, role)
	values (LAST_INSERT_ID(),1,'TestCast');
-- Expected output: the 3 entries for MovieCast table are updated 
-- Status: 			PASS

-- TEST 15) 
-- What's is being tested: 
select 'TEST 15: update associated Movie data when movieID is known' as '';
-- Input/setup: 
-- assume that the movieID for the 1 movie is unique when repetition occur enter all movieID(s)
update MovieCast
	set 
		personID 	= 1,
		role 		= 'TestCast'
	where 
		movieID 	= 196606;
-- Expected output: personID and role entries for MovieCast table are updated 
-- Status: 			PASS

-- Simalar test cases for other associated tables

-- TEST 16)
-- What's is being tested: 
select 'TEST 16: update Movie data when movie name is known' as '';
-- Input/setup: 
-- Movie title is part of the Movies table
update Movies 
	set 
		releaseDate = '2003-08-17 00:00:00',
		budget = '27800',
		description = 'Test description'
	where 
		title = 'TestMovie';
-- Expected output: movie data is added to the Movies table 
-- Status: 			PASS