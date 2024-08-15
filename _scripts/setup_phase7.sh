#!/bin/bash

# Set the project root directory
PROJECT_ROOT="/Users/sulemanmanji/Documents/GitHub/robinhood-dashboard"

# Navigate to the project root
cd "$PROJECT_ROOT"

echo "Setting up Phase 7 of the Robinhood Dashboard project..."

# Backend enhancements
echo "Enhancing backend..."

# Add new dependencies
echo "flask-mail" >> backend/requirements.txt

# Create a new module for notifications
mkdir -p backend/app/notifications
cat > backend/app/notifications/__init__.py << EOL
from flask import Blueprint

notifications = Blueprint('notifications', __name__)

from . import routes
EOL

cat > backend/app/notifications/routes.py << EOL
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
EOL

# Update User model to include notification preferences
cat >> backend/app/models/user.py << EOL

class User(db.Model):
    # ... (existing fields)
    email_notifications = db.Column(db.Boolean, default=True)
    push_notifications = db.Column(db.Boolean, default=True)
EOL

# Update main app file to include notifications and error handling
cat > backend/app/__init__.py << EOL
from flask import Flask, jsonify
from flask_cors import CORS
from flask_sqlalchemy import SQLAlchemy
from flask_jwt_extended import JWTManager
from flask_socketio import SocketIO
from flask_mail import Mail
from apscheduler.schedulers.background import BackgroundScheduler
from dotenv import load_dotenv
import os

from .auth import auth as auth_blueprint
from .portfolio import portfolio as portfolio_blueprint
from .trading import trading as trading_blueprint
from .notifications import notifications as notifications_blueprint
from .models.user import db
from .utils.logger import loki_logger

load_dotenv()

socketio = SocketIO()
scheduler = BackgroundScheduler()
mail = Mail()

def create_app():
    app = Flask(__name__)
    CORS(app)
    
    app.config['SECRET_KEY'] = os.getenv('SECRET_KEY')
    app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///robinhood_dashboard.db'
    app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
    app.config['JWT_SECRET_KEY'] = os.getenv('SECRET_KEY')
    app.config['MAIL_SERVER'] = os.getenv('MAIL_SERVER')
    app.config['MAIL_PORT'] = int(os.getenv('MAIL_PORT', 587))
    app.config['MAIL_USE_TLS'] = os.getenv('MAIL_USE_TLS', 'True') == 'True'
    app.config['MAIL_USERNAME'] = os.getenv('MAIL_USERNAME')
    app.config['MAIL_PASSWORD'] = os.getenv('MAIL_PASSWORD')
    
    db.init_app(app)
    JWTManager(app)
    socketio.init_app(app, cors_allowed_origins="*")
    mail.init_app(app)

    app.register_blueprint(auth_blueprint, url_prefix='/api/auth')
    app.register_blueprint(portfolio_blueprint, url_prefix='/api/portfolio')
    app.register_blueprint(trading_blueprint, url_prefix='/api/trading')
    app.register_blueprint(notifications_blueprint, url_prefix='/api/notifications')

    @app.errorhandler(404)
    def not_found(error):
        loki_logger.error(f"404 error: {str(error)}")
        return jsonify({"error": "Not found"}), 404

    @app.errorhandler(500)
    def internal_error(error):
        loki_logger.error(f"500 error: {str(error)}")
        return jsonify({"error": "Internal server error"}), 500

    @app.route('/api/health')
    def health_check():
        return {'status': 'healthy'}, 200

    with app.app_context():
        db.create_all()

    scheduler.start()

    return app

if __name__ == '__main__':
    app = create_app()
    socketio.run(app, debug=True)
EOL

# Frontend enhancements
echo "Enhancing frontend..."

# Add new dependencies
npm --prefix frontend install react-hot-toast --force

# Create a new component for notification settings
cat > frontend/src/components/NotificationSettings.js << EOL
import React, { useState, useEffect } from 'react';
import { getNotificationSettingsAPI, updateNotificationSettingsAPI } from '../services/api';
import toast from 'react-hot-toast';

