\! rm -f project-outfile.txt
tee project-outfile.txt;

warnings;

drop table if exists MovieProductionCompany;
drop table if exists MovieGenre;
drop table if exists MovieLanguage;
drop table if exists MovieCrew;
drop table if exists MovieCast;
drop table if exists MovieKeyword;
drop table if exists RatingsIMDB;
drop table if exists UserRatingsTMDB;
drop table if exists UserRatingDemographics;
drop table if exists Movies;
drop table if exists People;
drop table if exists Users;
drop table if exists UserRatings;

-- Create Movies table and fill it

create table Movies(movieID int auto_increment,
                    imdbID int default null,
                    tmdbID int default null,
                    title varchar(255),
                    originalTitle varchar(255),
                    releaseDate dateTime,
                    runTimeMinutes int,
                    description varchar(1000),
                    budget bigint,
                    budgetCurrency char(3),
                    grossUSA bigint,
                    grossInternational bigint,
                    mpaa char(5),
                    primary key (movieID),
                    unique(imdbID, tmdbID)
                    );

load data infile '/var/lib/mysql-files/03-Movies/Project35/AllMovies.csv' into table Movies
     fields terminated by ','
     enclosed by '"'
     lines terminated by '\r\n'
     ignore 1 lines
     (imdbID, tmdbID, title, originalTitle, releaseDate, runTimeMinutes, description, budget, budgetCurrency, grossUSA, grossInternational);

update Movies
set releaseDate = NULL
where releaseDate = "2025-01-01 00:00:00";

update Movies
set tmdbID = NULL
where tmdbID = -1;

create temporary table mpaa(imdbID int,
                            mpaa varchar(5),
                            primary key (imdbID)
                           );

load data infile '/var/lib/mysql-files/03-Movies/Project35/mpaaIMDBFixed.csv' into table mpaa
     fields terminated by ','
     enclosed by '"'
     lines terminated by '\r\n'
     ignore 1 lines
     (imdbID, mpaa);

update Movies inner join mpaa on Movies.imdbID = mpaa.imdbID
set Movies.mpaa = TRIM(mpaa.mpaa)
where Movies.imdbID = mpaa.imdbID;

update Movies set runTimeMinutes = NULL where runTimeMinutes = -1;
update Movies set budget = NULL where budget = -1;
update Movies set grossUSA = NULL where grossUSA = -1;
update Movies set grossInternational = NULL where grossInternational = -1;

create index imdbIDIndexMovies on Movies (imdbID);
create index tmdbIDIndexMovies on Movies (tmdbID);

-- People

create table People(personID int auto_increment,
                    imdbNameID char(10),
                    name varchar(255),
                    heightInCM int,
                    bio TEXT,
                    birthDate dateTime,
                    birthPlace varchar(255),
                    deathDate dateTime,
                    deathPlace varchar(255),
                    deathCause varchar(255),
                    totalChildren int,
                    primary key (personID)
                   );

create temporary table PeopleIMDB(imdbNameID char(10),
                                  name varchar(255),
                                  heightInCM int,
                                  bio TEXT,
                                  birthDate dateTime default null,
                                  birthPlace varchar (255) default null,
                                  deathDate dateTime default null,
                                  deathPlace varchar(255) default null,
                                  deathCause varchar(255) default null,
                                  totalChildren int,
                                  primary key (imdbNameID)
                                 );

load data infile '/var/lib/mysql-files/03-Movies/Project35/PeopleIMDB.csv' into table PeopleIMDB
     fields terminated by ','
     enclosed by '"'
     lines terminated by '\r\n'
     ignore 1 lines
     (imdbNameID, name, heightInCM, bio, birthDate, birthPlace, deathDate, deathPlace, deathCause, totalChildren);

update PeopleIMDB
set birthDate = NULL
where birthDate = '2025-01-01 00:00:00';

update PeopleIMDB
set deathDate = NULL
where deathDate = '2025-01-01 00:00:00';

insert into People (imdbNameID, name, heightInCM, bio, birthDate, birthPlace, deathDate, deathPlace, deathCause, totalChildren)
select imdbNameID, TRIM(name), heightInCM, TRIM(bio), birthDate, TRIM(birthPlace), deathDate, TRIM(deathPlace), TRIM(deathCause), totalChildren
from PeopleIMDB;

update People set heightInCM = NULL where heightInCM = -1;
update People set totalChildren = NULL where totalChildren = -1;

