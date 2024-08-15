import pandas as pd
import numpy as np

class RSIStrategy:
    def __init__(self, period=14, overbought=70, oversold=30):
        self.period = period
        self.overbought = overbought
        self.oversold = oversold

    def generate_signals(self, data):
        delta = data['Close'].diff()
        gain = (delta.where(delta > 0, 0)).rolling(window=self.period).mean()
        loss = (-delta.where(delta < 0, 0)).rolling(window=self.period).mean()
        
        rs = gain / loss
        rsi = 100 - (100 / (1 + rs))
        
        signals = pd.DataFrame(index=data.index)
        signals['rsi'] = rsi
        signals['signal'] = 0.0
        signals['signal'] = np.where(signals['rsi'] < self.oversold, 1.0, 0.0)
        signals['signal'] = np.where(signals['rsi'] > self.overbought, -1.0, signals['signal'])
        signals['positions'] = signals['signal'].diff()
        
        return signals
