import { useState, useEffect } from 'react';
import './Person.scss';

const Person = (data: any) => {
  const [results, setResults] = useState([]);
  const [jobs, setJobs] = useState([]);
  const [roles, setRoles] = useState([]);

  useEffect(() => {
    fetch("http://localhost:3001/api/person", { 
      method: 'POST', 
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ id: data.match.params.id })
    }).then(function(response) {
      return response.json();
    }).then(function(json: any) {
      setResults(json);
    }).catch(function(err: any) {
      console.error(err);
    });
    
    fetch("http://localhost:3001/api/person/jobs", { 
      method: 'POST', 
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ id: data.match.params.id })
    }).then(function(response) {
      return response.json();
    }).then(function(json: any) {
      setJobs(json);
    }).catch(function(err: any) {
      console.error(err);
    });
    
    fetch("http://localhost:3001/api/person/roles", { 
      method: 'POST', 
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ id: data.match.params.id })
    }).then(function(response) {
      return response.json();
    }).then(function(json: any) {
      setRoles(json);
    }).catch(function(err: any) {
      console.error(err);
    });

    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [data]);

  return results[0] ? (
    <div className="person">
      <h1>{(results[0] as any).name ? (results[0] as any).name : "Loading..." }</h1>
      {
        (results[0] as any).bio ?
          <p className="description">{(results[0] as any).bio}</p> : ""
      }
      <div className="row">
        <div className="col-sm">
          <h2>{ jobs.length ? "Filmography" : ""}</h2>
          <table>
            <tbody>
            {
              jobs.map((val: any, key: any) => {
                  const url = "/movies/" + val.movieID;
                  return (<tr key={key}><td><a href={url}>{ val.originalTitle }</a></td><td>{ val.role }</td></tr>);
              })
            }
            </tbody>
          </table>
          <h2>{ roles.length ? "Roles" : ""}</h2>
          <table>
            <tbody>
            {
              roles.map((val: any, key: any) => {
                  const url = "/movies/" + val.movieID;
                  return (<tr key={key}><td><a href={url}>{ val.originalTitle }</a></td><td>{ val.role }</td></tr>);
              })
            }
            </tbody>
          </table>
        </div>
        <div className="col-sm">
          <h2>Info</h2>
          {
            (results[0] as any).birthDate ? 
              <p><b>Born:</b> {(results[0] as any).birthDate + ((results[0] as any).birthPlace ? " in " + (results[0] as any).birthPlace : "")}</p> : ""
          }
          {
            (results[0] as any).deathDate ? 
              <p><b>Died:</b> {(results[0] as any).deathDate + ((results[0] as any).deathPlace ? " in " + (results[0] as any).deathPlace : "") + ((results[0] as any).deathCause ? " by " + (results[0] as any).deathCause : "")}</p> : ""
          }
          {
            (results[0] as any).heightInCM ?
              <p><b>Height: </b>{(results[0] as any).heightInCM} cm</p> : ""
          }
          {
            (results[0] as any).totalChildren && (results[0] as any).totalChildren > 0 ?
              <p><b>Children: </b>{(results[0] as any).totalChildren}</p> : ""
          }
        </div>
      </div>
    </div>
  ) : (
    <div className="person"><h1>404 - Not Found.</h1></div>
  );
}

export default Person;