create index imdbIDIndexPeople on People (imdbNameID);

-- MovieProductionCompany

create table MovieProductionCompany(movieID int,
                                    companyName varchar(255),
                                    primary key (movieID, companyName),
                                    foreign key (movieID) references Movies (movieID) on delete cascade
                                   );

create temporary table MovieProductionCompanyIMDB(imdbID int,
                                                  companyName varChar(255),
                                                  movieID int,
                                                  primary key (imdbID)
                                                 );

load data infile '/var/lib/mysql-files/03-Movies/Project35/MovieProductionCompanyIMDBFixed.csv' into table MovieProductionCompanyIMDB
     fields terminated by ','
     enclosed by '"'
     lines terminated by '\r\n'
     ignore 1 lines
     (imdbID, companyName);

update MovieProductionCompanyIMDB inner join Movies on MovieProductionCompanyIMDB.imdbID = Movies.imdbID
set MovieProductionCompanyIMDB.movieID = Movies.movieID
where MovieProductionCompanyIMDB.imdbID = Movies.imdbID;

insert into MovieProductionCompany (movieID, companyName)
select movieID, TRIM(companyName)
from MovieProductionCompanyIMDB
where movieID IS NOT NULL;

create temporary table MovieProductionCompanyTMDB(tmdbID int,
                                                  companyName1 varChar(255),
                                                  companyName2 varChar(255),
                                                  companyName3 varChar(255),
                                                  companyName4 varChar(255),
                                                  companyName5 varChar(255),
                                                  companyName6 varChar(255),
                                                  companyName7 varChar(255),
                                                  companyName8 varChar(255),
                                                  companyName9 varChar(255),
                                                  companyName10 varChar(255),
                                                  companyName11 varChar(255),
                                                  companyName12 varChar(255),
                                                  companyName13 varChar(255),
                                                  companyName14 varChar(255),
                                                  companyName15 varChar(255),
                                                  companyName16 varChar(255),
                                                  companyName17 varChar(255),
                                                  companyName18 varChar(255),
                                                  companyName19 varChar(255),
                                                  companyName20 varChar(255),
                                                  movieID int,
                                                  primary key (tmdbID)
                                                 );

load data infile '/var/lib/mysql-files/03-Movies/Project35/MovieProductionDataTMDB.csv' into table MovieProductionCompanyTMDB
     fields terminated by ','
     enclosed by '"'
     lines terminated by '\r\n'
     ignore 1 lines
     (tmdbID, companyName1, companyName2, companyName3, companyName4, companyName5, companyName6, companyName7, companyName8, companyName9, companyName10, companyName11, companyName12, companyName13, companyName14, companyName15, companyName16, companyName17, companyName18, companyName19, companyName20);

update MovieProductionCompanyTMDB inner join Movies on MovieProductionCompanyTMDB.tmdbID = Movies.tmdbID
set MovieProductionCompanyTMDB.movieID = Movies.movieID
where MovieProductionCompanyTMDB.tmdbID = Movies.tmdbID;

