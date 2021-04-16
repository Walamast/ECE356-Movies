import React from 'react';
import './App.scss';
import Home from './components/Home';
import About from './components/About';
import Navbar from './components/Navbar';
import Search from './components/Search';
import { BrowserRouter as Router, Switch, Route } from 'react-router-dom';

function App() {
  return (
    <Router>
      <Navbar />
      <Switch>
        <Route path='/' exact component={ Home } />
        <Route path='/about' component={ About } />
        <Route path='/search' component={ Search } />
      </Switch>
    </Router>
  );
}

export default App;
