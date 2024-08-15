# Robinhood Dashboard

This project is a programmatic trading system dashboard for Robinhood, developed using Python and React.js.

## Project Structure

- `backend/`: Python Flask backend
  - `auth/`: Authentication module
  - `portfolio/`: Portfolio management module
  - `trading/`: Trading execution module
- `frontend/`: React.js frontend
  - `components/`: Reusable React components
  - `pages/`: Main page components
  - `services/`: API and other services

## Setup and Installation

### Backend Setup
```
cd backend
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

### Frontend Setup
```
cd frontend
npm install
```

## Running the Application

### Without Docker

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

### With Docker

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

## Testing

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

## Environment Variables
Add the following to your `.env` file:
- MAIL_SERVER
- MAIL_PORT
- MAIL_USE_TLS
- MAIL_USERNAME
- MAIL_PASSWORD

## Security Note
Make sure to keep your .env file secure and never commit it to version control.

## Recent Updates

### Backend
- Implemented JWT authentication
- Added environment variable support
- Enhanced portfolio module with holdings and performance endpoints
- Implemented real-time stock price updates using WebSockets
- Added performance calculation for portfolio holdings
- Integrated yfinance for fetching current stock prices
- Implemented background job scheduling for periodic updates
- Implemented advanced trading strategies (Moving Average Crossover and RSI)
- Added stock analysis endpoint
- Implemented Loki logging for better error tracking
- Implemented notification system with email support
- Added user preferences for notifications
- Enhanced error handling and logging

### Frontend
- Added login functionality
- Implemented protected routes
- Updated Portfolio page to display holdings
- Added axios for API calls
- Added real-time updates to the Portfolio page
- Implemented performance metrics display in the Portfolio
- Added toast notifications for better user feedback
- Added StockAnalysis component for visualizing trading signals
- Enhanced Dashboard with stock analysis feature
- Added NotificationSettings component for managing user preferences
- Implemented toast notifications for better user feedback
- Enhanced error handling in API calls

### Docker Integration
- Added Dockerfiles for both backend and frontend
- Created docker-compose.yml for easy local deployment
- Integrated Loki and Grafana for logging and monitoring

### Testing
- Added basic pytest setup for backend testing
- Included React Testing Library for frontend testing

## Next Steps
- Expand test coverage for both backend and frontend
- Set up CI/CD pipeline for automated testing and deployment
- Implement end-to-end testing with tools like Cypress
- Optimize Docker images for production deployment
- Enhance logging and monitoring capabilities
- Implement push notifications
- Add more advanced user preferences
- Enhance security measures (e.g., rate limiting, additional authentication methods)
- Implement a dashboard for administrators
- Add more comprehensive analytics and reporting features
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
