import './App.css';
import Navbar from './components/Navbar'
import {BrowserRouter as Router, Switch, Route} from 'react-router-dom'

function App() {
  return (
    <>
      <Router>
        <Switch>
          <Route path='/' exact />
        </Switch>
        <Navbar />
      </Router>
    </>
  );
}

export default App;
