import { useState, useEffect } from 'react';
import { Link, NavLink, useHistory } from 'react-router-dom';
import './Navbar.scss';

function Navbar() {
  const history = useHistory();
  const [query, setQuery] = useState('');
  const [queryType, setQueryType] = useState('movies');
  const [loginStatus, setLoginStatus] = useState(false);
  const [username, setUsername] = useState('');

  const submitAction = (e: any) => {
    e.preventDefault();
    if (query) {
      history.push("/search?value=" + encodeURIComponent(query) + "&type=" + encodeURIComponent(queryType));
      window.location.reload();
    }
  }

  const signout = () => {
    fetch("http://localhost:3001/api/signout", {
      method: 'GET', 
      credentials: 'include'
    }).then(function(response) {
      history.push("/");
      setLoginStatus(false);
    }).catch(function(err: any) {
      console.error(err);
    });
  }

  useEffect(() => {
    fetch("http://localhost:3001/api/signin", { method: 'GET', credentials: 'include' })
    .then(function(response) {
      return response.json();
    }).then(function(json: any) {
      setLoginStatus(json.loginStatus);
      setUsername(json.user[0].username);
    }).catch(function(err: any) {
      console.error(err);
    });
  }, [loginStatus]);

  return (
    <>
      <nav className="navbar">
          <Link to="/" className="navbar-logo">ECE 356</Link>
          <form id="search-bar" onSubmit={submitAction}>
            <input type="text" className="form-control rounded" id="search-input" placeholder="Search..." onChange={(e) => setQuery(e.target.value)} />
            <select id="search-type" className="form-control" defaultValue="movies" onChange={(e) => setQueryType(e.target.value)}>
              <option value="movies">Movies</option>
              <option value="people">People</option>
              <option value="keyword">Keyword</option>
            </select>
            <button type="submit" id="search-button" className="btn btn-primary"><img src="https://upload.wikimedia.org/wikipedia/commons/5/55/Magnifying_glass_icon.svg" alt="Search" /></button>
          </form>
          <div className="navbar-links">
            <NavLink activeClassName="active" to="/about">About</NavLink>
            {
              !loginStatus ? (
                <NavLink activeClassName="active" to="/signin">Sign In</NavLink>
              ) : (
                <div className="dropdown show">
                  <button className="btn btn-secondary dropdown-toggle" id="dropdownMenuLink" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                    { username }
                  </button>

                  <div className="dropdown-menu" aria-labelledby="dropdownMenuLink">
                    <button className="dropdown-item" onClick={ signout }>Sign Out</button>
                  </div>
                </div>
              ) 
            }
          </div>
      </nav>
    </>
  );
}

export default Navbar;
