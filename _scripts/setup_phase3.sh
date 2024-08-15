#!/bin/bash

# Set the project root directory
PROJECT_ROOT="/Users/sulemanmanji/Documents/GitHub/robinhood-dashboard"

# Navigate to the project root
cd "$PROJECT_ROOT"

# Backend enhancements
echo "Enhancing backend..."

# Add SQLAlchemy for database operations
echo "SQLAlchemy" >> backend/requirements.txt
echo "Flask-SQLAlchemy" >> backend/requirements.txt

# Create database models
cat > backend/app/models/user.py << EOL
from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True, nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)

    def __repr__(self):
        return '<User %r>' % self.username
EOL

cat > backend/app/models/trade.py << EOL
from .user import db
from datetime import datetime

class Trade(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    symbol = db.Column(db.String(10), nullable=False)
    quantity = db.Column(db.Float, nullable=False)
    price = db.Column(db.Float, nullable=False)
    timestamp = db.Column(db.DateTime, nullable=False, default=datetime.utcnow)
    type = db.Column(db.String(4), nullable=False)  # 'buy' or 'sell'

    def __repr__(self):
        return f'<Trade {self.symbol} {self.type}>'
EOL

# Update main app file to include database
cat > backend/app/__init__.py << EOL
from flask import Flask
from flask_cors import CORS
from flask_sqlalchemy import SQLAlchemy
from .auth import auth as auth_blueprint
from .portfolio import portfolio as portfolio_blueprint
from .trading import trading as trading_blueprint
from .models.user import db

def create_app():
    app = Flask(__name__)
    CORS(app)
    
    app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///robinhood_dashboard.db'
    app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
    
    db.init_app(app)

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

# Enhance trading module
cat > backend/app/trading/routes.py << EOL
from flask import jsonify, request
from . import trading
from ..models.user import db
from ..models.trade import Trade

@trading.route('/execute', methods=['POST'])
def execute_trade():
    data = request.json
    new_trade = Trade(
        user_id=data['user_id'],
        symbol=data['symbol'],
        quantity=data['quantity'],
        price=data['price'],
        type=data['type']
    )
    db.session.add(new_trade)
    db.session.commit()
    return jsonify({"message": "Trade executed successfully"}), 201

@trading.route('/history', methods=['GET'])
def get_trade_history():
    user_id = request.args.get('user_id')
    trades = Trade.query.filter_by(user_id=user_id).all()
    return jsonify([{
        'symbol': trade.symbol,
        'quantity': trade.quantity,
        'price': trade.price,
        'type': trade.type,
        'timestamp': trade.timestamp
    } for trade in trades]), 200
EOL

# Frontend enhancements
echo "Enhancing frontend..."

# Add React Router for navigation
npm --prefix frontend install react-router-dom

# Create a navigation component
cat > frontend/src/components/Navigation.js << EOL
import React from 'react';
import { Link } from 'react-router-dom';

const Navigation = () => (
  <nav>
    <ul>
      <li><Link to="/">Dashboard</Link></li>
      <li><Link to="/portfolio">Portfolio</Link></li>
      <li><Link to="/trading">Trading</Link></li>
    </ul>
  </nav>
);

export default Navigation;
EOL

# Update App.js to include routing
cat > frontend/src/App.js << EOL
import React from 'react';
import { BrowserRouter as Router, Route, Switch } from 'react-router-dom';
import Navigation from './components/Navigation';
import Dashboard from './pages/Dashboard';
import Portfolio from './pages/Portfolio';
import Trading from './pages/Trading';

function App() {
  return (
    <Router>
      <div className="App">
        <Navigation />
        <Switch>
          <Route exact path="/" component={Dashboard} />
          <Route path="/portfolio" component={Portfolio} />
          <Route path="/trading" component={Trading} />
        </Switch>
      </div>
    </Router>
  );
}

export default App;
EOL

# Create Portfolio and Trading pages
cat > frontend/src/pages/Portfolio.js << EOL
import React from 'react';

const Portfolio = () => (
  <div>
    <h2>Portfolio</h2>
    {/* TODO: Implement portfolio display */}
  </div>
);

export default Portfolio;
EOL

cat > frontend/src/pages/Trading.js << EOL
import React, { useState } from 'react';

const Trading = () => {
  const [symbol, setSymbol] = useState('');
  const [quantity, setQuantity] = useState('');
  const [tradeType, setTradeType] = useState('buy');

  const handleTrade = (e) => {
    e.preventDefault();
    // TODO: Implement trade execution
    console.log('Trade:', { symbol, quantity, tradeType });
  };

  return (
    <div>
      <h2>Trading</h2>
      <form onSubmit={handleTrade}>
        <input
          type="text"
          value={symbol}
          onChange={(e) => setSymbol(e.target.value)}
          placeholder="Symbol"
          required
        />
        <input
          type="number"
          value={quantity}
          onChange={(e) => setQuantity(e.target.value)}
          placeholder="Quantity"
          required
        />
        <select value={tradeType} onChange={(e) => setTradeType(e.target.value)}>
          <option value="buy">Buy</option>
          <option value="sell">Sell</option>
        </select>
        <button type="submit">Execute Trade</button>
      </form>
    </div>
  );
};

export default Trading;
EOL

# Update Dashboard to include summary information
cat > frontend/src/pages/Dashboard.js << EOL
import React from 'react';
import Header from '../components/Header';

const Dashboard = () => (
  <div>
    <Header />
    <h2>Dashboard</h2>
    <div>
      <h3>Portfolio Summary</h3>
      {/* TODO: Implement portfolio summary */}
    </div>
    <div>
      <h3>Recent Trades</h3>
      {/* TODO: Implement recent trades list */}
    </div>
  </div>
);

export default Dashboard;
EOL

# Add a service for API calls
mkdir -p frontend/src/services
cat > frontend/src/services/api.js << EOL
const API_URL = 'http://localhost:5000/api';

export const executeTradeAPI = async (tradeData) => {
  const response = await fetch(\`\${API_URL}/trading/execute\`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(tradeData),
  });
  return response.json();
};

export const getTradeHistoryAPI = async (userId) => {
  const response = await fetch(\`\${API_URL}/trading/history?user_id=\${userId}\`);
  return response.json();
};
EOL

# Update README with new information
cat >> README.md << EOL

## Phase 3 Updates

### Backend
- Added SQLAlchemy for database operations
- Implemented User and Trade models
- Enhanced trading module with execute and history endpoints

### Frontend
- Added React Router for navigation
- Created separate pages for Dashboard, Portfolio, and Trading
- Implemented basic trading form
- Added API service for backend communication

## Running the Application

1. Start the backend:
   \`\`\`
   cd backend
   flask run
   \`\`\`

2. Start the frontend:
   \`\`\`
   cd frontend
   npm start
   \`\`\`

Visit http://localhost:3000 to view the application.
EOL

# Commit changes
git add .
git commit -m "Phase 3: Implemented database models, enhanced trading functionality, and improved frontend structure"

echo "Phase 3 of Robinhood Dashboard project has been set up at $PROJECT_ROOT"