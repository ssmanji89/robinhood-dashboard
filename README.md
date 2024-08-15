# Robinhood Dashboard

This project is a programmatic trading system dashboard for Robinhood, developed using Python and React.js.

## Structure

- `backend/`: Python Flask backend
- `frontend/`: React.js frontend

## Setup

1. Set up the backend:
   ```
   cd backend
   python -m venv venv
   source venv/bin/activate
   pip install -r requirements.txt
   ```

2. Set up the frontend:
   ```
   cd frontend
   npm install
   ```

## Running the application

1. Backend:
   ```
   cd backend
   flask run
   ```

2. Frontend:
   ```
   cd frontend
   npm start
   ```

## Project Structure

### Backend
- `auth/`: Authentication module
- `portfolio/`: Portfolio management module
- `trading/`: Trading execution module

### Frontend
- `components/`: Reusable React components
- `pages/`: Main page components
- `services/`: API and other services

## Testing

### Backend
Run tests with pytest:
```
cd backend
pytest
```

### Frontend
Run tests with React Testing Library:
```
cd frontend
npm test
```

## Phase 3 Updates

### Backend
- Added SQLAlchemy for database operations
- Implemented User and Trade models
- Enhanced trading module with execute and history endpoints

### Frontend
- Added React Router for navigation
- Created separate pages for Dashboard, Portfolio, and Trading
- Implemented basic trading form
- Added API service for backend communication

## Running the Application

1. Start the backend:
   ```
   cd backend
   flask run
   ```

2. Start the frontend:
   ```
   cd frontend
   npm start
   ```

Visit http://localhost:3000 to view the application.

## Phase 4 Updates

### Backend
- Implemented JWT authentication
- Added environment variable support
- Enhanced portfolio module with holdings and performance endpoints

### Frontend
- Added login functionality
- Implemented protected routes
- Updated Portfolio page to display holdings
- Added axios for API calls

## Security Note
Make sure to keep your .env file secure and never commit it to version control.

## Next Steps
- Implement real-time data updates
- Add more advanced trading features
- Enhance error handling and user feedback
- Implement proper logout functionality
- Add unit and integration tests

## Phase 5 Updates

### Backend
- Implemented real-time stock price updates using WebSockets
- Added performance calculation for portfolio holdings
- Integrated yfinance for fetching current stock prices
- Implemented background job scheduling for periodic updates

### Frontend
- Added real-time updates to the Portfolio page
- Implemented performance metrics display in the Portfolio
- Added toast notifications for better user feedback

## Running the Application

1. Start the backend:
   ```
   cd backend
   flask run
   ```

2. Start the frontend:
   ```
   cd frontend
   npm start
   ```

Visit http://localhost:3000 to view the application.

## Next Steps
- Implement advanced trading strategies
- Add more comprehensive error handling and logging
- Enhance the dashboard with charts and graphs
- Implement user settings and preferences
- Add support for multiple portfolios per user

## Phase 5 Updates

### Backend
- Implemented real-time stock price updates using WebSockets
- Added performance calculation for portfolio holdings
- Integrated yfinance for fetching current stock prices
- Implemented background job scheduling for periodic updates

### Frontend
- Added real-time updates to the Portfolio page
- Implemented performance metrics display in the Portfolio
- Added toast notifications for better user feedback

## Running the Application

1. Start the backend:
   ```
   cd backend
   flask run
   ```

2. Start the frontend:
   ```
   cd frontend
   npm start
   ```

Visit http://localhost:3000 to view the application.

## Next Steps
- Implement advanced trading strategies
- Add more comprehensive error handling and logging
- Enhance the dashboard with charts and graphs
- Implement user settings and preferences
- Add support for multiple portfolios per user

## Phase 5 Updates

### Backend
- Implemented real-time stock price updates using WebSockets
- Added performance calculation for portfolio holdings
- Integrated yfinance for fetching current stock prices
- Implemented background job scheduling for periodic updates

### Frontend
- Added real-time updates to the Portfolio page
- Implemented performance metrics display in the Portfolio
- Added toast notifications for better user feedback

## Running the Application

1. Start the backend:
   ```
   cd backend
   flask run
   ```

2. Start the frontend:
   ```
   cd frontend
   npm start
   ```

Visit http://localhost:3000 to view the application.

## Next Steps
- Implement advanced trading strategies
- Add more comprehensive error handling and logging
- Enhance the dashboard with charts and graphs
- Implement user settings and preferences
- Add support for multiple portfolios per user

## Phase 5 Updates

