import pytest
from app import create_app

# Fixture to create the app for testing
@pytest.fixture
def app():
    app = create_app()
    yield app

# Fixture to provide a test client
@pytest.fixture
def client(app):
    return app.test_client()

def test_cheapest_vehicle(client):
    """Test the /transport endpoint with a JSON response."""
    response = client.get('/transport/300?passengers=7&parking=3')

    # Check if the response is not empty
    assert response.data, "Response is empty"

    # Check if the response is in JSON format
    assert response.is_json, "Response is not JSON"

    # Get the response JSON
    json_data = response.get_json()

    # Check if cheapest_cost_per_person key exists and is a float
    assert 'cheapest_cost_per_person' in json_data, "'cheapest_cost_per_person' key is missing"
    assert isinstance(json_data['cheapest_cost_per_person'], float), "'cheapest_cost_per_person' key is not a float"

    # Check if cheapest_vehicle key exists and is a string
    assert 'cheapest_vehicle' in json_data, "'cheapest_vehicle' key is missing"
    assert isinstance(json_data['cheapest_vehicle'], str), "'cheapest_vehicle' key is not a string"