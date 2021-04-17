import './Login.scss';
import { useState, useEffect } from 'react';
import { useHistory } from 'react-router-dom';

function Login() {
  const [loginStatus, setLoginStatus] = useState(false);
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [passwordConfirm, setPasswordConfirm] = useState('');
  const history = useHistory();

  const login = (e: any) => {
    e.preventDefault();
    fetch("http://localhost:3001/api/signin", {
      method: 'POST', 
      credentials: 'include',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ username: username, password: password })
    }).then(function(response) {
      if (response.status !== 200) {
        response.json().then(function(json) {
          window.alert(json.message);
        });
      } else {
        history.push("/");
        window.location.reload();
      }
    }).catch(function(err: any) {
      console.error(err);
    });
  }

  const register = (e: any) => {
    e.preventDefault();
    if (username && username.length > 2 && password === passwordConfirm) {
      fetch("http://localhost:3001/api/register", {
        method: 'POST', 
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({ username: username, password: password })
      }).then(function(response) {
        if (response.status !== 200) {
          response.json().then(function(json) {
            window.alert(json.message);
          });
        } else {
          login(e);
        }
      }).catch(function(err: any) {
        console.error(err);
      });
    } else {
      window.alert("Invalid username or password.");
    }
  }

  useEffect(() => {
    fetch("http://localhost:3001/api/signin", { method: 'GET', credentials: 'include' })
    .then(function(response) {
      return response.json();
    }).then(function(json: any) {
      setLoginStatus(json.loginStatus);
    }).catch(function(err: any) {
      console.error(err);
    });
  }, []);

  return !loginStatus ? (
    <div className="login">
      <h1>Sign In</h1>
      <form onSubmit={login}>
        <input type="text" className="form-control rounded" placeholder="Username" onChange={(e) => setUsername(e.target.value)} />
        <input type="password" className="form-control rounded" placeholder="Password" onChange={(e) => setPassword(e.target.value)} />
        <button type="submit"className="btn btn-primary">Sign In</button>
      </form>
      <h1>Register</h1>
      <form onSubmit={register}>
        <input type="text" className="form-control rounded" placeholder="Username" onChange={(e) => setUsername(e.target.value)} />
        <input type="password" className="form-control rounded" placeholder="Password" onChange={(e) => setPassword(e.target.value)} />
        <input type="password" className="form-control rounded" placeholder="Confirm Password" onChange={(e) => setPasswordConfirm(e.target.value)} />
        <button type="submit"className="btn btn-primary">Register</button>
      </form>
    </div>
  ) : (
    <div className="login">
      <h1>You're already signed in.</h1>
    </div>
  );
}

export default Login;
