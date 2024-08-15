const API_URL = 'http://localhost:5000/api';

export const executeTradeAPI = async (tradeData) => {
  const response = await fetch(`${API_URL}/trading/execute`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(tradeData),
  });
  return response.json();
};

export const getTradeHistoryAPI = async (userId) => {
  const response = await fetch(`${API_URL}/trading/history?user_id=${userId}`);
  return response.json();
};
