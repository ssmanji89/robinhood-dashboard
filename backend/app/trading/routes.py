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
