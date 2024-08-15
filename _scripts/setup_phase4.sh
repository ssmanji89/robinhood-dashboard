#!/bin/bash

# Set the project root directory
PROJECT_ROOT="/Users/sulemanmanji/Documents/GitHub/robinhood-dashboard"

# Navigate to the project root
cd "$PROJECT_ROOT"

echo "Setting up Phase 4 of the Robinhood Dashboard project..."

# Backend enhancements
echo "Enhancing backend..."

# Add new dependencies
echo "python-dotenv" >> backend/requirements.txt
echo "Flask-JWT-Extended" >> backend/requirements.txt

# Create a .env file for environment variables
cat > backend/.env << EOL
SECRET_KEY=your_secret_key_here
ROBINHOOD_USERNAME=your_robinhood_username
ROBINHOOD_PASSWORD=your_robinhood_password
EOL

# Update main app file to use environment variables and JWT
cat > backend/app/__init__.py << EOL
from flask import Flask
from flask_cors import CORS
from flask_sqlalchemy import SQLAlchemy
from flask_jwt_extended import JWTManager
from dotenv import load_dotenv
import os

from .auth import auth as auth_blueprint
from .portfolio import portfolio as portfolio_blueprint
from .trading import trading as trading_blueprint
from .models.user import db

load_dotenv()

def create_app():
    app = Flask(__name__)
    CORS(app)
    
    app.config['SECRET_KEY'] = os.getenv('SECRET_KEY')
    app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///robinhood_dashboard.db'
    app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
    app.config['JWT_SECRET_KEY'] = os.getenv('SECRET_KEY')
    
    db.init_app(app)
    JWTManager(app)

    app.register_blueprint(auth_blueprint, url_prefix='/api/auth')
    app.register_blueprint(portfolio_blueprint, url_prefix='/api/portfolio')
    app.register_blueprint(trading_blueprint, url_prefix='/api/trading')

    @app.route('/api/health')
    def health_check():
        return {'status': 'healthy'}, 200

    with app.app_context():
        db.create_all()

    return app

if __name__ == '__main__':
    app = create_app()
    app.run(debug=True)
EOL

# Update auth module to include JWT
cat > backend/app/auth/routes.py << EOL
from flask import jsonify, request
from flask_jwt_extended import create_access_token, jwt_required, get_jwt_identity
from . import auth
from ..models.user import User, db
from werkzeug.security import generate_password_hash, check_password_hash

@auth.route('/register', methods=['POST'])
def register():
    data = request.json
    user = User.query.filter_by(username=data['username']).first()
    if user:
        return jsonify({"message": "Username already exists"}), 400
    new_user = User(username=data['username'], email=data['email'])
    new_user.set_password(data['password'])
    db.session.add(new_user)
    db.session.commit()
    return jsonify({"message": "User created successfully"}), 201

@auth.route('/login', methods=['POST'])
def login():
    data = request.json
    user = User.query.filter_by(username=data['username']).first()
    if user and user.check_password(data['password']):
        access_token = create_access_token(identity=user.id)
        return jsonify(access_token=access_token), 200
    return jsonify({"message": "Invalid username or password"}), 401

@auth.route('/protected', methods=['GET'])
@jwt_required()
def protected():
    current_user_id = get_jwt_identity()
    return jsonify(logged_in_as=current_user_id), 200
EOL

# Update User model to include password hashing
cat > backend/app/models/user.py << EOL
from flask_sqlalchemy import SQLAlchemy
from werkzeug.security import generate_password_hash, check_password_hash

db = SQLAlchemy()

class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True, nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)
    password_hash = db.Column(db.String(128))

    def set_password(self, password):
        self.password_hash = generate_password_hash(password)

    def check_password(self, password):
        return check_password_hash(self.password_hash, password)

    def __repr__(self):
        return '<User %r>' % self.username
EOL

# Enhance portfolio module
cat > backend/app/portfolio/routes.py << EOL
from flask import jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from . import portfolio
from ..models.trade import Trade

@portfolio.route('/holdings', methods=['GET'])
@jwt_required()
def get_holdings():
    current_user_id = get_jwt_identity()
    trades = Trade.query.filter_by(user_id=current_user_id).all()
    holdings = {}
    for trade in trades:
        if trade.symbol not in holdings:
            holdings[trade.symbol] = 0
        if trade.type == 'buy':
            holdings[trade.symbol] += trade.quantity
        else:
            holdings[trade.symbol] -= trade.quantity
    return jsonify(holdings), 200

@portfolio.route('/performance', methods=['GET'])
@jwt_required()
def get_performance():
    # TODO: Implement portfolio performance calculation
    return jsonify({"message": "Portfolio performance to be implemented"}), 200
EOL

# Frontend enhancements
echo "Enhancing frontend..."

