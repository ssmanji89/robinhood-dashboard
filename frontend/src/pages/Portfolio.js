import React, { useState, useEffect } from 'react';
import { getHoldingsAPI, getPerformanceAPI, socket } from '../services/api';
import { toast } from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';

const Portfolio = () => {
  const [holdings, setHoldings] = useState({});
  const [performance, setPerformance] = useState({});

  useEffect(() => {
    const fetchHoldings = async () => {
      try {
        const response = await getHoldingsAPI();
        setHoldings(response.data);
      } catch (error) {
        console.error('Failed to fetch holdings:', error);
        toast.error('Failed to fetch holdings');
      }
    };

    const fetchPerformance = async () => {
      try {
        const response = await getPerformanceAPI();
        setPerformance(response.data);
      } catch (error) {
        console.error('Failed to fetch performance:', error);
        toast.error('Failed to fetch performance data');
      }
    };

    fetchHoldings();
    fetchPerformance();

    socket.on('stock_update', (data) => {
      setHoldings((prevHoldings) => {
        const updatedHoldings = { ...prevHoldings };
        Object.keys(data).forEach((symbol) => {
          if (updatedHoldings[symbol]) {
            updatedHoldings[symbol].currentPrice = data[symbol];
          }
        });
        return updatedHoldings;
      });
    });

    return () => {
      socket.off('stock_update');
    };
  }, []);

  return (
    <div>
      <h2>Portfolio</h2>
      <table>
        <thead>
          <tr>
            <th>Symbol</th>
            <th>Quantity</th>
            <th>Current Price</th>
            <th>Current Value</th>
            <th>Cost Basis</th>
            <th>Profit/Loss</th>
            <th>Profit/Loss %</th>
          </tr>
        </thead>
        <tbody>
          {Object.entries(performance).map(([symbol, data]) => (
            <tr key={symbol}>
              <td>{symbol}</td>
              <td>{data.quantity}</td>
              <td>${(holdings[symbol]?.currentPrice || 0).toFixed(2)}</td>
              <td>${data.current_value.toFixed(2)}</td>
              <td>${data.cost_basis.toFixed(2)}</td>
              <td>${data.profit_loss.toFixed(2)}</td>
              <td>{data.profit_loss_percent.toFixed(2)}%</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
};

export default Portfolio;
