from flask import jsonify
from . import auth

@auth.route('/login', methods=['POST'])
def login():
    # TODO: Implement Robinhood login
    return jsonify({"message": "Login functionality to be implemented"}), 200

@auth.route('/logout', methods=['POST'])
def logout():
    # TODO: Implement logout
    return jsonify({"message": "Logout functionality to be implemented"}), 200
