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

def test_gate_by_id(client):
    """Test the /api endpoint with a complex JSON response."""
    response = client.get('/gates/SOL')

    # Check if the response is not empty
    assert response.data, "Response is empty"

    # Check if the response is in JSON format
    assert response.is_json, "Response is not JSON"

    # Get the response JSON
    json_data = response.get_json()

    # Check if the connections key exists and is a list
    assert 'connections' in json_data, "'connections' key is missing"
    assert isinstance(json_data['connections'], list), "'connections' is not a list"

    for connection in json_data['connections']:
        # Check if 'destination_id' exists and is a string
        assert 'destination_id' in connection, "Connection missing 'destination_id'"
        assert isinstance(connection['destination_id'], str), "Connection 'destination_id' is not a string"
            
        # Check if 'distance' exists and is an integer
        assert 'distance' in connection, "Connection missing 'distance'"
        assert isinstance(connection['distance'], int), "Connection 'distance' is not an integer"
    
    # Check if 'id' and 'name' exist and are strings
    assert 'id' in json_data, "Gate missing 'id'"
    assert isinstance(json_data['id'], str), "Gate 'id' is not a string"
    assert 'name' in json_data, "Gate missing 'name'"
    assert isinstance(json_data['name'], str), "Gate 'name' is not a string"
    
