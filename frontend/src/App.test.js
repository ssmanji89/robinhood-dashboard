import React from 'react';
import { render, screen } from '@testing-library/react';
import App from './App';

test('renders Robinhood Dashboard header', () => {
  render(<App />);
  const headerElement = screen.getByText(/Robinhood Dashboard/i);
  expect(headerElement).toBeInTheDocument();
});
