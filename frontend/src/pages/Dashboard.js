import React from 'react';
import Header from '../components/Header';
import Portfolio from '../components/Portfolio';
import StockAnalysis from '../components/StockAnalysis';

const Dashboard = () => (
  <div>
    <Header />
    <h2>Dashboard</h2>
    <Portfolio />
    <StockAnalysis />
  </div>
);

export default Dashboard;
