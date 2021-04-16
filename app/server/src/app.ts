import express from 'express';
import cors from 'cors';
import * as mysql from 'mysql2';

const app = express();
app.use(cors());
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
                res.send(result);
            }
            connection.release();
        });
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

// select movieID, title from Movies where releaseDate < curdate() order by releaseDate desc limit 10;
