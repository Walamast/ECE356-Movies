import express from 'express';
import cors from 'cors';
import * as mysql from 'mysql2';

const app = express();
app.use(cors());
app.use(express.json());
app.listen(3001, () => {
    console.log("Express started on port 3001.");
});

const user = ''; // MySQL user
const pass = ''; // MySQL pass
const pool = mysql.createPool({
    user: user,
    host: 'marmoset04.shoshin.uwaterloo.ca',
    password: pass,
    database: 'project_35',
});

const runQuery = (query: string, res: any) => {
    pool.getConnection(function(err: any, connection: any) {
        if (err) {
            console.error(err);
            connection.release();
            return;
        }
        connection.query(query,
            (err: mysql.QueryError, result: any) => {
                if (err) {
                    console.error(err);
                } else {
                    console.log(query);
                    res.send(result);
                }
                connection.release();
            }
        );
    });
}

app.get('/api/latest', (req, res) => {
    runQuery("select movieID, originalTitle, year(releaseDate) as year from Movies where releaseDate <= curdate() order by releaseDate desc limit 10", res);
});

app.get('/api/gross', (req, res) => {
    runQuery("select movieID, originalTitle, year(releaseDate) as year from Movies order by grossInternational desc limit 10", res);
});

app.get('/api/birthday', (req, res) => {
    runQuery("select personID, name from People where day(birthDate) = day(curdate()) and month(birthDate) = month(curdate()) limit 10", res);
});

app.post('/api/search', (req, res) => {
    const query = req.body.query;
    const type = req.body.type;

    switch(type) {
        case "movies":
            runQuery("select movieID, originalTitle, year(releaseDate) as year from Movies where lower(originalTitle) like lower('%" + query + "%')", res);
            break;
        case "people":
            runQuery("select personID, name from People where lower(name) like lower('%" + query + "%')", res);
            break;
        case "keyword":
            runQuery("select distinct Movies.movieID, originalTitle, year(releaseDate) as year from Movies inner join MovieKeyword on Movies.movieID=MovieKeyword.movieID where lower(originalTitle) like lower('%" + query + "%')", res);
            break;
    }
});

app.post('/api/person', (req, res) => {
    const personID = req.body.id
    runQuery("select name, bio, date_format(birthDate, '%b %d, %Y') as birthDate, birthPlace, date_format(deathDate, '%b %d, %Y') as deathDate, deathPlace, deathCause, heightInCM, totalChildren from People where personID=" + personID, res);
});

app.post('/api/person/jobs', (req, res) => {
    const personID = req.body.id
    runQuery("select MovieCrew.movieID, originalTitle, role from MovieCrew inner join Movies on MovieCrew.movieID=Movies.movieID where personID=" + personID, res);
});

app.post('/api/person/roles', (req, res) => {
    const personID = req.body.id
    runQuery("select MovieCast.movieID, originalTitle, role from MovieCast inner join Movies on MovieCast.movieID=Movies.movieID where personID=" + personID, res);
});

app.post('/api/movie', (req, res) => {
    const movieID = req.body.id
    runQuery("select originalTitle, year(releaseDate) as year, date_format(releaseDate, '%b %d, %Y') as releaseDate, runTimeMinutes, description, budget, budgetCurrency, grossUSA, grossInternational, mpaa from Movies where movieID=" + movieID, res);
});

app.post('/api/movie/genre', (req, res) => {
    const movieID = req.body.id
    runQuery("select distinct genre from MovieGenre where movieID=" + movieID, res);
});

app.post('/api/movie/language', (req, res) => {
    const movieID = req.body.id
    runQuery("select distinct language from MovieLanguage where movieID=" + movieID, res);
});

app.post('/api/movie/production', (req, res) => {
    const movieID = req.body.id
    runQuery("select distinct companyName from MovieProductionCompany where movieID=" + movieID, res);
});

app.post('/api/movie/crew', (req, res) => {
    const movieID = req.body.id
    runQuery("select name, People.personID, role from MovieCrew inner join People on MovieCrew.personID=People.personID where movieID=" + movieID, res);
});

app.post('/api/movie/cast', (req, res) => {
    const movieID = req.body.id
    runQuery("select name, People.personID, role from MovieCast inner join People on MovieCast.personID=People.personID where movieID=" + movieID, res);
});

app.post('/api/movie/imdb', (req, res) => {
    const movieID = req.body.id
    runQuery("select meanVote from RatingsIMDB where movieID=" + movieID, res);
});

app.post('/api/movie/tmdb', (req, res) => {
    const movieID = req.body.id
    runQuery("select round(meanVote, 1) as meanVote from UserRatingsTMDB where movieID=" + movieID, res);
});