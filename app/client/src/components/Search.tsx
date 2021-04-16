import { useState, useEffect } from 'react';
import './Search.scss';

function Search() {
  const [query, setQuery] = useState('');
  const [queryType, setQueryType] = useState('');
  const [results, setResults] = useState([]);

  useEffect(() => {
    const params = new URLSearchParams(window.location.search);
    const queryParam = params.get("value");
    const typeParam = params.get("type")

    if (queryParam) setQuery(queryParam);
    if (typeParam) setQueryType(typeParam);

    fetch("http://localhost:3001/api/search", { 
      method: 'POST', 
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ query: params.get("value"), type: params.get("type") })
    }).then(function(response) {
      return response.json();
    }).then(function(json: any) {
      setResults(json);
    }).catch(function(err: any) {
      console.error(err);
    });
  }, []);

  return (
    <div className="search">
      <h1>Search results for "{query}"</h1>
      <ul>
        {
          results.length ? 
            results.map((val: any, key: any) => {
                const url = (queryType === "people" ? "/people/" + val.personID : "/movies/" + val.movieID);
                return (<li key={key}><a href={url}>{ queryType === "people" ? val.name : val.originalTitle + (val.year ? " (" + val.year + ")" : "") }</a></li>);
            }) 
          : 
            <li>No results found.</li>
        }
      </ul>
    </div>
  );
}

export default Search;
