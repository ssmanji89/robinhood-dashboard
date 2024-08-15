import React from 'react';
import { Link } from 'react-router-dom';

const Navigation = () => (
  <nav>
    <ul>
      <li><Link to="/">Dashboard</Link></li>
      <li><Link to="/portfolio">Portfolio</Link></li>
      <li><Link to="/trading">Trading</Link></li>
    </ul>
  </nav>
);

export default Navigation;
