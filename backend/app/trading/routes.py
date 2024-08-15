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
