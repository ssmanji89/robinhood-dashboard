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
