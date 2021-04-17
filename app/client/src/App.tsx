import React from 'react';
import './App.scss';
import Home from './components/Home';
import About from './components/About';
import Navbar from './components/Navbar';
import Login from './components/Login';
import Search from './components/Search';
import Movie from './components/Movie';
import Person from './components/Person';
import { BrowserRouter as Router, Switch, Route } from 'react-router-dom';

function App() {
  return (
    <Router>
      <Navbar />
      <Switch>
        <Route path='/' exact component={ Home } />
        <Route path='/about' component={ About } />
        <Route path='/signin' component={ Login } />
        <Route path='/search' component={ Search } />
        <Route path='/movie/:id' component={ Movie } />
        <Route path='/people/:id' component={ Person } />
      </Switch>
    </Router>
  );
}

export default App;
