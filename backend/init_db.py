from app import create_app
from app.models.user import User, db
import secrets

app = create_app()
with app.app_context():
    db.create_all()
    existing_admin = User.query.filter_by(username='admin').first()
    if not existing_admin:
        password = secrets.token_urlsafe(12)
        admin = User(username='admin', email='admin@example.com', is_admin=True)
        admin.set_password(password)
        db.session.add(admin)
        db.session.commit()
        print("Admin user created successfully.")
        print(f"Username: admin")
        print(f"Password: {password}")
        print("Please store this password securely and change it after first login.")