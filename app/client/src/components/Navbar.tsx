import { FormEventHandler, useState } from 'react';
import { Link, NavLink, Router, useHistory } from 'react-router-dom';
import './Navbar.scss';

function Navbar() {
  const history = useHistory();
  const [query, setQuery] = useState('');
  const [queryType, setQueryType] = useState('movies');

  const submitAction = (e: any) => {
    e.preventDefault();
    if (query) {
      history.push("/search?value=" + query + "&type=" + queryType);
    }
  }

  return (
    <>
      <nav className="navbar">
          <Link to="/" className="navbar-logo">ECE 356</Link>
          <form id="search-bar" onSubmit={submitAction}>
            <input type="text" className="form-control rounded" id="search-input" placeholder="Search..." onChange={(e) => setQuery(e.target.value)} />
            <select id="search-type" className="form-control" defaultValue="movies" onChange={(e) => setQueryType(e.target.value)}>
              <option value="movies">Movies</option>
              <option value="people">People</option>
              <option value="genre">Genre</option>
            </select>
            <button type="submit" id="search-button" className="btn btn-primary"><img src="https://upload.wikimedia.org/wikipedia/commons/5/55/Magnifying_glass_icon.svg" alt="Search" /></button>
          </form>
          <ul className="navbar-links">
            <li><NavLink activeClassName="active" to="/about">About</NavLink></li>
          </ul>
      </nav>
    </>
  );
}

export default Navbar;
