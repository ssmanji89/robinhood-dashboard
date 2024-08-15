#!/bin/bash

# Set the project root directory
PROJECT_ROOT="/Users/sulemanmanji/Documents/GitHub/robinhood-dashboard"

# Create the project directory structure
mkdir -p "$PROJECT_ROOT"/{backend/{app/{routes,models,services,utils},tests},frontend/{public,src/{components,pages,services,utils}}}

# Navigate to the project root
cd "$PROJECT_ROOT"

# Initialize Git repository
git init

# Create backend files
cat > backend/app/__init__.py << EOL
from flask import Flask
from flask_cors import CORS

def create_app():
    app = Flask(__name__)
    CORS(app)

    @app.route('/api/health')
    def health_check():
        return {'status': 'healthy'}, 200

    return app

if __name__ == '__main__':
    app = create_app()
    app.run(debug=True)
EOL

cat > backend/requirements.txt << EOL
Flask
flask-cors
robin_stocks
pandas
numpy
EOL

# Create frontend files
cat > frontend/src/App.js << EOL
import React from 'react';

function App() {
  return (
    <div className="App">
      <h1>Robinhood Dashboard</h1>
    </div>
  );
}

export default App;
EOL

cat > frontend/package.json << EOL
{
  "name": "robinhood-dashboard-frontend",
  "version": "0.1.0",
  "private": true,
  "dependencies": {
    "react": "^17.0.2",
    "react-dom": "^17.0.2",
    "react-scripts": "4.0.3"
  },
  "scripts": {
    "start": "react-scripts start",
    "build": "react-scripts build",
    "test": "react-scripts test",
    "eject": "react-scripts eject"
  }
}
EOL

# Create README files
cat > README.md << EOL
# Robinhood Dashboard

This project is a programmatic trading system dashboard for Robinhood, developed using Python and React.js.

## Structure

- \`backend/\`: Python Flask backend
- \`frontend/\`: React.js frontend

## Setup

1. Set up the backend:
   \`\`\`
   cd backend
   python -m venv venv
   source venv/bin/activate
   pip install -r requirements.txt
   \`\`\`

2. Set up the frontend:
   \`\`\`
   cd frontend
   npm install
   \`\`\`

## Running the application

1. Backend:
   \`\`\`
   cd backend
   flask run
   \`\`\`

2. Frontend:
   \`\`\`
   cd frontend
   npm start
   \`\`\`
EOL

# Create .gitignore
cat > .gitignore << EOL
# Python
__pycache__/
*.py[cod]
venv/

# Node
node_modules/
npm-debug.log

# React build
frontend/build/

# Environment variables
.env

# macOS
.DS_Store

# VS Code
.vscode/
EOL

# Add all files to git
git add .

# Make initial commit
git commit -m "Initial project setup"

echo "Robinhood Dashboard project has been set up at $PROJECT_ROOT"