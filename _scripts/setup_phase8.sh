#!/bin/bash

# Set the project root directory
PROJECT_ROOT="/Users/sulemanmanji/Documents/GitHub/robinhood-dashboard"

# Navigate to the project root
cd "$PROJECT_ROOT"

echo "Setting up Phase 8 of the Robinhood Dashboard project..."

# Backend Dockerfile
cat > backend/Dockerfile << EOL
FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

RUN python init_db.py  # Run the initialization script

EXPOSE 5000

CMD ["flask", "run", "--host=0.0.0.0"]
EOL

# Frontend Dockerfile
cat > frontend/Dockerfile << EOL
# Build stage
FROM node:14 as build

WORKDIR /app

COPY package.json ./
RUN npm install

COPY . .
RUN npm run build

# Production stage
FROM nginx:alpine
COPY --from=build /app/build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
EOL

# Docker Compose file
cat > docker-compose.yml << EOL
version: '3.8'

services:
  backend:
    build: ./backend
    ports:
      - "5001:5000"
    environment:
      - FLASK_APP=app:create_app
      - FLASK_ENV=development
    volumes:
      - ./backend:/app

  frontend:
    build: ./frontend
    ports:
      - "3000:80"
    depends_on:
      - backend

  loki:
    image: grafana/loki:2.4.0
    ports:
      - "3100:3100"
    command: -config.file=/etc/loki/local-config.yaml

  grafana:
    image: grafana/grafana:latest
    ports:
      - "3001:3000"
    environment:
      - GF_AUTH_ANONYMOUS_ENABLED=true
      - GF_AUTH_ANONYMOUS_ORG_ROLE=Admin
    volumes:
      - ./grafana-provisioning:/etc/grafana/provisioning

volumes:
  grafana-data:
EOL

# Create admin user script
cat > backend/create_admin_user.py << EOL
from app import create_app
from app.models.user import User, db
import secrets

app = create_app()
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
EOL

# Function to create an admin user
create_admin_user() {
    echo "Creating admin user..."
    docker-compose exec backend flask create-admin
}

# Update the rebuild_and_restart_services function
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
    # create_admin_user
}

# Add these commands to the end of your script
echo "To rebuild and restart the services, run:"
echo "bash -c 'source setup_phase8.sh && rebuild_and_restart_services'"

echo "To start the services in the background, run:"
echo "bash -c 'source setup_phase8.sh && start_services'"

echo "To check the status of the services, run:"
echo "bash -c 'source setup_phase8.sh && check_status'"

echo "To stop the services, run:"
echo "bash -c 'source setup_phase8.sh && stop_services'"