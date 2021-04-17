import { useState, useEffect } from 'react';
import './Movie.scss';
import logo from '../assets/logo512.png'

const Movie = (data: any) => {
  const [results, setResults] = useState([]);
  const [genres, setGenres] = useState([]);
  const [languages, setLanguages] = useState([]);
  const [prodCo, setProdCo] = useState([]);
  const [crew, setCrew] = useState([]);
  const [cast, setCast] = useState([]);
  const [imdbRating, setImdbRating] = useState([]);
  const [tmdbRating, setTmdbRating] = useState([]);
  const [rating, setRating] = useState([]);
  const [userRating, setUserRating] = useState([]);
  const [loginStatus, setLoginStatus] = useState(false);

  const postData = (url: string, updateFunction: any) => {
    fetch(url, { 
      method: 'POST', 
      credentials: 'include',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ id: data.match.params.id })
    }).then(function(response) {
      return response.json();
    }).then(function(json: any) {
      if (updateFunction) updateFunction(json);
    }).catch(function(err: any) {
      console.error(err);
    });
  }

  const getLoginStatus = () => {
    fetch("http://localhost:3001/api/signin", { method: 'GET', credentials: 'include' })
    .then(function(response) {
      return response.json();
    }).then(function(json: any) {
      setLoginStatus(json.loginStatus);
    }).catch(function(err: any) {
      console.error(err);
    });
  }

  const reviewQuery = (url: string, rating: number) => {
    fetch(url, { 
      method: 'POST', 
      credentials: 'include',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ id: data.match.params.id, rating: rating })
    }).then(function(response) {
      return response.json();
    }).catch(function(err: any) {
      console.error(err);
    });
  }

  const setReview = (e: any) => {
    e.preventDefault();
    var review = prompt("Enter your rating (1-10)", (userRating.length ? (userRating[0] as any).rating : 10));

    if (review && parseInt(review) > 0 && parseInt(review) <= 10) {
      if (userRating.length) {
        reviewQuery("http://localhost:3001/api/movie/rating/edit", parseInt(review));
      } else {
        reviewQuery("http://localhost:3001/api/movie/rating/add", parseInt(review));
      }
    } else {
      window.alert("Invalid rating.");
    }
    window.location.reload();
  }

  const deleteReview = () => {
    if (window.confirm("Are you sure?")) {
      postData("http://localhost:3001/api/movie/rating/delete", undefined);
      window.location.reload();
    }
  }

  useEffect(() => {
    postData("http://localhost:3001/api/movie", setResults);
    postData("http://localhost:3001/api/movie/genre", setGenres);
    postData("http://localhost:3001/api/movie/language", setLanguages);
    postData("http://localhost:3001/api/movie/production", setProdCo);
    postData("http://localhost:3001/api/movie/crew", setCrew);
    postData("http://localhost:3001/api/movie/cast", setCast);
    postData("http://localhost:3001/api/movie/imdb", setImdbRating);
    postData("http://localhost:3001/api/movie/tmdb", setTmdbRating);
    postData("http://localhost:3001/api/movie/rating", setRating);
    postData("http://localhost:3001/api/movie/rating/get", setUserRating);
    getLoginStatus();

    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [data]);
  
  return results[0] ? (
    <div className="movie">
      <h1>{ (results[0] as any).originalTitle ? (results[0] as any).originalTitle : "Loading..." }</h1>
      <h2>{ (results[0] as any).year ? (results[0] as any).year : "" }</h2>
      <div className="rating">
        {
          imdbRating.length ?
            <div className="imdb">
              <img src="https://ia.media-imdb.com/images/M/MV5BMTczNjM0NDY0Ml5BMl5BcG5nXkFtZTgwMTk1MzQ2OTE@._V1_.png" alt="IMDB" />
              <p>{ (imdbRating[0] as any).meanVote }/10</p>
            </div>
          : ""
        }
        {
          tmdbRating.length ?
            <div className="tmdb">
              <img src="https://upload.wikimedia.org/wikipedia/commons/8/89/Tmdb.new.logo.svg" alt="TMDB" />
              <p>{ (tmdbRating[0] as any).meanVote }/5</p>
            </div>
          : ""
        }
        {
          rating && rating[0] && (rating[0] as any).meanVote ?
            <div className="local">
              <img src={logo} alt="rating" />
              <p>{ (rating[0] as any).meanVote }/10</p>
            </div>
          : ""
        }
        {
          loginStatus ? (
            !userRating.length ?
              <button className="btn btn-primary" onClick={ setReview }>Add Review</button>
            : 
              <div>
                <button className="btn btn-primary" onClick={ setReview }>Edit Review</button>
                <button className="btn btn-primary" onClick={ deleteReview }>Delete Review</button>
              </div>
          ): ""
        }
      </div>
      {
        (results[0] as any).description ?
          <p className="description">{ (results[0] as any).description }</p> : ""
      }
      <div className="row">
        <div className="col-sm">
          <h2>{ crew.length ? "Crew" : ""}</h2>
          <table>
            <tbody>
            {
              crew.map((val: any, key: any) => {
                  const url = "/people/" + val.personID;
                  return (<tr key={key}><td><a href={url}>{ val.name }</a></td><td>{ val.jobTitle }</td></tr>);
              })
            }
            </tbody>
          </table>
          <h2>{ cast.length ? "Main Cast" : ""}</h2>
          <table>
            <tbody>
            {
              cast.map((val: any, key: any) => {
                  const url = "/people/" + val.personID;
                  return (<tr key={key}><td><a href={url}>{ val.name }</a></td><td>{ val.role }</td></tr>);
              })
            }
            </tbody>
          </table>
        </div>
        <div className="col-sm">
          <h2>Info</h2>
          {
            (results[0] as any).releaseDate ? 
              <p><b>Release Date:</b> { (results[0] as any).releaseDate }</p> : ""
          }
          {
            (results[0] as any).runTimeMinutes ? 
              <p><b>Runtime:</b> { (results[0] as any).runTimeMinutes } minutes</p> : ""
          }
          {
            (results[0] as any).mpaa ? 
              <p><b>MPAA:</b> { (results[0] as any).mpaa } </p> : ""
          }
          {
            genres.length ?
              <p>
                <b>Genres: </b>  
                {
                  genres.map((val: any, key: any) => {
                      return ( val.genre + (key !== genres.length - 1 ? ", " : "") );
                  })
                }
              </p>
            : ""
          }
          {
            languages.length ?
              <p>
                <b>Languages: </b>  
                {
                  languages.map((val: any, key: any) => {
                      return ( val.language + (key !== languages.length - 1 ? ", " : "") );
                  })
                }
              </p>
            : ""
          }
          <br/>
          {
            prodCo.length ?
              <p>
                <b>Production Co: </b>  
                {
                  prodCo.map((val: any, key: any) => {
                      return ( val.companyName + (key !== prodCo.length - 1 ? ", " : "") );
                  })
                }
              </p>
            : ""
          }
          {
            (results[0] as any).budget ?
              <p><b>Budget: </b>${(results[0] as any).budget + ((results[0] as any).budgetCurrency ? " " + (results[0] as any).budgetCurrency : "")}</p> : ""
          }
          {
            (results[0] as any).grossUSA ? 
              <p><b>Gross USA:</b> ${ (results[0] as any).grossUSA } USD</p> : ""
          }
          {
            (results[0] as any).grossInternational ? 
              <p><b>Gross International:</b> ${ (results[0] as any).grossInternational } USD</p> : ""
          }
        </div>
      </div>
    </div>
  ) : (
    <div className="person"><h1>404 - Not Found.</h1></div>
  );
}

export default Movie;
