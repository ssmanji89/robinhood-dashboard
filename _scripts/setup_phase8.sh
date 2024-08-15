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
RUN pip install -r requirements.txt

COPY . .

CMD ["flask", "run", "--host=0.0.0.0"]
EOL
# Update frontend Dockerfile
cat > frontend/Dockerfile << EOL
# Build stage
FROM node:14 as build

WORKDIR /app

# Copy package.json and generate a fresh package-lock.json
COPY package.json ./
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the application
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
version: '3'

services:
  backend:
    build: ./backend
    ports:
      - "5000:5000"
    environment:
      - FLASK_APP=app/__init__.py
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
      - "3000:3000"
    environment:
      - GF_AUTH_ANONYMOUS_ENABLED=true
      - GF_AUTH_ANONYMOUS_ORG_ROLE=Admin
    volumes:
      - ./grafana-provisioning:/etc/grafana/provisioning

volumes:
  grafana-data:
EOL

# Create Grafana provisioning directory and datasource configuration
mkdir -p grafana-provisioning/datasources
cat > grafana-provisioning/datasources/loki.yml << EOL
apiVersion: 1

datasources:
  - name: Loki
    type: loki
    access: proxy
    url: http://loki:3100
    version: 1
    editable: false
EOL

# Add pytest for backend testing
echo "pytest" >> backend/requirements.txt

# Create a basic test file for the backend
mkdir -p backend/tests
cat > backend/tests/test_app.py << EOL
import pytest
from app import create_app

@pytest.fixture
def client():
    app = create_app()
    app.config['TESTING'] = True
    with app.test_client() as client:
        yield client

def test_health_check(client):
    response = client.get('/api/health')
    assert response.status_code == 200
    assert response.json == {'status': 'healthy'}

def test_login_required(client):
    response = client.get('/api/portfolio/holdings')
    assert response.status_code == 401  # Unauthorized
EOL

# Add test script to backend/package.json
sed -i '' '/"scripts": {/a\
    "test": "pytest",
' backend/package.json

# Add testing libraries for frontend
npm --prefix frontend install --save-dev @testing-library/react @testing-library/jest-dom --force

# Create a basic test file for the frontend
cat > frontend/src/App.test.js << EOL
import React from 'react';
import { render, screen } from '@testing-library/react';
import App from './App';

test('renders login page when not authenticated', () => {
  render(<App />);
  const loginElement = screen.getByText(/Login/i);
  expect(loginElement).toBeInTheDocument();
});
EOL

# Update README with new information
cat >> README.md << EOL

# Update README with new information
cat >> README.md << EOL

## Running the Application with Docker in Background

