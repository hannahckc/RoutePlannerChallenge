from app.models import Gate, GateConnection

# Returns a JSON object for a single gate, given the gate ID
def get_single_gate_data(gate_id):

    gate = Gate.query.get(gate_id)
    all_connections = GateConnection.query.filter(GateConnection.gate_start_id == gate_id).all()

    single_gate_data = {}
    single_gate_data.update({
        'id': gate.id,
        'name': gate.name
    })

    for connection in all_connections:
        single_gate_data.setdefault('connections', []).append({
            'destination_id' : connection.gate_end_id,
            'distance' : connection.distance
        })

    return single_gate_data