import React from 'react';
import { render, screen } from '@testing-library/react';
import App from './App';

test('renders login page when not authenticated', () => {
  render(<App />);
  const loginElement = screen.getByText(/Login/i);
  expect(loginElement).toBeInTheDocument();
});