insert ignore into MovieProductionCompany (movieID, companyName) select movieID, TRIM(companyName1) from MovieProductionCompanyTMDB where movieID IS NOT NULL and companyName1 <> '';
insert ignore into MovieProductionCompany (movieID, companyName) select movieID, TRIM(companyName2) from MovieProductionCompanyTMDB where movieID IS NOT NULL and companyName2 <> '';
insert ignore into MovieProductionCompany (movieID, companyName) select movieID, TRIM(companyName3) from MovieProductionCompanyTMDB where movieID IS NOT NULL and companyName3 <> '';
insert ignore into MovieProductionCompany (movieID, companyName) select movieID, TRIM(companyName4) from MovieProductionCompanyTMDB where movieID IS NOT NULL and companyName4 <> '';
insert ignore into MovieProductionCompany (movieID, companyName) select movieID, TRIM(companyName5) from MovieProductionCompanyTMDB where movieID IS NOT NULL and companyName5 <> ''; 
insert ignore into MovieProductionCompany (movieID, companyName) select movieID, TRIM(companyName6) from MovieProductionCompanyTMDB where movieID IS NOT NULL and companyName6 <> '';
insert ignore into MovieProductionCompany (movieID, companyName) select movieID, TRIM(companyName7) from MovieProductionCompanyTMDB where movieID IS NOT NULL and companyName7 <> '';
insert ignore into MovieProductionCompany (movieID, companyName) select movieID, TRIM(companyName8) from MovieProductionCompanyTMDB where movieID IS NOT NULL and companyName8 <> '';
insert ignore into MovieProductionCompany (movieID, companyName) select movieID, TRIM(companyName9) from MovieProductionCompanyTMDB where movieID IS NOT NULL and companyName9 <> '';
insert ignore into MovieProductionCompany (movieID, companyName) select movieID, TRIM(companyName10) from MovieProductionCompanyTMDB where movieID IS NOT NULL and companyName10 <> '';
insert ignore into MovieProductionCompany (movieID, companyName) select movieID, TRIM(companyName11) from MovieProductionCompanyTMDB where movieID IS NOT NULL and companyName11 <> '';
insert ignore into MovieProductionCompany (movieID, companyName) select movieID, TRIM(companyName12) from MovieProductionCompanyTMDB where movieID IS NOT NULL and companyName12 <> '';
insert ignore into MovieProductionCompany (movieID, companyName) select movieID, TRIM(companyName13) from MovieProductionCompanyTMDB where movieID IS NOT NULL and companyName13 <> '';
insert ignore into MovieProductionCompany (movieID, companyName) select movieID, TRIM(companyName14) from MovieProductionCompanyTMDB where movieID IS NOT NULL and companyName14 <> '';
insert ignore into MovieProductionCompany (movieID, companyName) select movieID, TRIM(companyName15) from MovieProductionCompanyTMDB where movieID IS NOT NULL and companyName15 <> '';
insert ignore into MovieProductionCompany (movieID, companyName) select movieID, TRIM(companyName16) from MovieProductionCompanyTMDB where movieID IS NOT NULL and companyName16 <> '';
insert ignore into MovieProductionCompany (movieID, companyName) select movieID, TRIM(companyName17) from MovieProductionCompanyTMDB where movieID IS NOT NULL and companyName17 <> '';
insert ignore into MovieProductionCompany (movieID, companyName) select movieID, TRIM(companyName18) from MovieProductionCompanyTMDB where movieID IS NOT NULL and companyName18 <> '';
insert ignore into MovieProductionCompany (movieID, companyName) select movieID, TRIM(companyName19) from MovieProductionCompanyTMDB where movieID IS NOT NULL and companyName19 <> '';
insert ignore into MovieProductionCompany (movieID, companyName) select movieID, TRIM(companyName20) from MovieProductionCompanyTMDB where movieID IS NOT NULL and companyName20 <> '';

-- MovieGenre

create table MovieGenre(movieID int,
                        genre varchar(15),
                        primary key (movieID, genre),
                        foreign key (movieID) references Movies (movieID)  on delete cascade
                       );

create temporary table MovieGenreIMDB(imdbID int,
                                      genre1 varchar(11),
                                      genre2 varchar(11),
                                      genre3 varchar(11),
                                      movieID int,
                                      primary key (imdbID)
                                     );

load data infile '/var/lib/mysql-files/03-Movies/Project35/MovieGenreIMDBFixed.csv' into table MovieGenreIMDB
     fields terminated by ','
     enclosed by '"'
     lines terminated by '\r\n'
     ignore 1 lines
     (imdbID, genre1, genre2, genre3);

update MovieGenreIMDB inner join Movies on MovieGenreIMDB.imdbID = Movies.imdbID
set MovieGenreIMDB.movieID = Movies.movieID
where MovieGenreIMDB.imdbID = Movies.imdbID;

insert ignore into MovieGenre (movieID, genre) select movieID, TRIM(genre1) from MovieGenreIMDB where movieID IS NOT NULL and genre1 <> '';
insert ignore into MovieGenre (movieID, genre) select movieID, TRIM(genre2) from MovieGenreIMDB where movieID IS NOT NULL and genre2 <> '';
insert ignore into MovieGenre (movieID, genre) select movieID, TRIM(genre3) from MovieGenreIMDB where movieID IS NOT NULL and genre3 <> '';

create temporary table MovieGenreTMDB(tmdbID char(10),
                                      genre1 varchar(15),
                                      genre2 varchar(15),
                                      genre3 varchar(15),
                                      genre4 varchar(15),
                                      genre5 varchar(15),
                                      genre6 varchar(15),
                                      movieID int,
                                      primary key (tmdbID)
                                     );

