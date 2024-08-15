from flask import jsonify, request
from flask_jwt_extended import jwt_required, get_jwt_identity
from . import notifications
from ..models.user import User, db
from ..utils.logger import loki_logger
from flask_mail import Message, Mail

mail = Mail()

@notifications.route('/settings', methods=['GET', 'POST'])
@jwt_required()
def notification_settings():
    user_id = get_jwt_identity()
    user = User.query.get(user_id)

    if request.method == 'POST':
        data = request.json
        user.email_notifications = data.get('email_notifications', user.email_notifications)
        user.push_notifications = data.get('push_notifications', user.push_notifications)
        db.session.commit()
        loki_logger.info(f"User {user_id} updated notification settings")
        return jsonify({"message": "Notification settings updated successfully"}), 200

    return jsonify({
        "email_notifications": user.email_notifications,
        "push_notifications": user.push_notifications
    }), 200

@notifications.route('/send', methods=['POST'])
@jwt_required()
def send_notification():
    user_id = get_jwt_identity()
    user = User.query.get(user_id)
    data = request.json

    if user.email_notifications:
        try:
            msg = Message(data['subject'],
                          sender="noreply@robinhooddashboard.com",
                          recipients=[user.email])
            msg.body = data['body']
            mail.send(msg)
            loki_logger.info(f"Email notification sent to user {user_id}")
        except Exception as e:
            loki_logger.error(f"Failed to send email notification to user {user_id}: {str(e)}")
            return jsonify({"error": "Failed to send email notification"}), 500

    if user.push_notifications:
        # Implement push notification logic here
        pass

    return jsonify({"message": "Notification sent successfully"}), 200
