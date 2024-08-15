import React, { useState } from 'react';

const Trading = () => {
  const [symbol, setSymbol] = useState('');
  const [quantity, setQuantity] = useState('');
  const [tradeType, setTradeType] = useState('buy');

  const handleTrade = (e) => {
    e.preventDefault();
    // TODO: Implement trade execution
    console.log('Trade:', { symbol, quantity, tradeType });
  };

  return (
    <div>
      <h2>Trading</h2>
      <form onSubmit={handleTrade}>
        <input
          type="text"
          value={symbol}
          onChange={(e) => setSymbol(e.target.value)}
          placeholder="Symbol"
          required
        />
        <input
          type="number"
          value={quantity}
          onChange={(e) => setQuantity(e.target.value)}
          placeholder="Quantity"
          required
        />
        <select value={tradeType} onChange={(e) => setTradeType(e.target.value)}>
          <option value="buy">Buy</option>
          <option value="sell">Sell</option>
        </select>
        <button type="submit">Execute Trade</button>
      </form>
    </div>
  );
};

export default Trading;
