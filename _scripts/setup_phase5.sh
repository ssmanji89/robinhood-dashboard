#!/bin/bash

# Set the project root directory
PROJECT_ROOT="/Users/sulemanmanji/Documents/GitHub/robinhood-dashboard"

# Navigate to the project root
cd "$PROJECT_ROOT"

echo "Setting up Phase 5 of the Robinhood Dashboard project..."

# Backend enhancements
echo "Enhancing backend..."

# Add new dependencies
echo "flask-socketio" >> backend/requirements.txt
echo "apscheduler" >> backend/requirements.txt
echo "yfinance" >> backend/requirements.txt

# Update main app file to include SocketIO and APScheduler
cat > backend/app/__init__.py << EOL
from flask import Flask
from flask_cors import CORS
from flask_sqlalchemy import SQLAlchemy
from flask_jwt_extended import JWTManager
from flask_socketio import SocketIO
from apscheduler.schedulers.background import BackgroundScheduler
from dotenv import load_dotenv
import os

from .auth import auth as auth_blueprint
from .portfolio import portfolio as portfolio_blueprint
from .trading import trading as trading_blueprint
from .models.user import db

load_dotenv()

socketio = SocketIO()
scheduler = BackgroundScheduler()

def create_app():
    app = Flask(__name__)
    CORS(app)
    
    app.config['SECRET_KEY'] = os.getenv('SECRET_KEY')
    app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///robinhood_dashboard.db'
    app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
    app.config['JWT_SECRET_KEY'] = os.getenv('SECRET_KEY')
    
    db.init_app(app)
    JWTManager(app)
    socketio.init_app(app, cors_allowed_origins="*")

    app.register_blueprint(auth_blueprint, url_prefix='/api/auth')
    app.register_blueprint(portfolio_blueprint, url_prefix='/api/portfolio')
    app.register_blueprint(trading_blueprint, url_prefix='/api/trading')

    @app.route('/api/health')
    def health_check():
        return {'status': 'healthy'}, 200

    with app.app_context():
        db.create_all()

    scheduler.start()

    return app

if __name__ == '__main__':
    app = create_app()
    socketio.run(app, debug=True)
EOL

# Create a real-time stock data updater
cat > backend/app/utils/stock_updater.py << EOL
import yfinance as yf
from flask_socketio import emit
from .. import socketio, scheduler

def update_stock_prices(symbols):
    data = yf.download(symbols, period="1d")
    latest_prices = data['Close'].iloc[-1].to_dict()
    socketio.emit('stock_update', latest_prices)

def schedule_stock_updates(symbols, interval=60):
    scheduler.add_job(
        update_stock_prices,
        'interval',
        seconds=interval,
        args=[symbols]
    )
EOL

# Update portfolio module to include real-time updates
cat > backend/app/portfolio/routes.py << EOL
from flask import jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from . import portfolio
from ..models.trade import Trade
from ..utils.stock_updater import schedule_stock_updates
import yfinance as yf

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
    
    # Schedule real-time updates for the user's holdings
    schedule_stock_updates(list(holdings.keys()))
    
    return jsonify(holdings), 200

@portfolio.route('/performance', methods=['GET'])
@jwt_required()
def get_performance():
    current_user_id = get_jwt_identity()
    trades = Trade.query.filter_by(user_id=current_user_id).all()
    
    holdings = {}
    for trade in trades:
        if trade.symbol not in holdings:
            holdings[trade.symbol] = {'quantity': 0, 'cost_basis': 0}
        if trade.type == 'buy':
            holdings[trade.symbol]['quantity'] += trade.quantity
            holdings[trade.symbol]['cost_basis'] += trade.quantity * trade.price
        else:
            holdings[trade.symbol]['quantity'] -= trade.quantity
            holdings[trade.symbol]['cost_basis'] -= trade.quantity * trade.price

    symbols = list(holdings.keys())
    current_prices = yf.download(symbols, period="1d")['Close'].iloc[-1]

    performance = {}
    for symbol, data in holdings.items():
        if data['quantity'] > 0:
            current_value = data['quantity'] * current_prices[symbol]
            cost_basis = data['cost_basis']
            performance[symbol] = {
                'quantity': data['quantity'],
                'cost_basis': cost_basis,
                'current_value': current_value,
                'profit_loss': current_value - cost_basis,
                'profit_loss_percent': ((current_value - cost_basis) / cost_basis) * 100
            }

    return jsonify(performance), 200
EOL

# Frontend enhancements
echo "Enhancing frontend..."

# Add new dependencies
npm --prefix frontend install socket.io-client react-toastify --force

