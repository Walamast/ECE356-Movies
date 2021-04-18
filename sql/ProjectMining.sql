-- -----------------------------------------------------------------------------
--
-- ECE 356 Project
-- Data Mining
-- 
-- Walter Alejandro Lam Astudillo	walamast
-- Bruce Nguyen						b34nguye
-- Darius Andrew Wigglesworth		dawiggle
--
-- This file includes various queries used in the data mining
-- analysis of our project.
-- 

-- Part 1
-- The top 10 most USA gross profitable movies are  
select originalTitle as 'Original Title',grossUSA from Movies where grossUSA is not null order by grossUSA desc limit 50; 

-- Part 2
-- Get movie genres for all the top 50 most profitable movies
with  	movieIDsForTop50 as 
			(select movieID from Movies where grossUSA is not null order by grossUSA desc limit 50),
		listofGenres as 
			(select ltrim(genre) as genreXD from MovieGenre inner join movieIDsForTop50 using (movieID))
select genreXD as 'Movie genres',count(*) as Count from listofGenres group by genreXD order by Count desc; 

-- Part 3
-- Get movie release years for all the top 50 most profitable movies
with  	movieIDsForTop50 as 
			(select movieID from Movies where grossUSA is not null order by grossUSA desc limit 50),
		listofYears as 
			(select year(releaseDate) as releaseDateXD from Movies inner join movieIDsForTop50 using (movieID))
select releaseDateXD as 'Movie Release Years',count(*) as Counter from listofYears group by releaseDateXD order by Counter desc, releaseDateXD desc; 

-- Data mining final query
-- Select top 25 movies and their USA gross income that are not part of the top 50 highest movies by USA gross income 
-- and that meet the found frequently ocurring related attributes of the top 50 highest movies by USA gross income from the data mining analysis\
-- attributes include being and Adventure, action or sci-fi movie that was released betweeen 2016 and 2019, had a mean votes higher than 7.61 and a median vote of 7.76
with  	movieIDsForAdventureactionscifi as 
			(select movieID,releaseDate from Movies inner join MovieGenre using (movieID) where genre = 'Adventure' or genre = 'Action' or genre = 'Sci-Fi'), 
		movieIDsFor20162019Adventureactionscifi as 		
			(select movieID from movieIDsForAdventureactionscifi where year(releaseDate) > 2016 and year(releaseDate) < 2019),
		highratedmovieIDsFor20162019Adventureactionscifi as
			(select movieID from movieIDsFor20162019Adventureactionscifi inner join RatingsIMDB using (movieID) where meanVote > 7.61 and medianVote > 7.76)
select distinct(originalTitle) as 'Original Title',grossUSA as 'USA Gross income' from highratedmovieIDsFor20162019Adventureactionscifi inner join Movies using (movieID) 
		where grossUSA is not null and grossUSA < 364001123 order by grossUSA desc LIMIT 10; 