### Backend
- Implemented real-time stock price updates using WebSockets
- Added performance calculation for portfolio holdings
- Integrated yfinance for fetching current stock prices
- Implemented background job scheduling for periodic updates

### Frontend
- Added real-time updates to the Portfolio page
- Implemented performance metrics display in the Portfolio
- Added toast notifications for better user feedback

## Running the Application

1. Start the backend:
   ```
   cd backend
   flask run
   ```

2. Start the frontend:
   ```
   cd frontend
   npm start --force
   ```

Visit http://localhost:3000 to view the application.

## Next Steps
- Implement advanced trading strategies
- Add more comprehensive error handling and logging
- Enhance the dashboard with charts and graphs
- Implement user settings and preferences
- Add support for multiple portfolios per user

## Phase 6 Updates

### Backend
- Implemented advanced trading strategies (Moving Average Crossover and RSI)
- Added stock analysis endpoint
- Implemented Loki logging for better error tracking

### Frontend
- Added StockAnalysis component for visualizing trading signals
- Enhanced Dashboard with stock analysis feature

## Running the Application

1. Start the backend:
   ```
   cd backend
   flask run
   ```

2. Start the frontend:
   ```
   cd frontend
   npm start
   ```

3. (Optional) Set up Loki for logging:
   - Install and run Grafana Loki
   - Configure the LokiLogger in `backend/app/utils/logger.py` with your Loki server URL

Visit http://localhost:3000 to view the application.

## Next Steps
- Implement backtesting for trading strategies
- Add more advanced charting options
- Implement user notifications for trading signals
- Enhance error handling and add more comprehensive logging
- Add support for multiple portfolios per user

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
Add the following to your `.env` file:
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
Add the following to your `.env` file:
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

## Phase 8 Updates

### Docker Integration
- Added Dockerfiles for both backend and frontend
- Created docker-compose.yml for easy local deployment
- Integrated Loki and Grafana for logging and monitoring

### Testing
- Added basic pytest setup for backend testing
- Included React Testing Library for frontend testing

## Running the Application with Docker

1. Build and start the containers:
   ```
   docker-compose up --build
   ```

2. Access the application:
   - Frontend: http://localhost:3000
   - Backend API: http://localhost:5000
   - Grafana: http://localhost:3000 (for log visualization)

## Running Tests

### Backend Tests
```
cd backend
pytest
```

### Frontend Tests
```
cd frontend
npm test
```

## Next Steps
- Expand test coverage for both backend and frontend
- Set up CI/CD pipeline for automated testing and deployment
- Implement end-to-end testing with tools like Cypress
- Optimize Docker images for production deployment
- Enhance logging and monitoring capabilities

## Phase 8 Updates

### Docker Integration
- Added Dockerfiles for both backend and frontend
- Created docker-compose.yml for easy local deployment
- Integrated Loki and Grafana for logging and monitoring

### Testing
- Added basic pytest setup for backend testing
- Included React Testing Library for frontend testing

## Running the Application with Docker

1. Build and start the containers:
   ```
   docker-compose up --build
   ```

2. Access the application:
   - Frontend: http://localhost:3000
   - Backend API: http://localhost:5000
   - Grafana: http://localhost:3000 (for log visualization)

## Running Tests

### Backend Tests
```
cd backend
pytest
```

### Frontend Tests
```
cd frontend
npm test
```

## Next Steps
- Expand test coverage for both backend and frontend
- Set up CI/CD pipeline for automated testing and deployment
- Implement end-to-end testing with tools like Cypress
- Optimize Docker images for production deployment
- Enhance logging and monitoring capabilities

## Phase 8 Updates

### Docker Integration
- Added Dockerfiles for both backend and frontend
- Created docker-compose.yml for easy local deployment
- Integrated Loki and Grafana for logging and monitoring

### Testing
- Added basic pytest setup for backend testing
- Included React Testing Library for frontend testing

## Running the Application with Docker

1. Build and start the containers:
   ```
   docker-compose up --build
   ```

2. Access the application:
   - Frontend: http://localhost:3000
   - Backend API: http://localhost:5000
   - Grafana: http://localhost:3000 (for log visualization)

## Running Tests

### Backend Tests
```
cd backend
pytest
```

### Frontend Tests
```
cd frontend
npm test
```

## Next Steps
- Expand test coverage for both backend and frontend
- Set up CI/CD pipeline for automated testing and deployment
- Implement end-to-end testing with tools like Cypress
- Optimize Docker images for production deployment
- Enhance logging and monitoring capabilities

## Phase 8 Updates

### Docker Integration
- Added Dockerfiles for both backend and frontend
- Created docker-compose.yml for easy local deployment
- Integrated Loki and Grafana for logging and monitoring