# Update API service to include WebSocket connection
cat > frontend/src/services/api.js << EOL
import axios from 'axios';
import io from 'socket.io-client';

const API_URL = 'http://localhost:5000/api';
const SOCKET_URL = 'http://localhost:5000';

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

export const socket = io(SOCKET_URL);

export const login = (credentials) => api.post('/auth/login', credentials);
export const register = (userData) => api.post('/auth/register', userData);
export const executeTradeAPI = (tradeData) => api.post('/trading/execute', tradeData);
export const getTradeHistoryAPI = () => api.get('/trading/history');
export const getHoldingsAPI = () => api.get('/portfolio/holdings');
export const getPerformanceAPI = () => api.get('/portfolio/performance');

export default api;
EOL

# Update Portfolio page to include real-time updates and performance data
cat > frontend/src/pages/Portfolio.js << EOL
import React, { useState, useEffect } from 'react';
import { getHoldingsAPI, getPerformanceAPI, socket } from '../services/api';
import { toast } from 'react-toastify';

const Portfolio = () => {
  const [holdings, setHoldings] = useState({});
  const [performance, setPerformance] = useState({});

  useEffect(() => {
    const fetchHoldings = async () => {
      try {
        const response = await getHoldingsAPI();
        setHoldings(response.data);
      } catch (error) {
        console.error('Failed to fetch holdings:', error);
        toast.error('Failed to fetch holdings');
      }
    };

    const fetchPerformance = async () => {
      try {
        const response = await getPerformanceAPI();
        setPerformance(response.data);
      } catch (error) {
        console.error('Failed to fetch performance:', error);
        toast.error('Failed to fetch performance data');
      }
    };

    fetchHoldings();
    fetchPerformance();

    socket.on('stock_update', (data) => {
      setHoldings((prevHoldings) => {
        const updatedHoldings = { ...prevHoldings };
        Object.keys(data).forEach((symbol) => {
          if (updatedHoldings[symbol]) {
            updatedHoldings[symbol].currentPrice = data[symbol];
          }
        });
        return updatedHoldings;
      });
    });

    return () => {
      socket.off('stock_update');
    };
  }, []);

  return (
    <div>
      <h2>Portfolio</h2>
      <table>
        <thead>
          <tr>
            <th>Symbol</th>
            <th>Quantity</th>
            <th>Current Price</th>
            <th>Current Value</th>
            <th>Cost Basis</th>
            <th>Profit/Loss</th>
            <th>Profit/Loss %</th>
          </tr>
        </thead>
        <tbody>
          {Object.entries(performance).map(([symbol, data]) => (
            <tr key={symbol}>
                <td>{symbol}</td>
                <td>{data.quantity}</td>
                <td>\${(holdings[symbol]?.currentPrice || 0).toFixed(2)}</td>
                <td>\${data.current_value.toFixed(2)}</td>
                <td>\${data.cost_basis.toFixed(2)}</td>
                <td>\${data.profit_loss.toFixed(2)}</td>
                <td>{data.profit_loss_percent.toFixed(2)}%</td>
            </tr>
            ))}
        </tbody>
      </table>
    </div>
  );
};

export default Portfolio;
EOL

# Update App.js to include toast notifications
cat > frontend/src/App.js << EOL
import React, { useState, useEffect } from 'react';
import { BrowserRouter as Router, Route, Switch, Redirect } from 'react-router-dom';
import { ToastContainer } from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';
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
        <ToastContainer />
      </div>
    </Router>
  );
}

export default App;
EOL

# Update README with new information
cat >> README.md << EOL

## Phase 5 Updates

### Backend
- Implemented real-time stock price updates using WebSockets
- Added performance calculation for portfolio holdings
- Integrated yfinance for fetching current stock prices
- Implemented background job scheduling for periodic updates

### Frontend
- Added real-time updates to the Portfolio page
- Implemented performance metrics display in the Portfolio
- Added toast notifications for better user feedback

## Running the Application

1. Start the backend:
   \`\`\`
   cd backend
   flask run
   \`\`\`

2. Start the frontend:
   \`\`\`
   cd frontend
   npm start --force
   \`\`\`

Visit http://localhost:3000 to view the application.

## Next Steps
- Implement advanced trading strategies
- Add more comprehensive error handling and logging
- Enhance the dashboard with charts and graphs
- Implement user settings and preferences
- Add support for multiple portfolios per user
EOL

# Commit changes
git add .
git commit -m "Phase 5: Implemented real-time updates, performance metrics, and enhanced user experience"

echo "Phase 5 of Robinhood Dashboard project has been set up at $PROJECT_ROOT"