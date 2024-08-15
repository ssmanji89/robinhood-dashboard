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
