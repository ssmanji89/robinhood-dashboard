#!/bin/bash

# Set the project root directory
PROJECT_ROOT="/Users/sulemanmanji/Documents/GitHub/robinhood-dashboard"

# Navigate to the project root
cd "$PROJECT_ROOT"

echo "Setting up Phase 6 of the Robinhood Dashboard project..."

# Backend enhancements
echo "Enhancing backend..."

# Add new dependencies
echo "pandas" >> backend/requirements.txt
echo "numpy" >> backend/requirements.txt
echo "scikit-learn" >> backend/requirements.txt
echo "python-logging-loki" >> backend/requirements.txt

# Create a new module for advanced trading strategies
mkdir -p backend/app/strategies
cat > backend/app/strategies/__init__.py << EOL
from .moving_average import MovingAverageCrossover
from .rsi import RSIStrategy
EOL

cat > backend/app/strategies/moving_average.py << EOL
import pandas as pd
import numpy as np

class MovingAverageCrossover:
    def __init__(self, short_window=50, long_window=200):
        self.short_window = short_window
        self.long_window = long_window

    def generate_signals(self, data):
        signals = pd.DataFrame(index=data.index)
        signals['signal'] = 0.0

        signals['short_mavg'] = data['Close'].rolling(window=self.short_window, min_periods=1, center=False).mean()
        signals['long_mavg'] = data['Close'].rolling(window=self.long_window, min_periods=1, center=False).mean()

        signals['signal'][self.short_window:] = np.where(signals['short_mavg'][self.short_window:] 
                                                         > signals['long_mavg'][self.short_window:], 1.0, 0.0)   
        signals['positions'] = signals['signal'].diff()

        return signals
EOL

cat > backend/app/strategies/rsi.py << EOL
import pandas as pd
import numpy as np

class RSIStrategy:
    def __init__(self, period=14, overbought=70, oversold=30):
        self.period = period
        self.overbought = overbought
        self.oversold = oversold

    def generate_signals(self, data):
        delta = data['Close'].diff()
        gain = (delta.where(delta > 0, 0)).rolling(window=self.period).mean()
        loss = (-delta.where(delta < 0, 0)).rolling(window=self.period).mean()
        
        rs = gain / loss
        rsi = 100 - (100 / (1 + rs))
        
        signals = pd.DataFrame(index=data.index)
        signals['rsi'] = rsi
        signals['signal'] = 0.0
        signals['signal'] = np.where(signals['rsi'] < self.oversold, 1.0, 0.0)
        signals['signal'] = np.where(signals['rsi'] > self.overbought, -1.0, signals['signal'])
        signals['positions'] = signals['signal'].diff()
        
        return signals
EOL

# Update trading module to include strategy execution
cat > backend/app/trading/routes.py << EOL
from flask import jsonify, request
from flask_jwt_extended import jwt_required, get_jwt_identity
from . import trading
from ..models.user import db
from ..models.trade import Trade
from ..strategies import MovingAverageCrossover, RSIStrategy
import yfinance as yf

@trading.route('/execute', methods=['POST'])
@jwt_required()
def execute_trade():
    data = request.json
    new_trade = Trade(
        user_id=get_jwt_identity(),
        symbol=data['symbol'],
        quantity=data['quantity'],
        price=data['price'],
        type=data['type']
    )
    db.session.add(new_trade)
    db.session.commit()
    return jsonify({"message": "Trade executed successfully"}), 201

@trading.route('/history', methods=['GET'])
@jwt_required()
def get_trade_history():
    user_id = get_jwt_identity()
    trades = Trade.query.filter_by(user_id=user_id).all()
    return jsonify([{
        'symbol': trade.symbol,
        'quantity': trade.quantity,
        'price': trade.price,
        'type': trade.type,
        'timestamp': trade.timestamp
    } for trade in trades]), 200

@trading.route('/analyze', methods=['POST'])
@jwt_required()
def analyze_stock():
    data = request.json
    symbol = data['symbol']
    strategy = data['strategy']
    
    stock_data = yf.download(symbol, period="1y")
    
    if strategy == 'moving_average':
        strategy = MovingAverageCrossover()
    elif strategy == 'rsi':
        strategy = RSIStrategy()
    else:
        return jsonify({"error": "Invalid strategy"}), 400
    
    signals = strategy.generate_signals(stock_data)
    
    return jsonify({
        "symbol": symbol,
        "latest_signal": signals['signal'].iloc[-1],
        "latest_position": signals['positions'].iloc[-1]
    }), 200
