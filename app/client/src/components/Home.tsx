import './Home.scss';
import { useState, useEffect } from 'react';

function Home() {
  const [latestMovies, setLatestMovies] = useState([]);
  const [topGrossMovies, setTopGrossMovies] = useState([]);
  const [bornToday, setBornToday] = useState([]);

  const getData = () => {
    fetch("http://localhost:3001/api/latest", { method: 'GET' })
    .then(function(response) {
      return response.json();
    }).then(function(json: any) {
      setLatestMovies(json);
    }).catch(function(err: any) {
      console.error(err);
    });

    fetch("http://localhost:3001/api/gross", { method: 'GET' })
    .then(function(response) {
      return response.json();
    }).then(function(json: any) {
      setTopGrossMovies(json);
    }).catch(function(err: any) {
      console.error(err);
    });

    fetch("http://localhost:3001/api/birthday", { method: 'GET' })
    .then(function(response) {
      return response.json();
    }).then(function(json: any) {
      setBornToday(json);
    }).catch(function(err: any) {
      console.error(err);
    });
  }

  useEffect(() => { getData() }, []);

  return (
    <div className="home">
      <div className="row">
        <div className="col-sm">
          <h2>Latest Releases</h2>
          <ul>
            {latestMovies.map((val: any, key: any) => {
              const url = "/movie/" + val.movieID;
              return (<li key={key}><a href={url}>{val.originalTitle}{val.year ? " (" + val.year + ")" : ""}</a></li>);
            })}
          </ul>
        </div>
        <div className="col-sm">
          <h2>Highest Grossing (International)</h2>
          <ul>
            {topGrossMovies.map((val: any, key: any) => {
              const url = "/movie/" + val.movieID;
              return (<li key={key}><a href={url}>{val.originalTitle}{val.year ? " (" + val.year + ")" : ""}</a></li>);
            })}
          </ul>
        </div>
        <div className="col-sm">
          <h2>People Born Today</h2>
          <ul>
            {bornToday.map((val: any, key: any) => {
              const url = "/people/" + val.personID;
              return (<li key={key}><a href={url}>{val.name}</a></li>);
            })}
          </ul>
        </div>
      </div>
    </div>
  );
}

export default Home;