load data infile '/var/lib/mysql-files/03-Movies/Project35/MovieGenreTMDB.csv' into table MovieGenreTMDB
     fields terminated by ','
     enclosed by '"'
     lines terminated by '\r\n'
     ignore 1 lines
     (tmdbID, genre1, genre2, genre3, genre4, genre5, genre6);

update MovieGenreTMDB inner join Movies on MovieGenreTMDB.tmdbID = Movies.tmdbID
set MovieGenreTMDB.movieID = Movies.movieID
where MovieGenreTMDB.tmdbID = Movies.tmdbID;

insert ignore into MovieGenre (movieID, genre) select movieID, TRIM(genre1) from MovieGenreTMDB where movieID IS NOT NULL and genre1 <> '';
insert ignore into MovieGenre (movieID, genre) select movieID, TRIM(genre2) from MovieGenreTMDB where movieID IS NOT NULL and genre2 <> '';
insert ignore into MovieGenre (movieID, genre) select movieID, TRIM(genre3) from MovieGenreTMDB where movieID IS NOT NULL and genre3 <> '';
insert ignore into MovieGenre (movieID, genre) select movieID, TRIM(genre4) from MovieGenreTMDB where movieID IS NOT NULL and genre4 <> '';
insert ignore into MovieGenre (movieID, genre) select movieID, TRIM(genre5) from MovieGenreTMDB where movieID IS NOT NULL and genre5 <> '';
insert ignore into MovieGenre (movieID, genre) select movieID, TRIM(genre6) from MovieGenreTMDB where movieID IS NOT NULL and genre6 <> '';

-- MovieLanguage

create table MovieLanguage(movieID int,
                           language varchar(37),
                           primary key (movieID, language),
                           foreign key (movieID) references Movies (movieID)  on delete cascade
                          );

create temporary table MovieLanguageIMDB (imdbID int,
                                          language1 varchar(25),
                                          language2 varchar(25),
                                          movieID int,
                                          primary key (imdbID)
                                         );

load data infile '/var/lib/mysql-files/03-Movies/Project35/MovieLanguageIMDBFixed.csv' into table MovieLanguageIMDB
     fields terminated by ','
     enclosed by '"'
     lines terminated by '\r\n'
     ignore 1 lines
     (imdbID, language1, language2);

update MovieLanguageIMDB inner join Movies on MovieLanguageIMDB.imdbID = Movies.imdbID
set MovieLanguageIMDB.movieID = Movies.movieID
where MovieLanguageIMDB.imdbID = Movies.imdbID;

insert ignore into MovieLanguage (movieID, language) select movieID, TRIM(language1) from MovieLanguageIMDB where movieID IS NOT NULL and language1 <> '';
insert ignore into MovieLanguage (movieID, language) select movieID, TRIM(language2) from MovieLanguageIMDB where movieID IS NOT NULL and language2 <> '';

create temporary table MovieLanguageTMDB (tmdbID int,
                                          language1 varchar(37),
                                          language2 varchar(37),
                                          language3 varchar(37),
                                          language4 varchar(37),
                                          movieID int,
                                          primary key (tmdbID)
                                         );

load data infile '/var/lib/mysql-files/03-Movies/Project35/MovieLanguageTMDBFixed.csv' into table MovieLanguageTMDB
     fields terminated by ','
     enclosed by '"'
     lines terminated by '\r\n'
     ignore 1 lines
     (tmdbID, Language1, Language2, Language3, Language4);

update MovieLanguageTMDB inner join Movies on MovieLanguageTMDB.tmdbID = Movies.tmdbID
set MovieLanguageTMDB.movieID = Movies.movieID
where MovieLanguageTMDB.tmdbID = Movies.tmdbID;

insert ignore into MovieLanguage (movieID, language) select movieID, TRIM(language1) from MovieLanguageTMDB where movieID IS NOT NULL and language1 <> '';
insert ignore into MovieLanguage (movieID, language) select movieID, TRIM(language2) from MovieLanguageTMDB where movieID IS NOT NULL and language2 <> '';
insert ignore into MovieLanguage (movieID, language) select movieID, TRIM(language3) from MovieLanguageTMDB where movieID IS NOT NULL and language3 <> '';
insert ignore into MovieLanguage (movieID, language) select movieID, TRIM(language4) from MovieLanguageTMDB where movieID IS NOT NULL and language4 <> '';

delete from MovieLanguage where language = '';

-- Temp table for use in two tables below