# Add new dependencies
npm --prefix frontend install axios react-chartjs-2 chart.js

# Update API service
cat > frontend/src/services/api.js << EOL
import axios from 'axios';

const API_URL = 'http://localhost:5000/api';

const api = axios.create({
  baseURL: API_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

api.interceptors.request.use((config) => {
  const token = localStorage.getItem('token');
  if (token) {
    config.headers.Authorization = \`Bearer \${token}\`;
  }
  return config;
});

export const login = (credentials) => api.post('/auth/login', credentials);
export const register = (userData) => api.post('/auth/register', userData);
export const executeTradeAPI = (tradeData) => api.post('/trading/execute', tradeData);
export const getTradeHistoryAPI = () => api.get('/trading/history');
export const getHoldingsAPI = () => api.get('/portfolio/holdings');
export const getPerformanceAPI = () => api.get('/portfolio/performance');

export default api;
EOL

# Create a login component
cat > frontend/src/components/Login.js << EOL
import React, { useState } from 'react';
import { login } from '../services/api';

const Login = ({ onLogin }) => {
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      const response = await login({ username, password });
      localStorage.setItem('token', response.data.access_token);
      onLogin();
    } catch (error) {
      console.error('Login failed:', error);
    }
  };

  return (
    <form onSubmit={handleSubmit}>
      <input
        type="text"
        value={username}
        onChange={(e) => setUsername(e.target.value)}
        placeholder="Username"
        required
      />
      <input
        type="password"
        value={password}
        onChange={(e) => setPassword(e.target.value)}
        placeholder="Password"
        required
      />
      <button type="submit">Login</button>
    </form>
  );
};

export default Login;
EOL

# Update App.js to include authentication
cat > frontend/src/App.js << EOL
import React, { useState, useEffect } from 'react';
import { BrowserRouter as Router, Route, Switch, Redirect } from 'react-router-dom';
import Navigation from './components/Navigation';
import Dashboard from './pages/Dashboard';
import Portfolio from './pages/Portfolio';
import Trading from './pages/Trading';
import Login from './components/Login';

function App() {
  const [isAuthenticated, setIsAuthenticated] = useState(false);

  useEffect(() => {
    const token = localStorage.getItem('token');
    if (token) {
      setIsAuthenticated(true);
    }
  }, []);

  const handleLogin = () => {
    setIsAuthenticated(true);
  };

  const handleLogout = () => {
    localStorage.removeItem('token');
    setIsAuthenticated(false);
  };

  return (
    <Router>
      <div className="App">
        {isAuthenticated && <Navigation onLogout={handleLogout} />}
        <Switch>
          <Route exact path="/login">
            {isAuthenticated ? <Redirect to="/" /> : <Login onLogin={handleLogin} />}
          </Route>
          <Route exact path="/">
            {isAuthenticated ? <Dashboard /> : <Redirect to="/login" />}
          </Route>
          <Route path="/portfolio">
            {isAuthenticated ? <Portfolio /> : <Redirect to="/login" />}
          </Route>
          <Route path="/trading">
            {isAuthenticated ? <Trading /> : <Redirect to="/login" />}
          </Route>
        </Switch>
      </div>
    </Router>
  );
}

export default App;
EOL

# Update Portfolio page to display holdings
cat > frontend/src/pages/Portfolio.js << EOL
import React, { useState, useEffect } from 'react';
import { getHoldingsAPI } from '../services/api';

const Portfolio = () => {
  const [holdings, setHoldings] = useState({});

  useEffect(() => {
    const fetchHoldings = async () => {
      try {
        const response = await getHoldingsAPI();
        setHoldings(response.data);
      } catch (error) {
        console.error('Failed to fetch holdings:', error);
      }
    };
    fetchHoldings();
  }, []);

  return (
    <div>
      <h2>Portfolio</h2>
      <ul>
        {Object.entries(holdings).map(([symbol, quantity]) => (
          <li key={symbol}>{symbol}: {quantity}</li>
        ))}
      </ul>
    </div>
  );
};

export default Portfolio;
EOL

# Update README with new information
cat >> README.md << EOL

## Phase 4 Updates

### Backend
- Implemented JWT authentication
- Added environment variable support
- Enhanced portfolio module with holdings and performance endpoints

### Frontend
- Added login functionality
- Implemented protected routes
- Updated Portfolio page to display holdings
- Added axios for API calls

## Security Note
Make sure to keep your .env file secure and never commit it to version control.

## Next Steps
- Implement real-time data updates
- Add more advanced trading features
- Enhance error handling and user feedback
- Implement proper logout functionality
- Add unit and integration tests
EOL

# Commit changes
git add .
git commit -m "Phase 4: Implemented authentication, enhanced portfolio functionality, and improved overall structure"

echo "Phase 4 of Robinhood Dashboard project has been set up at $PROJECT_ROOT"