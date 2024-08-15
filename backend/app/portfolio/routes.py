from flask import jsonify
from . import portfolio

@portfolio.route('/holdings', methods=['GET'])
def get_holdings():
    # TODO: Implement fetching portfolio holdings
    return jsonify({"message": "Portfolio holdings to be implemented"}), 200