### Testing
- Added basic pytest setup for backend testing
- Included React Testing Library for frontend testing

## Running the Application with Docker

1. Build and start the containers:
   ```
   docker-compose up --build
   ```

2. Access the application:
   - Frontend: http://localhost:3000
   - Backend API: http://localhost:5000
   - Grafana: http://localhost:3000 (for log visualization)

## Running Tests

### Backend Tests
```
cd backend
pytest
```

### Frontend Tests
```
cd frontend
npm test
```

## Next Steps
- Expand test coverage for both backend and frontend
- Set up CI/CD pipeline for automated testing and deployment
- Implement end-to-end testing with tools like Cypress
- Optimize Docker images for production deployment
- Enhance logging and monitoring capabilities


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

# Add these commands to the end of your script
echo "To start the services in the background, run:"
echo "bash -c 'source setup_phase8.sh && start_services'"
echo
echo "To check the status of the services, run:"
echo "bash -c 'source setup_phase8.sh && check_status'"
echo
echo "To stop the services, run:"
echo "bash -c 'source setup_phase8.sh && stop_services'"

# Update README with new information
cat >> README.md << EOL

## Running the Application with Docker in Background

1. Start the services in detached mode:
   ```
   bash -c 'source setup_phase8.sh && start_services'
   ```

2. Check the status of the services:
   ```
   bash -c 'source setup_phase8.sh && check_status'
   ```

3. Stop the services when done:
   ```
   bash -c 'source setup_phase8.sh && stop_services'
   ```

4. Access the application:
   - Frontend: http://localhost:3000
   - Backend API: http://localhost:5001
   - Grafana: http://localhost:3001 (for log visualization)

## Running Tests

### Backend Tests
```
cd backend
pytest
```

### Frontend Tests
```
cd frontend
npm test
```

## Next Steps
- Expand test coverage for both backend and frontend
- Set up CI/CD pipeline for automated testing and deployment
- Implement end-to-end testing with tools like Cypress
- Optimize Docker images for production deployment
- Enhance logging and monitoring capabilities


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

# Add these commands to the end of your script
echo "To start the services in the background, run:"
echo "bash -c 'source setup_phase8.sh && start_services'"
echo
echo "To check the status of the services, run:"
echo "bash -c 'source setup_phase8.sh && check_status'"
echo
echo "To stop the services, run:"
echo "bash -c 'source setup_phase8.sh && stop_services'"

# Update README with new information
cat >> README.md << EOL

## Running the Application with Docker in Background

1. Start the services in detached mode:
   ```
   bash -c 'source setup_phase8.sh && start_services'
   ```

2. Check the status of the services:
   ```
   bash -c 'source setup_phase8.sh && check_status'
   ```

3. Stop the services when done:
   ```
   bash -c 'source setup_phase8.sh && stop_services'
   ```

4. Access the application:
   - Frontend: http://localhost:3000
   - Backend API: http://localhost:5001
   - Grafana: http://localhost:3001 (for log visualization)

## Running Tests

### Backend Tests
```
cd backend
pytest
```

### Frontend Tests
```
cd frontend
npm test
```

## Next Steps
- Expand test coverage for both backend and frontend
- Set up CI/CD pipeline for automated testing and deployment
- Implement end-to-end testing with tools like Cypress
- Optimize Docker images for production deployment
- Enhance logging and monitoring capabilities

# Update README with new information
cat >> README.md << EOL

## Running the Application with Docker in Background

1. Start the services in detached mode:
   ```
   bash -c 'source setup_phase8.sh && start_services'
   ```

2. Check the status of the services:
   ```
   bash -c 'source setup_phase8.sh && check_status'
   ```

3. Stop the services when done:
   ```
   bash -c 'source setup_phase8.sh && stop_services'
   ```

4. Access the application:
   - Frontend: http://localhost:3000
   - Backend API: http://localhost:5001
   - Grafana: http://localhost:3001 (for log visualization)

## Running Tests

### Backend Tests
```
cd backend
pytest
```

### Frontend Tests
```
cd frontend
npm test
```

## Next Steps
- Expand test coverage for both backend and frontend
- Set up CI/CD pipeline for automated testing and deployment
- Implement end-to-end testing with tools like Cypress
- Optimize Docker images for production deployment
- Enhance logging and monitoring capabilities

# Update README with new information
cat >> README.md << EOL

## Running the Application with Docker in Background

1. Start the services in detached mode:
   ```
   bash -c 'source setup_phase8.sh && start_services'
   ```