create temporary table IMDBtitlePrinciples(imdbID int,
                                       imdbNameID char(10),
                                       category varchar(19),
                                       role varchar(255),
                                       movieID int,
                                       personID int,
                                       primary key (imdbID, imdbNameID, category, role)
                                      );

load data infile '/var/lib/mysql-files/03-Movies/Project35/IMDBtitlePrinciplesFixed.csv' into table IMDBtitlePrinciples
     fields terminated by ','
     enclosed by '"'
     lines terminated by '\r\n'
     ignore 1 lines
     (imdbID, imdbNameID, category, role);

create index imdbNameIndex on IMDBtitlePrinciples (imdbNameID);

update IMDBtitlePrinciples inner join Movies on IMDBtitlePrinciples.imdbID = Movies.imdbID
set IMDBtitlePrinciples.movieID = Movies.movieID
where IMDBtitlePrinciples.imdbID = Movies.imdbID;

update IMDBtitlePrinciples inner join People on IMDBtitlePrinciples.imdbNameID = People.imdbNameID
set IMDBtitlePrinciples.personID = People.personID
where IMDBtitlePrinciples.imdbNameID = People.imdbNameID;

-- MovieCrew

create table MovieCrew(movieID int,
                       personID int,
                       jobTitle varchar(255),
                       primary key (movieID, personID, jobTitle),
                       foreign key (movieID) references Movies (movieID)  on delete cascade,
                       foreign key (personID) references People (personID)  on delete cascade
                      );

insert into MovieCrew (movieID, personID, jobTitle) select movieID, personID, TRIM(category) from IMDBtitlePrinciples where movieID IS NOT NULL and personID IS NOT NULL and category <> '';

-- MovieCast

create table MovieCast(movieID int,
                       personID int,
                       role varchar(255),
                       primary key (movieID, personID, role),
                       foreign key (movieID) references Movies (movieID)  on delete cascade,
                       foreign key (personID) references People (personID)  on delete cascade
                      );

insert into MovieCast (movieID, personID, role) select movieID, personID, TRIM(role) from IMDBtitlePrinciples where movieID IS NOT NULL and personID IS NOT NULL and role <> '';

-- MovieKeyword

create table MovieKeyword(movieID int,
                          keyword varchar(50),
                          primary key (movieID, keyword),
                          foreign key (movieID) references Movies (movieID)  on delete cascade
                         );

create temporary table keywords(tmdbID int,
                                keyword1 varchar(50),
                                keyword2 varchar(50),
                                keyword3 varchar(50),
                                keyword4 varchar(50),
                                keyword5 varchar(50),
                                keyword6 varchar(50),
                                keyword7 varchar(50),
                                keyword8 varchar(50),
                                keyword9 varchar(50),
                                keyword10 varchar(50),
                                keyword11 varchar(50),
                                keyword12 varchar(50),
                                keyword13 varchar(50),
                                keyword14 varchar(50),
                                keyword15 varchar(50),
                                keyword16 varchar(50),
                                keyword17 varchar(50),
                                keyword18 varchar(50),
                                keyword19 varchar(50),
                                keyword20 varchar(50),
                                keyword21 varchar(50),
                                keyword22 varchar(50),
                                keyword23 varchar(50),
                                keyword24 varchar(50),
                                keyword25 varchar(50),
                                keyword26 varchar(50),
                                keyword27 varchar(50),
                                keyword28 varchar(50),
                                keyword29 varchar(50),
                                keyword30 varchar(50),
                                keyword31 varchar(50),
                                keyword32 varchar(50),
                                keyword33 varchar(50),
                                keyword34 varchar(50),
                                keyword35 varchar(50),
                                keyword36 varchar(50),
                                keyword37 varchar(50),
                                keyword38 varchar(50),
                                keyword39 varchar(50),
                                keyword40 varchar(50),
                                keyword41 varchar(50),
                                movieID int, 
                                primary key (tmdbID)
                               );

load data infile '/var/lib/mysql-files/03-Movies/Project35/keywords.csv' into table keywords
     fields terminated by ','
     enclosed by '"'
     lines terminated by '\r\n'
     ignore 1 lines
     (tmdbID, keyword1, keyword2, keyword3, keyword4, keyword5, keyword6, keyword7, keyword8, keyword9, keyword10, keyword11, keyword12, keyword13, keyword14, keyword15, keyword16, keyword17, keyword18, keyword19, keyword20, keyword21, keyword22, keyword23, keyword24, keyword25, keyword26, keyword27, keyword28, keyword29, keyword30, keyword31, keyword32, keyword33, keyword34, keyword35, keyword36, keyword37, keyword38, keyword39, keyword40, keyword41);

