import express from 'express';
import session from 'express-session';
import cors from 'cors';
import bycrypt from 'bcrypt';
import cookieParser from 'cookie-parser';
import mysql from 'mysql2';

declare module 'express-session' {
    export interface SessionData {
        user: { [key: string]: any };
    }
}

const app = express();

app.use(express.json());
app.use(cookieParser())
app.use(cors({
    origin: ["http://localhost:3000"],
    methods: ["GET", "POST"],
    credentials: true
}));
app.use(session({
    name: "ECE356",
    secret: "Database Systems",
    resave: false,
    saveUninitialized: false,
    cookie: {
        maxAge: 60*60*24*1000,
        sameSite: true,
        secure: false
    }
}));

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

const runQuery = (query: string, params: any, res: any) => {
    pool.getConnection(function(err: any, connection: any) {
        if (err) {
            console.error(err);
            connection.release();
            return;
        }
        connection.query(query,
            params,
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

/**
 * Authentication APIs
 */

app.post('/api/register', (req, res) => {
    const username = req.body.username
    const password = req.body.password

    pool.getConnection(function(err: any, connection: any) {
        if (err) {
            console.error(err);
            connection.release();
            return;
        }
        connection.query("select userID from Users where lower(username)=?",
            username.toLowerCase(),
            (err: mysql.QueryError, result: any) => {
                if (err) {
                    console.error(err);
                } else if (!result.length) {
                    connection.release();
                    bycrypt.hash(password, 10, (err, hash) => {
                        runQuery("insert into Users (username, password) values (?, ?)", [username, hash],  res);
                    })
                    return;
                } else {
                    res.status(403).send({ message: "User already exists." });
                }
                connection.release();
            }
        );
    });
});

app.post('/api/signin', (req, res) => {
    const username = req.body.username;
    const password = req.body.password;
    
    pool.getConnection(function(err: any, connection: any) {
        if (err) {
            console.error(err);
            connection.release();
            return;
        }
        connection.query("select * from Users where lower(username)=?",
            username.toLowerCase(),
            (err: mysql.QueryError, result: any) => {
                if (err) {
                    console.error(err);
                } else if (result.length) {
                    bycrypt.compare(password, result[0].password, (error, response) => {
                        if (error) {
                            console.error(error);
                        } else if (response) {
                            req.session.user = result;
                            res.send(result);
                        } else {
                            res.status(403).send({ message: "Invalid password." })
                        }
                    });
                } else {
                    res.status(403).send({ message: "Invalid username." });
                }
                connection.release();
            }
        );
    });
});

app.get('/api/signin', (req, res) => {
    if (req.session.user) {
        res.send({ loginStatus: true, user: req.session.user });
    } else {
        res.send({ loginStatus: false });
    }
});

app.get('/api/signout', (req, res) => {
    if (req.session.user) {
        req.session.destroy((err) => {
            console.log("User signed out.");
        });
    }
    res.send({ loginStatus: false });
});

/**
 * Home Page Data APIs
 */

app.get('/api/latest', (req, res) => {
    runQuery("select movieID, originalTitle, year(releaseDate) as year from Movies where releaseDate <= curdate() order by releaseDate desc limit 10", [],  res);
});

app.get('/api/gross', (req, res) => {
    runQuery("select movieID, originalTitle, year(releaseDate) as year from Movies order by grossInternational desc limit 10", [],  res);
});

app.get('/api/birthday', (req, res) => {
    runQuery("select personID, name from People where day(birthDate) = day(curdate()) and month(birthDate) = month(curdate()) limit 10", [],  res);
});

/**
 * Search Page APIs
 */

app.post('/api/search', (req, res) => {
    const query = req.body.query;
    const type = req.body.type;

    switch(type) {
        case "movies":
            runQuery("select movieID, originalTitle, year(releaseDate) as year from Movies where lower(originalTitle) like lower('%" + query + "%')", [],  res);
            break;
        case "people":
            runQuery("select personID, name from People where lower(name) like lower('%" + query + "%')", [],  res);
            break;
        case "keyword":
            runQuery("select distinct Movies.movieID, originalTitle, year(releaseDate) as year from Movies inner join MovieKeyword on Movies.movieID=MovieKeyword.movieID where lower(originalTitle) like lower('%" + query + "%')", [],  res);
            break;
    }
});

/**
 * People Page APIs
 */

app.post('/api/person', (req, res) => {
    const personID = req.body.id;
    runQuery("select name, bio, date_format(birthDate, '%b %d, %Y') as birthDate, birthPlace, date_format(deathDate, '%b %d, %Y') as deathDate, deathPlace, deathCause, heightInCM, totalChildren from People where personID=?", [personID],  res);
});

app.post('/api/person/jobs', (req, res) => {
    const personID = req.body.id;
    runQuery("select MovieCrew.movieID, originalTitle, jobTitle from MovieCrew inner join Movies on MovieCrew.movieID=Movies.movieID where personID=?", personID,  res);
});

app.post('/api/person/roles', (req, res) => {
    const personID = req.body.id;
    runQuery("select MovieCast.movieID, originalTitle, role from MovieCast inner join Movies on MovieCast.movieID=Movies.movieID where personID=?", personID,  res);
});

/**
 * Movie Page APIs
 */

app.post('/api/movie', (req, res) => {
    const movieID = req.body.id;
    runQuery("select originalTitle, year(releaseDate) as year, date_format(releaseDate, '%b %d, %Y') as releaseDate, runTimeMinutes, description, budget, budgetCurrency, grossUSA, grossInternational, mpaa from Movies where movieID=?", movieID, res);
});

app.post('/api/movie/genre', (req, res) => {
    const movieID = req.body.id;
    runQuery("select distinct genre from MovieGenre where movieID=?", movieID, res);
});

app.post('/api/movie/language', (req, res) => {
    const movieID = req.body.id;
    runQuery("select distinct language from MovieLanguage where movieID=?", movieID,  res);
});

app.post('/api/movie/production', (req, res) => {
    const movieID = req.body.id;
    runQuery("select distinct companyName from MovieProductionCompany where movieID=?", movieID, res);
});

app.post('/api/movie/crew', (req, res) => {
    const movieID = req.body.id;
    runQuery("select name, People.personID, jobTitle from MovieCrew inner join People on MovieCrew.personID=People.personID where movieID=?", movieID, res);
});

app.post('/api/movie/cast', (req, res) => {
    const movieID = req.body.id;
    runQuery("select name, People.personID, role from MovieCast inner join People on MovieCast.personID=People.personID where movieID=?", movieID, res);
});

app.post('/api/movie/imdb', (req, res) => {
    const movieID = req.body.id;
    runQuery("select meanVote from RatingsIMDB where movieID=?", movieID, res);
});

app.post('/api/movie/tmdb', (req, res) => {
    const movieID = req.body.id;
    runQuery("select round(meanVote, 1) as meanVote from UserRatingsTMDB where movieID=?", movieID, res);
});

/**
 * Review APIs
 */
//TODO