2. Check the status of the services:
   ```
   bash -c 'source setup_phase8.sh && check_status'
   ```

3. Stop the services when done:
   ```
   bash -c 'source setup_phase8.sh && stop_services'
   ```

4. Access the application:
   - Frontend: http://localhost:3000
   - Backend API: http://localhost:5001
   - Grafana: http://localhost:3001 (for log visualization)

## Running Tests

### Backend Tests
```
cd backend
pytest
```

### Frontend Tests
```
cd frontend
npm test
```

## Next Steps
- Expand test coverage for both backend and frontend
- Set up CI/CD pipeline for automated testing and deployment
- Implement end-to-end testing with tools like Cypress
- Optimize Docker images for production deployment
- Enhance logging and monitoring capabilities

## Running the Application with Docker

1. Start the services in detached mode:
   ```
   bash -c 'source setup_phase8.sh && start_services'
   ```

2. Access the application:
   - Frontend: http://localhost:3000
   - Backend API: http://localhost:5001
   - Grafana: http://localhost:3001 (for log visualization)

3. Check the status of the services:
   ```
   bash -c 'source setup_phase8.sh && check_status'
   ```

4. Stop the services when done:
   ```
   bash -c 'source setup_phase8.sh && stop_services'
   ```

Note: The frontend is served by Nginx on port 80 inside the container, which is mapped to port 3000 on your host machine.

# Update README with new information
cat >> README.md << EOL

## Running the Application with Docker in Background

1. Start the services in detached mode:
   ```
   bash -c 'source setup_phase8.sh && start_services'
   ```

2. Check the status of the services:
   ```
   bash -c 'source setup_phase8.sh && check_status'
   ```

3. Stop the services when done:
   ```
   bash -c 'source setup_phase8.sh && stop_services'
   ```

4. Access the application:
   - Frontend: http://localhost:3000
   - Backend API: http://localhost:5001
   - Grafana: http://localhost:3001 (for log visualization)

## Running Tests

### Backend Tests
```
cd backend
pytest
```

### Frontend Tests
```
cd frontend
npm test
```

## Next Steps
- Expand test coverage for both backend and frontend
- Set up CI/CD pipeline for automated testing and deployment
- Implement end-to-end testing with tools like Cypress
- Optimize Docker images for production deployment
- Enhance logging and monitoring capabilities

## Running the Application with Docker

1. Start the services in detached mode:
   ```
   bash -c 'source setup_phase8.sh && start_services'
   ```

2. Access the application:
   - Frontend: http://localhost:3000
   - Backend API: http://localhost:5001
   - Grafana: http://localhost:3001 (for log visualization)

3. Check the status of the services:
   ```
   bash -c 'source setup_phase8.sh && check_status'
   ```

4. Stop the services when done:
   ```
   bash -c 'source setup_phase8.sh && stop_services'
   ```

Note: The frontend is served by Nginx on port 80 inside the container, which is mapped to port 3000 on your host machine.

# Update README with new information
cat >> README.md << EOL

## Running the Application with Docker in Background

1. Start the services in detached mode:
   ```
   bash -c 'source setup_phase8.sh && start_services'
   ```

2. Check the status of the services:
   ```
   bash -c 'source setup_phase8.sh && check_status'
   ```

3. Stop the services when done:
   ```
   bash -c 'source setup_phase8.sh && stop_services'
   ```

4. Access the application:
   - Frontend: http://localhost:3000
   - Backend API: http://localhost:5001
   - Grafana: http://localhost:3001 (for log visualization)

## Running Tests

### Backend Tests
```
cd backend
pytest
```

### Frontend Tests
```
cd frontend
npm test
```

## Next Steps
- Expand test coverage for both backend and frontend
- Set up CI/CD pipeline for automated testing and deployment
- Implement end-to-end testing with tools like Cypress
- Optimize Docker images for production deployment
- Enhance logging and monitoring capabilities

## Running the Application with Docker

1. Start the services in detached mode:
   ```
   bash -c 'source setup_phase8.sh && start_services'
   ```

2. Access the application:
   - Frontend: http://localhost:3000
   - Backend API: http://localhost:5001
   - Grafana: http://localhost:3001 (for log visualization)

3. Check the status of the services:
   ```
   bash -c 'source setup_phase8.sh && check_status'
   ```

4. Stop the services when done:
   ```
   bash -c 'source setup_phase8.sh && stop_services'
   ```

Note: The frontend is served by Nginx on port 80 inside the container, which is mapped to port 3000 on your host machine.

# Update README with new information
cat >> README.md << EOL

## Running the Application with Docker in Background