update keywords inner join Movies on keywords.tmdbID = Movies.tmdbID
set keywords.movieID = Movies.movieID
where keywords.tmdbID = Movies.tmdbID;

insert into MovieKeyword (movieID, keyword) select movieID, TRIM(keyword1) from keywords where movieID IS NOT NULL and keyword1 <> '';
insert into MovieKeyword (movieID, keyword) select movieID, TRIM(keyword2) from keywords where movieID IS NOT NULL and keyword2 <> '';
insert into MovieKeyword (movieID, keyword) select movieID, TRIM(keyword3) from keywords where movieID IS NOT NULL and keyword3 <> '';
insert into MovieKeyword (movieID, keyword) select movieID, TRIM(keyword4) from keywords where movieID IS NOT NULL and keyword4 <> '';
insert into MovieKeyword (movieID, keyword) select movieID, TRIM(keyword5) from keywords where movieID IS NOT NULL and keyword5 <> '';
insert into MovieKeyword (movieID, keyword) select movieID, TRIM(keyword6) from keywords where movieID IS NOT NULL and keyword6 <> '';
insert into MovieKeyword (movieID, keyword) select movieID, TRIM(keyword7) from keywords where movieID IS NOT NULL and keyword7 <> '';
insert into MovieKeyword (movieID, keyword) select movieID, TRIM(keyword8) from keywords where movieID IS NOT NULL and keyword8 <> '';
insert into MovieKeyword (movieID, keyword) select movieID, TRIM(keyword9) from keywords where movieID IS NOT NULL and keyword9 <> '';
insert into MovieKeyword (movieID, keyword) select movieID, TRIM(keyword10) from keywords where movieID IS NOT NULL and keyword10 <> '';
insert into MovieKeyword (movieID, keyword) select movieID, TRIM(keyword11) from keywords where movieID IS NOT NULL and keyword11 <> '';
insert into MovieKeyword (movieID, keyword) select movieID, TRIM(keyword12) from keywords where movieID IS NOT NULL and keyword12 <> '';
insert into MovieKeyword (movieID, keyword) select movieID, TRIM(keyword13) from keywords where movieID IS NOT NULL and keyword13 <> '';
insert into MovieKeyword (movieID, keyword) select movieID, TRIM(keyword14) from keywords where movieID IS NOT NULL and keyword14 <> '';
insert into MovieKeyword (movieID, keyword) select movieID, TRIM(keyword15) from keywords where movieID IS NOT NULL and keyword15 <> '';
insert into MovieKeyword (movieID, keyword) select movieID, TRIM(keyword16) from keywords where movieID IS NOT NULL and keyword16 <> '';
insert into MovieKeyword (movieID, keyword) select movieID, TRIM(keyword17) from keywords where movieID IS NOT NULL and keyword17 <> '';
insert into MovieKeyword (movieID, keyword) select movieID, TRIM(keyword18) from keywords where movieID IS NOT NULL and keyword18 <> '';
insert into MovieKeyword (movieID, keyword) select movieID, TRIM(keyword19) from keywords where movieID IS NOT NULL and keyword19 <> '';
insert into MovieKeyword (movieID, keyword) select movieID, TRIM(keyword20) from keywords where movieID IS NOT NULL and keyword20 <> '';
insert into MovieKeyword (movieID, keyword) select movieID, TRIM(keyword21) from keywords where movieID IS NOT NULL and keyword21 <> '';
insert into MovieKeyword (movieID, keyword) select movieID, TRIM(keyword22) from keywords where movieID IS NOT NULL and keyword22 <> '';
insert into MovieKeyword (movieID, keyword) select movieID, TRIM(keyword23) from keywords where movieID IS NOT NULL and keyword23 <> '';
insert into MovieKeyword (movieID, keyword) select movieID, TRIM(keyword24) from keywords where movieID IS NOT NULL and keyword24 <> '';
insert into MovieKeyword (movieID, keyword) select movieID, TRIM(keyword25) from keywords where movieID IS NOT NULL and keyword25 <> '';
insert into MovieKeyword (movieID, keyword) select movieID, TRIM(keyword26) from keywords where movieID IS NOT NULL and keyword26 <> '';
insert into MovieKeyword (movieID, keyword) select movieID, TRIM(keyword27) from keywords where movieID IS NOT NULL and keyword27 <> '';
insert into MovieKeyword (movieID, keyword) select movieID, TRIM(keyword28) from keywords where movieID IS NOT NULL and keyword28 <> '';
insert into MovieKeyword (movieID, keyword) select movieID, TRIM(keyword29) from keywords where movieID IS NOT NULL and keyword29 <> '';
insert into MovieKeyword (movieID, keyword) select movieID, TRIM(keyword30) from keywords where movieID IS NOT NULL and keyword30 <> '';
insert into MovieKeyword (movieID, keyword) select movieID, TRIM(keyword31) from keywords where movieID IS NOT NULL and keyword31 <> '';
insert into MovieKeyword (movieID, keyword) select movieID, TRIM(keyword32) from keywords where movieID IS NOT NULL and keyword32 <> '';
insert into MovieKeyword (movieID, keyword) select movieID, TRIM(keyword33) from keywords where movieID IS NOT NULL and keyword33 <> '';
insert into MovieKeyword (movieID, keyword) select movieID, TRIM(keyword34) from keywords where movieID IS NOT NULL and keyword34 <> '';
insert into MovieKeyword (movieID, keyword) select movieID, TRIM(keyword35) from keywords where movieID IS NOT NULL and keyword35 <> '';
insert into MovieKeyword (movieID, keyword) select movieID, TRIM(keyword36) from keywords where movieID IS NOT NULL and keyword36 <> '';
insert into MovieKeyword (movieID, keyword) select movieID, TRIM(keyword37) from keywords where movieID IS NOT NULL and keyword37 <> '';
insert into MovieKeyword (movieID, keyword) select movieID, TRIM(keyword38) from keywords where movieID IS NOT NULL and keyword38 <> '';
insert into MovieKeyword (movieID, keyword) select movieID, TRIM(keyword39) from keywords where movieID IS NOT NULL and keyword39 <> '';
insert into MovieKeyword (movieID, keyword) select movieID, TRIM(keyword40) from keywords where movieID IS NOT NULL and keyword40 <> '';
insert into MovieKeyword (movieID, keyword) select movieID, TRIM(keyword41) from keywords where movieID IS NOT NULL and keyword41 <> '';

