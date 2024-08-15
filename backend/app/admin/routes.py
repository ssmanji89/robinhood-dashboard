from flask import jsonify, request
from flask_jwt_extended import jwt_required, get_jwt_identity
from . import admin
from ..models.user import User, db
from ..utils.logger import loki_logger

@admin.route('/users', methods=['GET'])
@jwt_required()
def get_users():
    current_user_id = get_jwt_identity()
    current_user = User.query.get(current_user_id)
    if not current_user.is_admin:
        return jsonify({"message": "Admin access required"}), 403
    
    users = User.query.all()
    return jsonify([{
        'id': user.id,
        'username': user.username,
        'email': user.email,
        'is_admin': user.is_admin
    } for user in users]), 200

@admin.route('/user/<int:user_id>', methods=['PUT'])
@jwt_required()
def update_user(user_id):
    current_user_id = get_jwt_identity()
    current_user = User.query.get(current_user_id)
    if not current_user.is_admin:
        return jsonify({"message": "Admin access required"}), 403
    
    user = User.query.get(user_id)
    if not user:
        return jsonify({"message": "User not found"}), 404
    
    data = request.json
    user.username = data.get('username', user.username)
    user.email = data.get('email', user.email)
    user.is_admin = data.get('is_admin', user.is_admin)
    
    db.session.commit()
    loki_logger.info(f"Admin {current_user.username} updated user {user.username}")
    return jsonify({"message": "User updated successfully"}), 200

@admin.route('/stats', methods=['GET'])
@jwt_required()
def get_stats():
    current_user_id = get_jwt_identity()
    current_user = User.query.get(current_user_id)
    if not current_user.is_admin:
        return jsonify({"message": "Admin access required"}), 403
    
    total_users = User.query.count()
    admin_users = User.query.filter_by(is_admin=True).count()
    
    return jsonify({
        "total_users": total_users,
        "admin_users": admin_users
    }), 200