const NotificationSettings = () => {
  const [settings, setSettings] = useState({
    email_notifications: true,
    push_notifications: true,
  });

  useEffect(() => {
    const fetchSettings = async () => {
      try {
        const response = await getNotificationSettingsAPI();
        setSettings(response.data);
      } catch (error) {
        console.error('Failed to fetch notification settings:', error);
        toast.error('Failed to load notification settings');
      }
    };
    fetchSettings();
  }, []);

  const handleChange = (e) => {
    setSettings({ ...settings, [e.target.name]: e.target.checked });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      await updateNotificationSettingsAPI(settings);
      toast.success('Notification settings updated successfully');
    } catch (error) {
      console.error('Failed to update notification settings:', error);
      toast.error('Failed to update notification settings');
    }
  };

  return (
    <div>
      <h2>Notification Settings</h2>
      <form onSubmit={handleSubmit}>
        <div>
          <label>
            <input
              type="checkbox"
              name="email_notifications"
              checked={settings.email_notifications}
              onChange={handleChange}
            />
            Email Notifications
          </label>
        </div>
        <div>
          <label>
            <input
              type="checkbox"
              name="push_notifications"
              checked={settings.push_notifications}
              onChange={handleChange}
            />
            Push Notifications
          </label>
        </div>
        <button type="submit">Save Settings</button>
      </form>
    </div>
  );
};

export default NotificationSettings;
EOL

# Update API service to include notification settings
cat >> frontend/src/services/api.js << EOL
export const getNotificationSettingsAPI = () => api.get('/notifications/settings');
export const updateNotificationSettingsAPI = (settings) => api.post('/notifications/settings', settings);
EOL

# Update App.js to include toast notifications
cat > frontend/src/App.js << EOL
import React, { useState, useEffect } from 'react';
import { BrowserRouter as Router, Route, Switch, Redirect } from 'react-router-dom';
import { Toaster } from 'react-hot-toast';
import Navigation from './components/Navigation';
import Dashboard from './pages/Dashboard';
import Portfolio from './pages/Portfolio';
import Trading from './pages/Trading';
import NotificationSettings from './components/NotificationSettings';
import Login from './components/Login';

function App() {
  const [isAuthenticated, setIsAuthenticated] = useState(false);

  useEffect(() => {
    const token = localStorage.getItem('token');
    if (token) {
      setIsAuthenticated(true);
    }
  }, []);

  const handleLogin = () => {
    setIsAuthenticated(true);
  };

  const handleLogout = () => {
    localStorage.removeItem('token');
    setIsAuthenticated(false);
  };

  return (
    <Router>
      <div className="App">
        {isAuthenticated && <Navigation onLogout={handleLogout} />}
        <Switch>
          <Route exact path="/login">
            {isAuthenticated ? <Redirect to="/" /> : <Login onLogin={handleLogin} />}
          </Route>
          <Route exact path="/">
            {isAuthenticated ? <Dashboard /> : <Redirect to="/login" />}
          </Route>
          <Route path="/portfolio">
            {isAuthenticated ? <Portfolio /> : <Redirect to="/login" />}
          </Route>
          <Route path="/trading">
            {isAuthenticated ? <Trading /> : <Redirect to="/login" />}
          </Route>
          <Route path="/notifications">
            {isAuthenticated ? <NotificationSettings /> : <Redirect to="/login" />}
          </Route>
        </Switch>
        <Toaster position="top-right" />
      </div>
    </Router>
  );
}

export default App;
EOL

# Update README with new information
cat >> README.md << EOL

## Phase 7 Updates

### Backend
- Implemented notification system with email support
- Added user preferences for notifications
- Enhanced error handling and logging

### Frontend
- Added NotificationSettings component for managing user preferences
- Implemented toast notifications for better user feedback
- Enhanced error handling in API calls

## Environment Variables
Add the following to your \`.env\` file:
- MAIL_SERVER
- MAIL_PORT
- MAIL_USE_TLS
- MAIL_USERNAME
- MAIL_PASSWORD

## Next Steps
- Implement push notifications
- Add more advanced user preferences
- Enhance security measures (e.g., rate limiting, additional authentication methods)
- Implement a dashboard for administrators
- Add more comprehensive analytics and reporting features
EOL

# Commit changes
git add .
git commit -m "Phase 7: Implemented notification system, enhanced error handling, and improved user experience"

echo "Phase 7 of Robinhood Dashboard project has been set up at $PROJECT_ROOT"