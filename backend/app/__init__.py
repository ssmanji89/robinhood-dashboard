from flask import Flask
from flask_cors import CORS
from flask_jwt_extended import JWTManager
from flask_socketio import SocketIO
from flask_mail import Mail
from flask_sqlalchemy import SQLAlchemy
from apscheduler.schedulers.background import BackgroundScheduler
from dotenv import load_dotenv
import os

load_dotenv()

db = SQLAlchemy()
socketio = SocketIO()
scheduler = BackgroundScheduler()
mail = Mail()

def create_app():
    app = Flask(__name__)
    CORS(app, resources={r"/api/*": {"origins": "http://localhost:3000"}})
    
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

    with app.app_context():
        from .auth import auth as auth_blueprint
        from .portfolio import portfolio as portfolio_blueprint
        from .trading import trading as trading_blueprint
        from .notifications import notifications as notifications_blueprint
        from .admin import admin as admin_blueprint
        from .models.user import User

        app.register_blueprint(auth_blueprint, url_prefix='/api/auth')
        app.register_blueprint(portfolio_blueprint, url_prefix='/api/portfolio')
        app.register_blueprint(trading_blueprint, url_prefix='/api/trading')
        app.register_blueprint(notifications_blueprint, url_prefix='/api/notifications')
        app.register_blueprint(admin_blueprint, url_prefix='/api/admin')

        @app.route('/api/health')
        def health_check():
            return {'status': 'healthy'}, 200

        db.create_all()

    scheduler.start()

    @app.cli.command('create-admin')
    def create_admin():
        """Create an admin user."""
        import secrets
        
        with app.app_context():
            existing_admin = User.query.filter_by(username='admin').first()
            if existing_admin:
                print("Admin user already exists. Skipping creation.")
            else:
                password = secrets.token_urlsafe(12)
                admin = User(username='admin', email='admin@example.com', is_admin=True)
                admin.set_password(password)
                db.session.add(admin)
                db.session.commit()
                print("Admin user created successfully.")
                print(f"Username: admin")
                print(f"Password: {password}")
                print("Please store this password securely and change it after first login.")

    @app.cli.command('list-users')
    def list_users():
        """List all users."""
        with app.app_context():
            users = User.query.all()
            for user in users:
                print(f"ID: {user.id}, Username: {user.username}, Email: {user.email}, Admin: {user.is_admin}")

    return app