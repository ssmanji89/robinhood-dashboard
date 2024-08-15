import axios from 'axios';
import io from 'socket.io-client';

const API_URL = 'http://localhost:5001/api';
const SOCKET_URL = 'http://localhost:5001';

const api = axios.create({
  baseURL: API_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

api.interceptors.request.use((config) => {
  const token = localStorage.getItem('token');
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

export const socket = io(SOCKET_URL);

export const login = (credentials) => api.post('/auth/login', credentials);
export const register = (userData) => api.post('/auth/register', userData);
export const executeTradeAPI = (tradeData) => api.post('/trading/execute', tradeData);
export const getTradeHistoryAPI = () => api.get('/trading/history');
export const getHoldingsAPI = () => api.get('/portfolio/holdings');
export const getPerformanceAPI = () => api.get('/portfolio/performance');
export const analyzeStockAPI = (symbol, strategy) => api.post('/trading/analyze', { symbol, strategy });
export const getNotificationSettingsAPI = () => api.get('/notifications/settings');
export const updateNotificationSettingsAPI = (settings) => api.post('/notifications/settings', settings);

export default api;
