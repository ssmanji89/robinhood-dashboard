import React, { useState } from 'react';
import { Line } from 'react-chartjs-2';
import { Chart as ChartJS, CategoryScale, LinearScale, PointElement, LineElement, Title, Tooltip, Legend } from 'chart.js';
import { analyzeStockAPI } from '../services/api';

ChartJS.register(CategoryScale, LinearScale, PointElement, LineElement, Title, Tooltip, Legend);

const StockAnalysis = () => {
  const [symbol, setSymbol] = useState('');
  const [strategy, setStrategy] = useState('moving_average');
  const [analysisResult, setAnalysisResult] = useState(null);

  const handleAnalyze = async () => {
    try {
      const result = await analyzeStockAPI(symbol, strategy);
      setAnalysisResult(result);
    } catch (error) {
      console.error('Failed to analyze stock:', error);
    }
  };

  return (
    <div>
      <h2>Stock Analysis</h2>
      <input
        type="text"
        value={symbol}
        onChange={(e) => setSymbol(e.target.value)}
        placeholder="Stock Symbol"
      />
      <select value={strategy} onChange={(e) => setStrategy(e.target.value)}>
        <option value="moving_average">Moving Average Crossover</option>
        <option value="rsi">RSI</option>
      </select>
      <button onClick={handleAnalyze}>Analyze</button>
      
      {analysisResult && (
        <div>
          <h3>Analysis Result for {analysisResult.symbol}</h3>
          <p>Latest Signal: {analysisResult.latest_signal}</p>
          <p>Latest Position: {analysisResult.latest_position}</p>
        </div>
      )}
    </div>
  );
};

export default StockAnalysis;
