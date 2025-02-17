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

def test_cheapest_route(client):
    """Test the /gates/id/to/id endpoint with a JSON response."""
    response = client.get('/gates/SOL/to/VEG')

    # Check if the response is not empty
    assert response.data, "Response is empty"

    # Check if the response is in JSON format
    assert response.is_json, "Response is not JSON"

    # Get the response JSON
    json_data = response.get_json()

    # Check if cheapest_cost_per_person key exists and is a list
    assert 'cheapest_route' in json_data, "'cheapest_route' key is missing"
    assert isinstance(json_data['cheapest_route'], list), "'cheapest_route' key is not a list"

    # Check if cost key exists and is a float
    assert 'cost' in json_data, "'cost' key is missing"
    assert isinstance(json_data['cost'], float), "'cost' key is not a float"

    # Check if distance key exists and is a integer
    assert 'distance' in json_data, "'distance' key is missing"
    assert isinstance(json_data['distance'], int), "'distance' key is not a integer"