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

def test_gates(client):
    """Test the /api endpoint with a complex JSON response."""
    response = client.get('/gates')

    # Check if the response is not empty
    assert response.data, "Response is empty"

    # Check if the response is in JSON format
    assert response.is_json, "Response is not JSON"

    # Get the response JSON
    json_data = response.get_json()

    # Check if the top-level key 'gates' exists and is a list
    assert 'gates' in json_data, "'gates' key is missing"
    assert isinstance(json_data['gates'], list), "'gates' is not a list"

    # Check if each gate has the correct structure
    for gate in json_data['gates']:
        # Check if 'id' and 'name' exist and are strings
        assert 'id' in gate, "Gate missing 'id'"
        assert isinstance(gate['id'], str), "Gate 'id' is not a string"
        assert 'name' in gate, "Gate missing 'name'"
        assert isinstance(gate['name'], str), "Gate 'name' is not a string"

        # Check if 'connections' exists and is a list
        assert 'connections' in gate, "Gate missing 'connections'"
        assert isinstance(gate['connections'], list), "Gate 'connections' is not a list"

        # Check if each connection has the correct structure
        for connection in gate['connections']:
            # Check if 'destination_id' exists and is a string
            assert 'destination_id' in connection, "Connection missing 'destination_id'"
            assert isinstance(connection['destination_id'], str), "Connection 'destination_id' is not a string"
            
            # Check if 'distance' exists and is an integer
            assert 'distance' in connection, "Connection missing 'distance'"
            assert isinstance(connection['distance'], int), "Connection 'distance' is not an integer"
