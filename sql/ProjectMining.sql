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
select title,grossUSA from Movies where grossUSA is not null order by grossUSA desc limit 10; 

-- Part 2
-- Get movie genres for all the top 10 most profitable movies
with  	movieIDsForTop10 as 
			(select movieID from Movies where grossUSA is not null order by grossUSA desc limit 10),
		listofGenres as 
			(select ltrim(genre) as genreXD from MovieGenre inner join movieIDsForTop10 using (movieID))
select genreXD as 'Movie genres',count(*) as Count from listofGenres group by genreXD order by Count desc; 