1. Start the services in detached mode:
   ```
   bash -c 'source setup_phase8.sh && start_services'
   ```

2. Check the status of the services:
   ```
   bash -c 'source setup_phase8.sh && check_status'
   ```

3. Stop the services when done:
   ```
   bash -c 'source setup_phase8.sh && stop_services'
   ```

4. Access the application:
   - Frontend: http://localhost:3000
   - Backend API: http://localhost:5001
   - Grafana: http://localhost:3001 (for log visualization)

## Running Tests

### Backend Tests
```
cd backend
pytest
```

### Frontend Tests
```
cd frontend
npm test
```

## Next Steps
- Expand test coverage for both backend and frontend
- Set up CI/CD pipeline for automated testing and deployment
- Implement end-to-end testing with tools like Cypress
- Optimize Docker images for production deployment
- Enhance logging and monitoring capabilities

## Running the Application with Docker

1. Start the services in detached mode:
   ```
   bash -c 'source setup_phase8.sh && start_services'
   ```

2. Access the application:
   - Frontend: http://localhost:3000
   - Backend API: http://localhost:5001
   - Grafana: http://localhost:3001 (for log visualization)

3. Check the status of the services:
   ```
   bash -c 'source setup_phase8.sh && check_status'
   ```

4. Stop the services when done:
   ```
   bash -c 'source setup_phase8.sh && stop_services'
   ```

Note: The frontend is served by Nginx on port 80 inside the container, which is mapped to port 3000 on your host machine.

# Update README with new information
cat >> README.md << EOL

## Running the Application with Docker in Background

1. Start the services in detached mode:
   ```
   bash -c 'source setup_phase8.sh && start_services'
   ```

2. Check the status of the services:
   ```
   bash -c 'source setup_phase8.sh && check_status'
   ```

3. Stop the services when done:
   ```
   bash -c 'source setup_phase8.sh && stop_services'
   ```

4. Access the application:
   - Frontend: http://localhost:3000
   - Backend API: http://localhost:5001
   - Grafana: http://localhost:3001 (for log visualization)

## Running Tests

### Backend Tests
```
cd backend
pytest
```

### Frontend Tests
```
cd frontend
npm test
```

## Next Steps
- Expand test coverage for both backend and frontend
- Set up CI/CD pipeline for automated testing and deployment
- Implement end-to-end testing with tools like Cypress
- Optimize Docker images for production deployment
- Enhance logging and monitoring capabilities

## Running the Application with Docker

1. Start the services in detached mode:
   ```
   bash -c 'source setup_phase8.sh && start_services'
   ```

2. Access the application:
   - Frontend: http://localhost:3000
   - Backend API: http://localhost:5001
   - Grafana: http://localhost:3001 (for log visualization)

3. Check the status of the services:
   ```
   bash -c 'source setup_phase8.sh && check_status'
   ```

4. Stop the services when done:
   ```
   bash -c 'source setup_phase8.sh && stop_services'
   ```

Note: The frontend is served by Nginx on port 80 inside the container, which is mapped to port 3000 on your host machine.

# Update README with new information
cat >> README.md << EOL

## Running the Application with Docker in Background

1. Start the services in detached mode:
   ```
   bash -c 'source setup_phase8.sh && start_services'
   ```

2. Check the status of the services:
   ```
   bash -c 'source setup_phase8.sh && check_status'
   ```

3. Stop the services when done:
   ```
   bash -c 'source setup_phase8.sh && stop_services'
   ```

4. Access the application:
   - Frontend: http://localhost:3000
   - Backend API: http://localhost:5001
   - Grafana: http://localhost:3001 (for log visualization)

## Running Tests

### Backend Tests
```
cd backend
pytest
```

### Frontend Tests
```
cd frontend
npm test
```

## Next Steps
- Expand test coverage for both backend and frontend
- Set up CI/CD pipeline for automated testing and deployment
- Implement end-to-end testing with tools like Cypress
- Optimize Docker images for production deployment
- Enhance logging and monitoring capabilities

## Running the Application with Docker

1. Start the services in detached mode:
   ```
   bash -c 'source setup_phase8.sh && start_services'
   ```

2. Access the application:
   - Frontend: http://localhost:3000
   - Backend API: http://localhost:5001
   - Grafana: http://localhost:3001 (for log visualization)

3. Check the status of the services:
   ```
   bash -c 'source setup_phase8.sh && check_status'
   ```

4. Stop the services when done:
   ```
   bash -c 'source setup_phase8.sh && stop_services'
   ```

Note: The frontend is served by Nginx on port 80 inside the container, which is mapped to port 3000 on your host machine.
