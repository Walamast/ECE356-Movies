-- -----------------------------------------------------------------------------
--
-- ECE 356 Project
-- testcase script
-- 
-- Walter Alejandro Lam Astudillo	walamast
-- Bruce Nguyen						b34nguye
-- Darius Andrew Wigglesworth		dawiggle
--
-- This file writes into testcases-serverside.txt the outputs for the testcases written on serverside-tests.sql 
-- 


\! rm -f testcases-serverside.txt
warnings;

tee testcases-serverside.txt
use project_35; 

source ./serverside-tests.sql;

nowarning
notee