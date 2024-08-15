import React, { useState, useEffect } from 'react';
import { getHoldingsAPI } from '../services/api';

const Portfolio = () => {
  const [holdings, setHoldings] = useState({});

  useEffect(() => {
    const fetchHoldings = async () => {
      try {
        const response = await getHoldingsAPI();
        setHoldings(response.data);
      } catch (error) {
        console.error('Failed to fetch holdings:', error);
      }
    };
    fetchHoldings();
  }, []);

  return (
    <div>
      <h2>Portfolio</h2>
      <ul>
        {Object.entries(holdings).map(([symbol, quantity]) => (
          <li key={symbol}>{symbol}: {quantity}</li>
        ))}
      </ul>
    </div>
  );
};

export default Portfolio;
