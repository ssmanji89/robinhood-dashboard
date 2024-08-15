import React from 'react';
import { BrowserRouter as Router, Route, Switch } from 'react-router-dom';
import Navigation from './components/Navigation';
import Dashboard from './pages/Dashboard';
import Portfolio from './pages/Portfolio';
import Trading from './pages/Trading';

function App() {
  return (
    <Router>
      <div className="App">
        <Navigation />
        <Switch>
          <Route exact path="/" component={Dashboard} />
          <Route path="/portfolio" component={Portfolio} />
          <Route path="/trading" component={Trading} />
        </Switch>
      </div>
    </Router>
  );
}

export default App;
