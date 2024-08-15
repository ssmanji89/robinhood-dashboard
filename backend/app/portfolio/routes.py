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
