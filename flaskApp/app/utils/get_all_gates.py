from app.utils.get_gate import get_single_gate_data
from app.models import Gate

# Returns a list of JSON objects with id, name and connections for each gate in the database
def get_gates():
    all_gates = Gate.query.all()    
    gates_data = []

    for gate in all_gates:
        single_gate_data = get_single_gate_data(gate.id)
        gates_data.append(single_gate_data)

    return gates_data