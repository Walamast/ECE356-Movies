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


-- Test 1) 
select 'Test 1: Select Production Company Names of a movie that is part of both MoviesIMDB.csv and MoviesTMDB.csv' as '';
-- While movies on MoviesIMDB.csv provides only 1 production company for a unique movie, MoviesTMDB.csv could provide multiple. 
-- As the SQL script that considers MoviesTMDB is run after the MoviesIMDB one, 
-- the following should return multiple production if Paradox is part of both datasets 
select distinct(companyName) as 'Production company names for Paradox' from Movies inner join MovieProductionCompany using (movieID) Where title = 'Paradox';

-- Test 2) 
select 'Test 2: Select Production Company Name of a movie that is only part of MoviesIMDB.csv' as '';
-- Assuming L'enfant de Paris is only part of MoviesIMDB, the following query should return only 1 production company  
select distinct(companyName) as "Production company names for L'enfant de Paris" from Movies inner join MovieProductionCompany using (movieID) Where title = "L'enfant de Paris";
-- it does

-- Test 3) 
select 'Test 3: Select Production Company Names of a movie that is only part of MoviesTMDB.csv' as '';
-- This type of query could return +1 production company names 
select distinct(companyName) as "Production company names for Dracula: Dead and Loving It" from Movies inner join MovieProductionCompany using (movieID) Where title = "Dracula: Dead and Loving It";
-- For this movie, there are 2 production companies

-- Test 4) 
select 'Test 4: No duplicated tuples (movieID, genre) in MovieGenre due to the enforcement of the primary key (movieID, genre) on it ' as '';
-- counts must be the same for the following commands as all duplicated entries should be deleted due to the primary key (movieID, genre) 
select count(*) as 'count all (movieID, genre) tuples' FROM MovieGenre;
select distinct count(*) as 'count distinct (movieID, genre) tuples' FROM MovieGenre;

-- Test 5) 
select 'Test 4: No duplicated tuples (movieID, language) in MovieLanguage due to the enforcement of the primary key (movieID, language) on it ' as '';
-- counts must be the same for the following commands as all duplicated entries should be deleted due to the primary key (movieID, genre) 
select count(*) as 'count all (movieID, language) tuples' FROM MovieLanguage;
select distinct count(*) as 'count distinct (movieID, language) tuples' FROM MovieLanguage;

-- Test 6) 
select '5 movies in English' as ''; 
-- There are 11320 movies in English but this test only outputs 5
select title from Movies inner join MovieLanguage using (movieID) where language = 'English' limit 5;

-- Test 7) 
select 'Distinct First names of people whose first name start with Fred' as '';
-- there are 296 "Fred"(s), but 746 people whose first name is Fred% with 23 different Fred% variations   
with People_distinct as 
	(select distinct name from People where name like 'Fred%'), 
	People_substring as 
	(select substring_index(name, ' ', 1) as ss_name from People_distinct)
select distinct ss_name from People_substring;



