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
