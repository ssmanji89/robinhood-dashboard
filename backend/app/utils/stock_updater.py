import yfinance as yf
from flask_socketio import emit

def update_stock_prices(symbols):
    from .. import socketio  # Import here to avoid circular dependency
    data = yf.download(symbols, period="1d")
    latest_prices = data['Close'].iloc[-1].to_dict()
    socketio.emit('stock_update', latest_prices)

def schedule_stock_updates(symbols, interval=60):
    from .. import scheduler  # Import here to avoid circular dependency
    scheduler.add_job(
        update_stock_prices,
        'interval',
        seconds=interval,
        args=[symbols]
    )