-- RatingsIMDB

create table RatingsIMDB(movieID int,
                        totalVotes int,
                        meanVote float,
                        medianVote int,
                        primary key (movieID),
                        foreign key (movieID) references Movies (movieID)  on delete cascade
                       );

create temporary table tempRatingsIMDB(imdbID int,
                                       totalVotes int,
                                       meanVote float,
                                       medianVote int,
                                       movieID int,
                                       primary key(imdbID)
                                      );
                              
load data infile '/var/lib/mysql-files/03-Movies/Project35/RatingsIMDBFixed.csv' into table tempRatingsIMDB
     fields terminated by ','
     enclosed by '"'
     lines terminated by '\r\n'
     ignore 1 lines
     (imdbID, totalVotes, meanVote, medianVote);

update tempRatingsIMDB inner join Movies on tempRatingsIMDB.imdbID = Movies.imdbID
set tempRatingsIMDB.movieID = Movies.movieID
where tempRatingsIMDB.imdbID = Movies.imdbID;

insert into RatingsIMDB (movieID, totalVotes, meanVote, medianVote) select movieID, totalVotes, meanVote, medianVote from tempRatingsIMDB where movieID IS NOT NULL;

update RatingsIMDB set totalVotes = NULL where totalVotes = -1;
update RatingsIMDB set meanVote = NULL where meanVote = -1;
update RatingsIMDB set medianVote = NULL where medianVote = -1;

-- UserRatingsTMDB

create table UserRatingsTMDB(movieID int,
                             totalVotes int,
                             meanVote float,
                             medianVote float,
                             primary key (movieID),
                             foreign key (movieID) references Movies (movieID)  on delete cascade
                            );

create temporary table tempRatingsTMDB(tmdbID int,
                                       totalVotes int,
                                       meanVote float,
                                       medianVote float,
                                       movieID int,
                                       primary key (tmdbID)
                                      );

load data infile '/var/lib/mysql-files/03-Movies/Project35/UserRatingsAggregated.csv' into table tempRatingsTMDB
     fields terminated by ','
     enclosed by '"'
     lines terminated by '\r\n'
     ignore 1 lines
     (tmdbID, totalVotes, meanVote, medianVote);