1. Start the services in detached mode:
   \`\`\`
   bash -c 'source setup_phase8.sh && start_services'
   \`\`\`

2. Check the status of the services:
   \`\`\`
   bash -c 'source setup_phase8.sh && check_status'
   \`\`\`

3. Stop the services when done:
   \`\`\`
   bash -c 'source setup_phase8.sh && stop_services'
   \`\`\`

4. Access the application:
   - Frontend: http://localhost:3000
   - Backend API: http://localhost:5001
   - Grafana: http://localhost:3001 (for log visualization)

## Running Tests

### Backend Tests
\`\`\`
cd backend
pytest
\`\`\`

### Frontend Tests
\`\`\`
cd frontend
npm test
\`\`\`

## Next Steps
- Expand test coverage for both backend and frontend
- Set up CI/CD pipeline for automated testing and deployment
- Implement end-to-end testing with tools like Cypress
- Optimize Docker images for production deployment
- Enhance logging and monitoring capabilities
EOL
# Create necessary files for React app
mkdir -p frontend/public frontend/src
cat > frontend/public/index.html << EOL
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Robinhood Dashboard</title>
  </head>
  <body>
    <noscript>You need to enable JavaScript to run this app.</noscript>
    <div id="root"></div>
  </body>
</html>
EOL

cat > frontend/src/index.js << EOL
import React from 'react';
import ReactDOM from 'react-dom';
import App from './App';

ReactDOM.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
  document.getElementById('root')
);
EOL
# Update frontend package.json
cat > frontend/package.json << EOL
{
  "name": "robinhood-dashboard-frontend",
  "version": "0.1.0",
  "private": true,
  "dependencies": {
    "react": "^17.0.2",
    "react-dom": "^17.0.2",
    "react-router-dom": "^5.2.0",
    "react-scripts": "4.0.3",
    "axios": "^0.21.1",
    "react-hot-toast": "^2.0.0",
    "react-toastify": "^8.0.0",
    "socket.io-client": "^4.1.2",
    "react-chartjs-2": "^3.0.3",
    "chart.js": "^3.3.2"
  },
  "scripts": {
    "start": "react-scripts start",
    "build": "react-scripts build",
    "test": "react-scripts test",
    "eject": "react-scripts eject"
  },
  "eslintConfig": {
    "extends": [
      "react-app",
      "react-app/jest"
    ]
  },
  "browserslist": {
    "production": [
      ">0.2%",
      "not dead",
      "not op_mini all"
    ],
    "development": [
      "last 1 chrome version",
      "last 1 firefox version",
      "last 1 safari version"
    ]
  },
  "devDependencies": {
    "@testing-library/react": "^11.2.7",
    "@testing-library/jest-dom": "^5.14.1",
    "@babel/plugin-proposal-private-property-in-object": "^7.21.11"
  }
}
EOL

# Docker Compose file
cat > docker-compose.yml << EOL
version: '3'

services:
  backend:
    build: ./backend
    ports:
      - "5001:5000"  # Changed from "5000:5000"
    environment:
      - FLASK_APP=app/__init__.py
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
      - "3001:3000"  # Changed from "3000:3000" to avoid conflict with frontend
    environment:
      - GF_AUTH_ANONYMOUS_ENABLED=true
      - GF_AUTH_ANONYMOUS_ORG_ROLE=Admin
    volumes:
      - ./grafana-provisioning:/etc/grafana/provisioning

volumes:
  grafana-data:
EOL

# Update User model
cat > backend/app/models/user.py << EOL
from flask_sqlalchemy import SQLAlchemy
from werkzeug.security import generate_password_hash, check_password_hash

db = SQLAlchemy()

class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True, nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)
    password_hash = db.Column(db.String(128))
    email_notifications = db.Column(db.Boolean, default=True)
    push_notifications = db.Column(db.Boolean, default=True)

    def set_password(self, password):
        self.password_hash = generate_password_hash(password)

    def check_password(self, password):
        return check_password_hash(self.password_hash, password)

    def __repr__(self):
        return '<User %r>' % self.username
EOL

# Update main app file
cat > backend/app/__init__.py << EOL
from flask import Flask
from flask_cors import CORS
from flask_jwt_extended import JWTManager
from flask_socketio import SocketIO
from flask_mail import Mail
from apscheduler.schedulers.background import BackgroundScheduler
from dotenv import load_dotenv
import os

from .models.user import db
from .auth import auth as auth_blueprint
from .portfolio import portfolio as portfolio_blueprint
from .trading import trading as trading_blueprint
from .notifications import notifications as notifications_blueprint

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

# Update auth routes
cat > backend/app/auth/routes.py << EOL
from flask import jsonify, request
from flask_jwt_extended import create_access_token, jwt_required, get_jwt_identity
from . import auth
from ..models.user import User, db
from ..utils.logger import loki_logger

@auth.route('/register', methods=['POST'])
def register():
    data = request.json
    user = User.query.filter_by(username=data['username']).first()
    if user:
        return jsonify({"message": "Username already exists"}), 400
    new_user = User(username=data['username'], email=data['email'])
    new_user.set_password(data['password'])
    db.session.add(new_user)
    db.session.commit()
    loki_logger.info(f"New user registered: {new_user.username}")
    return jsonify({"message": "User created successfully"}), 201

@auth.route('/login', methods=['POST'])
def login():
    data = request.json
    user = User.query.filter_by(username=data['username']).first()
    if user and user.check_password(data['password']):
        access_token = create_access_token(identity=user.id)
        loki_logger.info(f"User logged in: {user.username}")
        return jsonify(access_token=access_token), 200
    loki_logger.warning(f"Failed login attempt for username: {data['username']}")
    return jsonify({"message": "Invalid username or password"}), 401

@auth.route('/protected', methods=['GET'])
@jwt_required()
def protected():
    current_user_id = get_jwt_identity()
    return jsonify(logged_in_as=current_user_id), 200
EOL
# Docker Compose file
cat > docker-compose.yml << EOL
version: '3'

services:
  backend:
    build: ./backend
    ports:
      - "5001:5000"
    environment:
      - FLASK_APP=app/__init__.py
      - FLASK_ENV=development
    volumes:
      - ./backend:/app

  frontend:
    build: ./frontend
    ports:
      - "3000:80"  # This maps container's port 80 to host's port 3000
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
# Frontend Dockerfile
cat > frontend/Dockerfile << EOL
# Build stage
FROM node:14 as build

WORKDIR /app

COPY package*.json ./
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
# Update README with new information
cat >> README.md << EOL

## Running the Application with Docker

1. Start the services in detached mode:
   \`\`\`
   bash -c 'source setup_phase8.sh && start_services'
   \`\`\`

2. Access the application:
   - Frontend: http://localhost:3000
   - Backend API: http://localhost:5001
   - Grafana: http://localhost:3001 (for log visualization)

3. Check the status of the services:
   \`\`\`
   bash -c 'source setup_phase8.sh && check_status'
   \`\`\`

4. Stop the services when done:
   \`\`\`
   bash -c 'source setup_phase8.sh && stop_services'
   \`\`\`

Note: The frontend is served by Nginx on port 80 inside the container, which is mapped to port 3000 on your host machine.
EOL
# Update Portfolio component
cat > frontend/src/pages/Portfolio.js << EOL
import React, { useState, useEffect } from 'react';
import { getHoldingsAPI, getPerformanceAPI, socket } from '../services/api';
import { toast } from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';

const Portfolio = () => {
  const [holdings, setHoldings] = useState({});
  const [performance, setPerformance] = useState({});

  useEffect(() => {
    const fetchHoldings = async () => {
      try {
        const response = await getHoldingsAPI();
        setHoldings(response.data);
      } catch (error) {
        console.error('Failed to fetch holdings:', error);
        toast.error('Failed to fetch holdings');
      }
    };

    const fetchPerformance = async () => {
      try {
        const response = await getPerformanceAPI();
        setPerformance(response.data);
      } catch (error) {
        console.error('Failed to fetch performance:', error);
        toast.error('Failed to fetch performance data');
      }
    };

    fetchHoldings();
    fetchPerformance();

    socket.on('stock_update', (data) => {
      setHoldings((prevHoldings) => {
        const updatedHoldings = { ...prevHoldings };
        Object.keys(data).forEach((symbol) => {
          if (updatedHoldings[symbol]) {
            updatedHoldings[symbol].currentPrice = data[symbol];
          }
        });
        return updatedHoldings;
      });
    });

    return () => {
      socket.off('stock_update');
    };
  }, []);

  return (
    <div>
      <h2>Portfolio</h2>
      <table>
        <thead>
          <tr>
            <th>Symbol</th>
            <th>Quantity</th>
            <th>Current Price</th>
            <th>Current Value</th>
            <th>Cost Basis</th>
            <th>Profit/Loss</th>
            <th>Profit/Loss %</th>
          </tr>
        </thead>
        <tbody>
          {Object.entries(performance).map(([symbol, data]) => (
            <tr key={symbol}>
              <td>{symbol}</td>
              <td>{data.quantity}</td>
              <td>\${(holdings[symbol]?.currentPrice || 0).toFixed(2)}</td>
              <td>\${data.current_value.toFixed(2)}</td>
              <td>\${data.cost_basis.toFixed(2)}</td>
              <td>\${data.profit_loss.toFixed(2)}</td>
              <td>{data.profit_loss_percent.toFixed(2)}%</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
};

export default Portfolio;
EOL
# Function to start services
start_services() {
    echo "Building and starting services in detached mode..."
    docker-compose up --build -d
    echo "Services are starting up. Use 'docker-compose ps' to check their status."
}

# Function to stop services
stop_services() {
    echo "Stopping services..."
    docker-compose down
    echo "Services have been stopped."
}

# Function to check service status
check_status() {
    echo "Checking status of services..."
    docker-compose ps
}
#!/bin/bash

# ... (previous content remains the same)

# Update frontend API service file
cat > frontend/src/services/api.js << EOL
import axios from 'axios';
import io from 'socket.io-client';

const API_URL = 'http://localhost:5001/api';
const SOCKET_URL = 'http://localhost:5001';

const api = axios.create({
  baseURL: API_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

api.interceptors.request.use((config) => {
  const token = localStorage.getItem('token');
  if (token) {
    config.headers.Authorization = \`Bearer \${token}\`;
  }
  return config;
});

export const socket = io(SOCKET_URL);

export const login = (credentials) => api.post('/auth/login', credentials);
export const register = (userData) => api.post('/auth/register', userData);
export const executeTradeAPI = (tradeData) => api.post('/trading/execute', tradeData);
export const getTradeHistoryAPI = () => api.get('/trading/history');
export const getHoldingsAPI = () => api.get('/portfolio/holdings');
export const getPerformanceAPI = () => api.get('/portfolio/performance');
export const analyzeStockAPI = (symbol, strategy) => api.post('/trading/analyze', { symbol, strategy });
export const getNotificationSettingsAPI = () => api.get('/notifications/settings');
export const updateNotificationSettingsAPI = (settings) => api.post('/notifications/settings', settings);

export default api;
EOL

# Update frontend package.json to include the missing babel plugin
cat > frontend/package.json << EOL
{
  "name": "robinhood-dashboard-frontend",
  "version": "0.1.0",
  "private": true,
  "dependencies": {
    "react": "^17.0.2",
    "react-dom": "^17.0.2",
    "react-router-dom": "^5.2.0",
    "react-scripts": "4.0.3",
    "axios": "^0.21.1",
    "react-hot-toast": "^2.0.0",
    "react-toastify": "^8.0.0",
    "socket.io-client": "^4.1.2",
    "react-chartjs-2": "^3.0.3",
    "chart.js": "^3.3.2"
  },
  "scripts": {
    "start": "react-scripts start",
    "build": "react-scripts build",
    "test": "react-scripts test",
    "eject": "react-scripts eject"
  },
  "eslintConfig": {
    "extends": [
      "react-app",
      "react-app/jest"
    ]
  },
  "browserslist": {
    "production": [
      ">0.2%",
      "not dead",
      "not op_mini all"
    ],
    "development": [
      "last 1 chrome version",
      "last 1 firefox version",
      "last 1 safari version"
    ]
  },
  "devDependencies": {
    "@testing-library/react": "^11.2.7",
    "@testing-library/jest-dom": "^5.14.1",
    "@babel/plugin-proposal-private-property-in-object": "^7.21.11"
  }
}
EOL

# Update frontend Dockerfile to use npm ci for a clean install
cat > frontend/Dockerfile << EOL
# Build stage
FROM node:14 as build

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build

# Production stage
FROM nginx:alpine
COPY --from=build /app/build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
EOL

# Update frontend Dockerfile
cat > frontend/Dockerfile << EOL
# Build stage
FROM node:14 as build

WORKDIR /app

# Copy package.json
COPY package.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the application
RUN npm run build

# Production stage
FROM nginx:alpine
COPY --from=build /app/build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
EOL

# Update frontend package.json
cat > frontend/package.json << EOL
{
  "name": "robinhood-dashboard-frontend",
  "version": "0.1.0",
  "private": true,
  "dependencies": {
    "react": "^17.0.2",
    "react-dom": "^17.0.2",
    "react-router-dom": "^5.2.0",
    "react-scripts": "4.0.3",
    "axios": "^0.21.1",
    "react-hot-toast": "^2.0.0",
    "react-toastify": "^8.0.0",
    "socket.io-client": "^4.1.2",
    "react-chartjs-2": "^3.0.3",
    "chart.js": "^3.3.2"
  },
  "scripts": {
    "start": "react-scripts start",
    "build": "react-scripts build",
    "test": "react-scripts test",
    "eject": "react-scripts eject"
  },
  "eslintConfig": {
    "extends": [
      "react-app",
      "react-app/jest"
    ]
  },
  "browserslist": {
    "production": [
      ">0.2%",
      "not dead",
      "not op_mini all"
    ],
    "development": [
      "last 1 chrome version",
      "last 1 firefox version",
      "last 1 safari version"
    ]
  },
  "devDependencies": {
    "@testing-library/react": "^11.2.7",
    "@testing-library/jest-dom": "^5.14.1",
    "@babel/plugin-proposal-private-property-in-object": "^7.21.11"
  }
}
EOL
# Add this to the existing setup_phase8.sh script

# Update User model to include admin flag
cat > backend/app/models/user.py << EOL
from flask_sqlalchemy import SQLAlchemy
from werkzeug.security import generate_password_hash, check_password_hash

db = SQLAlchemy()

class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True, nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)
    password_hash = db.Column(db.String(128))
    email_notifications = db.Column(db.Boolean, default=True)
    push_notifications = db.Column(db.Boolean, default=True)
    is_admin = db.Column(db.Boolean, default=False)

    def set_password(self, password):
        self.password_hash = generate_password_hash(password)

    def check_password(self, password):
        return check_password_hash(self.password_hash, password)

    def __repr__(self):
        return '<User %r>' % self.username
EOL

# Create new admin blueprint
mkdir -p backend/app/admin
cat > backend/app/admin/__init__.py << EOL
from flask import Blueprint

admin = Blueprint('admin', __name__)

from . import routes
EOL

# Create admin routes
cat > backend/app/admin/routes.py << EOL
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
EOL

# Update main app file to include admin blueprint
sed -i '/from .notifications import notifications as notifications_blueprint/a from .admin import admin as admin_blueprint' backend/app/__init__.py
sed -i '/app.register_blueprint(notifications_blueprint, url_prefix='"'"'\/api\/notifications'"'"')/a \    app.register_blueprint(admin_blueprint, url_prefix='"'"'/api/admin'"'"')' backend/app/__init__.py

# Create AdminDashboard component for frontend
mkdir -p frontend/src/components
cat > frontend/src/components/AdminDashboard.js << EOL
import React, { useState, useEffect } from 'react';
import { getUsers, updateUser, getStats } from '../services/api';

const AdminDashboard = () => {
  const [users, setUsers] = useState([]);
  const [stats, setStats] = useState({});

  useEffect(() => {
    fetchUsers();
    fetchStats();
  }, []);

  const fetchUsers = async () => {
    try {
      const response = await getUsers();
      setUsers(response.data);
    } catch (error) {
      console.error('Failed to fetch users:', error);
    }
  };

  const fetchStats = async () => {
    try {
      const response = await getStats();
      setStats(response.data);
    } catch (error) {
      console.error('Failed to fetch stats:', error);
    }
  };

  const handleUpdateUser = async (userId, userData) => {
    try {
      await updateUser(userId, userData);
      fetchUsers();
    } catch (error) {
      console.error('Failed to update user:', error);
    }
  };

  return (
    <div>
      <h2>Admin Dashboard</h2>
      <div>
        <h3>Stats</h3>
        <p>Total Users: {stats.total_users}</p>
        <p>Admin Users: {stats.admin_users}</p>
      </div>
      <div>
        <h3>User Management</h3>
        <table>
          <thead>
            <tr>
              <th>ID</th>
              <th>Username</th>
              <th>Email</th>
              <th>Admin</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            {users.map(user => (
              <tr key={user.id}>
                <td>{user.id}</td>
                <td>{user.username}</td>
                <td>{user.email}</td>
                <td>{user.is_admin ? 'Yes' : 'No'}</td>
                <td>
                  <button onClick={() => handleUpdateUser(user.id, { is_admin: !user.is_admin })}>
                    Toggle Admin
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
};

export default AdminDashboard;
EOL

# Update API service to include admin functions
cat >> frontend/src/services/api.js << EOL
export const getUsers = () => api.get('/admin/users');
export const updateUser = (userId, userData) => api.put(\`/admin/user/\${userId}\`, userData);
export const getStats = () => api.get('/admin/stats');
EOL

# Update App.js to include AdminDashboard route
sed -i '/<Route path="\/trading">/a \          <Route path="/admin">\n            {isAuthenticated ? <AdminDashboard /> : <Redirect to="/login" />}\n          </Route>' frontend/src/App.js

# Add AdminDashboard import to App.js
sed -i '/import NotificationSettings from/a import AdminDashboard from '"'"'./components/AdminDashboard'"'"';' frontend/src/App.js

# Update README with new admin functionality
cat >> README.md << EOL

## Admin Functionality

An administrative dashboard has been added to manage users and view system statistics.

To access the admin dashboard:
1. Log in with an admin account
2. Navigate to /admin in the application

Admin features include:
- Viewing all users
- Toggling admin status for users
- Viewing system statistics (total users, admin users)

Note: Ensure that at least one admin user is created in the database for initial access.
EOL

# Function to create an admin user
create_admin_user() {
    echo "Creating admin user..."
    python3 << EOL
from app import create_app
from app.models.user import User, db

app = create_app()
with app.app_context():
    admin = User(username='admin', email='admin@example.com', is_admin=True)
    admin.set_password('adminpassword')
    db.session.add(admin)
    db.session.commit()
    print("Admin user created successfully.")
EOL
}

# Add create_admin_user to the rebuild_and_restart_services function
sed -i '/echo "Services are starting up."/a \    create_admin_user' setup_phase8.sh

echo "Admin functionality has been added. Remember to use the create_admin_user function to set up the initial admin account."

cat > frontend/src/components/Login.js << EOL
import React, { useState } from 'react';
import { useHistory } from 'react-router-dom';
import { login } from '../services/api';

const Login = ({ onLogin }) => {
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const history = useHistory();

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      const response = await login({ username, password });
      localStorage.setItem('token', response.data.access_token);
      onLogin();
      history.push('/');
    } catch (error) {
      console.error('Login failed:', error);
      setError('Invalid username or password');
    }
  };

  return (
    <form onSubmit={handleSubmit}>
      {error && <p style={{ color: 'red' }}>{error}</p>}
      <input
        type="text"
        value={username}
        onChange={(e) => setUsername(e.target.value)}
        placeholder="Username"
        required
      />
      <input
        type="password"
        value={password}
        onChange={(e) => setPassword(e.target.value)}
        placeholder="Password"
        required
      />
      <button type="submit">Login</button>
    </form>
  );
};

export default Login;
EOL

cat > frontend/src/App.js << EOL
import React, { useState, useEffect } from 'react';
import { BrowserRouter as Router, Route, Switch, Redirect } from 'react-router-dom';
import { Toaster } from 'react-hot-toast';
import Navigation from './components/Navigation';
import Dashboard from './pages/Dashboard';
import Portfolio from './pages/Portfolio';
import Trading from './pages/Trading';
import NotificationSettings from './components/NotificationSettings';
import AdminDashboard from './components/AdminDashboard';
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
          <Route path="/admin">
            {isAuthenticated ? <AdminDashboard /> : <Redirect to="/login" />}
          </Route>
        </Switch>
        <Toaster position="top-right" />
      </div>
    </Router>
  );
}

export default App;
EOL

cat > frontend/src/components/AdminDashboard.js << EOL
import React, { useState, useEffect } from 'react';
import { getUsers, updateUser, getStats } from '../services/api';

const AdminDashboard = () => {
  const [users, setUsers] = useState([]);
  const [stats, setStats] = useState({});
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    fetchUsers();
    fetchStats();
  }, []);

  const fetchUsers = async () => {
    try {
      setLoading(true);
      const response = await getUsers();
      setUsers(response.data);
      setError(null);
    } catch (error) {
      console.error('Failed to fetch users:', error);
      setError('Failed to fetch users. Please try again.');
    } finally {
      setLoading(false);
    }
  };

  const fetchStats = async () => {
    try {
      const response = await getStats();
      setStats(response.data);
    } catch (error) {
      console.error('Failed to fetch stats:', error);
    }
  };

  const handleUpdateUser = async (userId, userData) => {
    try {
      await updateUser(userId, userData);
      fetchUsers();
    } catch (error) {
      console.error('Failed to update user:', error);
      setError('Failed to update user. Please try again.');
    }
  };

  if (loading) return <div>Loading...</div>;
  if (error) return <div>Error: {error}</div>;

  return (
    <div>
      <h2>Admin Dashboard</h2>
      <div>
        <h3>Stats</h3>
        <p>Total Users: {stats.total_users}</p>
        <p>Admin Users: {stats.admin_users}</p>
      </div>
      <div>
        <h3>User Management</h3>
        <table>
          <thead>
            <tr>
              <th>ID</th>
              <th>Username</th>
              <th>Email</th>
              <th>Admin</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            {users.map(user => (
              <tr key={user.id}>
                <td>{user.id}</td>
                <td>{user.username}</td>
                <td>{user.email}</td>
                <td>{user.is_admin ? 'Yes' : 'No'}</td>
                <td>
                  <button onClick={() => handleUpdateUser(user.id, { is_admin: !user.is_admin })}>
                    Toggle Admin
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
};

export default AdminDashboard;
EOL

cat > backend/app/__init__.py << EOL
from flask import Flask
from flask_cors import CORS
from flask_jwt_extended import JWTManager
from flask_socketio import SocketIO
from flask_mail import Mail
from apscheduler.schedulers.background import BackgroundScheduler
from dotenv import load_dotenv
import os

from .models.user import db
from .auth import auth as auth_blueprint
from .portfolio import portfolio as portfolio_blueprint
from .trading import trading as trading_blueprint
from .notifications import notifications as notifications_blueprint
from .admin import admin as admin_blueprint

load_dotenv()

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

    app.register_blueprint(auth_blueprint, url_prefix='/api/auth')
    app.register_blueprint(portfolio_blueprint, url_prefix='/api/portfolio')
    app.register_blueprint(trading_blueprint, url_prefix='/api/trading')
    app.register_blueprint(notifications_blueprint, url_prefix='/api/notifications')
    app.register_blueprint(admin_blueprint, url_prefix='/api/admin')

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
# Update rebuild_and_restart_services function
rebuild_and_restart_services() {
    echo "Stopping services..."
    docker-compose down
    echo "Removing old images..."
    docker rmi $(docker images -q robinhood-dashboard-frontend) 2> /dev/null
    echo "Rebuilding and starting services..."
    docker-compose up --build -d
    echo "Services are starting up. Use 'docker-compose ps' to check their status."
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