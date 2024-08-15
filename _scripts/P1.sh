# Frontend enhancements
mkdir -p frontend/src/{components,pages,services}

# Update package.json with correct versions
cat > frontend/package.json << EOL
{
  "name": "robinhood-dashboard-frontend",
  "version": "0.1.0",
  "private": true,
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-scripts": "5.0.1"
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
    "@testing-library/react": "^13.4.0",
    "@testing-library/jest-dom": "^5.16.5",
    "@testing-library/user-event": "^14.4.3"
  }
}
EOL

# Create basic components
cat > frontend/src/components/Header.js << EOL
import React from 'react';

const Header = () => (
  <header>
    <h1>Robinhood Dashboard</h1>
  </header>
);

export default Header;
EOL

cat > frontend/src/components/Portfolio.js << EOL
import React from 'react';

const Portfolio = () => (
  <div>
    <h2>Portfolio</h2>
    {/* TODO: Implement portfolio display */}
  </div>
);

export default Portfolio;
EOL

# Create pages
cat > frontend/src/pages/Dashboard.js << EOL
import React from 'react';
import Header from '../components/Header';
import Portfolio from '../components/Portfolio';

const Dashboard = () => (
  <div>
    <Header />
    <Portfolio />
  </div>
);

export default Dashboard;
EOL

# Update App.js
cat > frontend/src/App.js << EOL
import React from 'react';
import Dashboard from './pages/Dashboard';

function App() {
  return (
    <div className="App">
      <Dashboard />
    </div>
  );
}

export default App;
EOL

# Install dependencies
npm --prefix frontend install

# Create a basic test
cat > frontend/src/App.test.js << EOL
import React from 'react';
import { render, screen } from '@testing-library/react';
import App from './App';

test('renders Robinhood Dashboard header', () => {
  render(<App />);
  const headerElement = screen.getByText(/Robinhood Dashboard/i);
  expect(headerElement).toBeInTheDocument();
});
EOL