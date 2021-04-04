import {Link} from 'react-router-dom'
import './Navbar.css'

function Navbar() {
  return (
    <>
      <nav className="navbar">
          <Link to="/" className="navbar-logo">ECE 356</Link>
          <div id="search-bar">
            <input type="text" className="form-control rounded" id="search-input" placeholder="Search..." />
            <select id="search-type" className="form-control">
              <option value="movies" selected>Movies</option>
              <option value="people">People</option>
              <option value="genre">Genre</option>
            </select>
            <button type="submit" class="btn btn-primary"><img src="https://upload.wikimedia.org/wikipedia/commons/5/55/Magnifying_glass_icon.svg" /></button>
          </div>
          <ul className="navbar-links">
            <li><Link to="/about">About</Link></li>
          </ul>
      </nav>
    </>
  );
}

export default Navbar;
