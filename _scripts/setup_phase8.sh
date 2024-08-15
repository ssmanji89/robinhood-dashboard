#!/bin/bash

# Set the project root directory
PROJECT_ROOT="/Users/sulemanmanji/Documents/GitHub/robinhood-dashboard"

# Navigate to the project root
cd "$PROJECT_ROOT"

echo "Setting up Phase 8 of the Robinhood Dashboard project..."

# Function to create an admin user
create_admin_user() {
    echo "Creating admin user..."
    docker-compose exec backend python3 -c "$(cat << EOF
from app import create_app
from app.models.user import User, db
import secrets

app = create_app()
with app.app_context():
    # Check if admin user already exists
    existing_admin = User.query.filter_by(username='admin').first()
    if existing_admin:
        print("Admin user already exists. Skipping creation.")
    else:
        # Generate a random password
        password = secrets.token_urlsafe(12)

        admin = User(username='admin', email='admin@example.com', is_admin=True)
        admin.set_password(password)
        db.session.add(admin)
        db.session.commit()
        print("Admin user created successfully.")
        print(f"Username: admin")
        print(f"Password: {password}")
        print("Please store this password securely and change it after first login.")
EOF
)"
}
rebuild_and_restart_services() {
    echo "Stopping services..."
    docker-compose down
    echo "Removing old images..."
    docker rmi $(docker images -q robinhood-dashboard-frontend) 2> /dev/null
    echo "Rebuilding and starting services..."
    docker-compose up --build -d
    echo "Services are starting up. Use 'docker-compose ps' to check their status."
    
    echo "Waiting for backend service to be ready..."
    for i in {1..30}; do
        if curl -s http://localhost:5001/api/health > /dev/null; then
            echo "Backend service is ready!"
            break
        fi
        echo "Attempt $i: Backend not ready yet. Waiting..."
        sleep 5
    done

    if ! curl -s http://localhost:5001/api/health > /dev/null; then
        echo "Backend service failed to start. Checking logs..."
        docker-compose logs backend
        return 1
    fi

    # Create admin user
    create_admin_user
}

# Add these commands to the end of your script
echo "To rebuild and restart the services, run:"
echo "bash -c 'source setup_phase8.sh && rebuild_and_restart_services'"
# Add these commands to the end of your script
echo "To rebuild and restart the services, run:"
echo "bash -c 'source setup_phase8.sh && rebuild_and_restart_services'"

# ... (rest of the script remains the same)
# Add these commands to the end of your script
echo "To start the services in the background, run:"
echo "bash -c 'source setup_phase8.sh && start_services'"
echo
echo "To check the status of the services, run:"
echo "bash -c 'source setup_phase8.sh && check_status'"
echo
echo "To stop the services, run:"
echo "bash -c 'source setup_phase8.sh && stop_services'"

# Commit changes
git add .
git commit -m "Phase 8: Dockerized application, set up local deployment, and added basic tests"

echo "Phase 8 of Robinhood Dashboard project has been set up at $PROJECT_ROOT"