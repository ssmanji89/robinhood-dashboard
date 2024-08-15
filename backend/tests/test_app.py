import pytest
from app import create_app

@pytest.fixture
def client():
    app = create_app()
    app.config['TESTING'] = True
    with app.test_client() as client:
        yield client

def test_health_check(client):
    response = client.get('/api/health')
    assert response.status_code == 200
    assert response.json == {'status': 'healthy'}

def test_login_required(client):
    response = client.get('/api/portfolio/holdings')
    assert response.status_code == 401  # Unauthorized