update tempRatingsTMDB inner join Movies on tempRatingsTMDB.tmdbID = Movies.tmdbID
set tempRatingsTMDB.movieID = Movies.movieID
where tempRatingsTMDB.tmdbID = Movies.tmdbID;

insert into UserRatingsTMDB (movieID, totalVotes, meanVote, medianVote) select movieID, totalVotes, meanVote, medianVote from tempRatingsTMDB where movieID IS NOT NULL;

update UserRatingsTMDB set totalVotes = NULL where totalVotes = -1;
update UserRatingsTMDB set meanVote = NULL where meanVote = -1;
update UserRatingsTMDB set medianVote = NULL where medianVote = -1;

-- UserRatingDemographics

create table UserRatingDemographics(movieID int,
                                    gender char(1) default null,
                                    ageStart int,
                                    meanVote float,
                                    unique (movieID, gender, ageStart),
                                    foreign key (movieID) references Movies (movieID) on delete cascade
                                   );

create temporary table UserDemoTemp(imdbID int,
                                    age0Male float,
                                    age18Male float,
                                    age30Male float,
                                    age45Male float,
                                    age0Female float,
                                    age18Female float,
                                    age30Female float,
                                    age45Female float,
                                    movieID int,
                                    primary key (imdbID)
                                   );

load data infile '/var/lib/mysql-files/03-Movies/Project35/UserRatingDemographicsFixed.csv' into table UserDemoTemp
     fields terminated by ','
     enclosed by '"'
     lines terminated by '\r\n'
     ignore 1 lines
     (imdbID, age0Male, age18Male, age30Male, age45Male, age0Female, age18Female, age30Female, age45Female);

update UserDemoTemp inner join Movies on UserDemoTemp.imdbID = Movies.imdbID
set UserDemoTemp.movieID = Movies.movieID
where UserDemoTemp.imdbID = Movies.imdbID;

insert into UserRatingDemographics (movieID, meanVote) select movieID, age0Male from UserDemoTemp;
update UserRatingDemographics set ageStart = 0 where ageStart IS NULL;
insert into UserRatingDemographics (movieID, meanVote) select movieID, age18Male from UserDemoTemp;
update UserRatingDemographics set ageStart = 18 where ageStart IS NULL;
insert into UserRatingDemographics (movieID, meanVote) select movieID, age30Male from UserDemoTemp;
update UserRatingDemographics set ageStart = 30 where ageStart IS NULL;
insert into UserRatingDemographics (movieID, meanVote) select movieID, age45Male from UserDemoTemp;
update UserRatingDemographics set ageStart = 45 where ageStart IS NULL;
update UserRatingDemographics set gender = 'M' where gender IS NULL;

insert into UserRatingDemographics (movieID, meanVote) select movieID, age0Female from UserDemoTemp;
update UserRatingDemographics set ageStart = 0 where ageStart IS NULL;
insert into UserRatingDemographics (movieID, meanVote) select movieID, age18Female from UserDemoTemp;
update UserRatingDemographics set ageStart = 18 where ageStart IS NULL;
insert into UserRatingDemographics (movieID, meanVote) select movieID, age30Female from UserDemoTemp;
update UserRatingDemographics set ageStart = 30 where ageStart IS NULL;
insert into UserRatingDemographics (movieID, meanVote) select movieID, age45Female from UserDemoTemp;
update UserRatingDemographics set ageStart = 45 where ageStart IS NULL;
update UserRatingDemographics set gender = 'F' where gender IS NULL;

delete from UserRatingDemographics where movieID IS NULL or gender IS NULL or ageStart IS NULL;

alter table UserRatingDemographics alter gender drop default;
alter table UserRatingDemographics modify movieID int not null, modify gender char(1) not null, modify ageStart int not null;
alter table UserRatingDemographics add primary key (movieID, gender, ageStart);

update UserRatingDemographics set meanVote = null where meanVote = -1;

-- Users

create table Users(userID int auto_increment,
                   username varchar(255),
                   password varchar(255),
                   primary key (userID),
                   unique (username)
                  );

-- UserRatings

create table UserRatings(userID int,
                         movieID int,
                         rating int,
                         primary key (userID, movieID),
                         foreign key (userID) references Users(userID) on delete cascade,
                         foreign key (movieID) references Movies(movieID) on delete cascade,
                         check (rating > 0 and rating <= 10)
                        );

-- finish
nowarning;
notee;