EOL

# Implement logging
cat > backend/app/utils/logger.py << EOL
import logging
import logging_loki

class LokiLogger:
    def __init__(self):
        logging_loki.emitter.LokiEmitter.level_tag = "level"
        handler = logging_loki.LokiHandler(
            url="http://localhost:3100/loki/api/v1/push",
            tags={"application": "robinhood-dashboard"},
            version="1",
        )
        self.logger = logging.getLogger("loki-logger")
        self.logger.addHandler(handler)
        self.logger.setLevel(logging.INFO)

    def info(self, message):
        self.logger.info(message)

    def error(self, message):
        self.logger.error(message)

loki_logger = LokiLogger()
EOL

# Frontend enhancements
echo "Enhancing frontend..."

# Add new dependencies
npm --prefix frontend install react-chartjs-2 chart.js --force

# Create a new component for stock analysis
cat > frontend/src/components/StockAnalysis.js << EOL
import React, { useState } from 'react';
import { Line } from 'react-chartjs-2';
import { Chart as ChartJS, CategoryScale, LinearScale, PointElement, LineElement, Title, Tooltip, Legend } from 'chart.js';
import { analyzeStockAPI } from '../services/api';

ChartJS.register(CategoryScale, LinearScale, PointElement, LineElement, Title, Tooltip, Legend);

const StockAnalysis = () => {
  const [symbol, setSymbol] = useState('');
  const [strategy, setStrategy] = useState('moving_average');
  const [analysisResult, setAnalysisResult] = useState(null);

  const handleAnalyze = async () => {
    try {
      const result = await analyzeStockAPI(symbol, strategy);
      setAnalysisResult(result);
    } catch (error) {
      console.error('Failed to analyze stock:', error);
    }
  };

  return (
    <div>
      <h2>Stock Analysis</h2>
      <input
        type="text"
        value={symbol}
        onChange={(e) => setSymbol(e.target.value)}
        placeholder="Stock Symbol"
      />
      <select value={strategy} onChange={(e) => setStrategy(e.target.value)}>
        <option value="moving_average">Moving Average Crossover</option>
        <option value="rsi">RSI</option>
      </select>
      <button onClick={handleAnalyze}>Analyze</button>
      
      {analysisResult && (
        <div>
          <h3>Analysis Result for {analysisResult.symbol}</h3>
          <p>Latest Signal: {analysisResult.latest_signal}</p>
          <p>Latest Position: {analysisResult.latest_position}</p>
        </div>
      )}
    </div>
  );
};

export default StockAnalysis;
EOL

# Update Dashboard to include StockAnalysis component
cat > frontend/src/pages/Dashboard.js << EOL
import React from 'react';
import Header from '../components/Header';
import Portfolio from '../components/Portfolio';
import StockAnalysis from '../components/StockAnalysis';

const Dashboard = () => (
  <div>
    <Header />
    <h2>Dashboard</h2>
    <Portfolio />
    <StockAnalysis />
  </div>
);

export default Dashboard;
EOL

# Update API service to include stock analysis
cat >> frontend/src/services/api.js << EOL
export const analyzeStockAPI = (symbol, strategy) => api.post('/trading/analyze', { symbol, strategy });
EOL

# Update README with new information
cat >> README.md << EOL

## Phase 6 Updates

### Backend
- Implemented advanced trading strategies (Moving Average Crossover and RSI)
- Added stock analysis endpoint
- Implemented Loki logging for better error tracking

### Frontend
- Added StockAnalysis component for visualizing trading signals
- Enhanced Dashboard with stock analysis feature

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

3. (Optional) Set up Loki for logging:
   - Install and run Grafana Loki
   - Configure the LokiLogger in \`backend/app/utils/logger.py\` with your Loki server URL

Visit http://localhost:3000 to view the application.

## Next Steps
- Implement backtesting for trading strategies
- Add more advanced charting options
- Implement user notifications for trading signals
- Enhance error handling and add more comprehensive logging
- Add support for multiple portfolios per user
EOL

# Commit changes
git add .
git commit -m "Phase 6: Implemented advanced trading strategies, stock analysis, and enhanced logging"

echo "Phase 6 of Robinhood Dashboard project has been set up at $PROJECT_ROOT"