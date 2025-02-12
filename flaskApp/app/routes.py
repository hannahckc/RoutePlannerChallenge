from flask import Blueprint, jsonify, request, Flask
from .models import Gate, GateConnection
from flasgger import Swagger, swag_from


bp = Blueprint('main', __name__)
app = Flask(__name__)
swagger = Swagger(app)

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

# Returns a list of JSON objects with id, name and connections for each gate in the database
def get_gates():
    all_gates = Gate.query.all()    
    gates_data = []

    for gate in all_gates:
        single_gate_data = get_single_gate_data(gate.id)
        gates_data.append(single_gate_data)

    return gates_data

# Returns the cost of a journey if using a personal vehcile
def calc_cost_with_personal_vehicle(distance, passengers, days_parking):
    journey_cost = 0
    journey_cost_per_person = 0

    full_vehicles, extra_passengers = divmod(passengers, 4) # Can hold max 4 passengers

    if extra_passengers == 0:
        no_vehicles = full_vehicles
    else:
        no_vehicles = full_vehicles + 1

    journey_cost += no_vehicles*days_parking*5 # Parking costs £5 per day
    journey_cost += no_vehicles*distance*0.3 # Travel costs £0.3 per AU
    journey_cost_per_person = journey_cost / passengers # Find cost per passenger

    return journey_cost_per_person

# Returns cost of a journey if using HSTC vehicle
def calc_cost_with_hstc_transport(distance, passengers):
    journey_cost = 0
    journey_cost_per_person = 0

    full_vehicles, extra_passengers = divmod(passengers, 5) # Can hold max 5 passengers
    
    if extra_passengers == 0:
        no_vehicles = full_vehicles
    else:
        no_vehicles = full_vehicles + 1

    journey_cost += no_vehicles*distance*0.45 # Travel costs £0.45 per AU 
    journey_cost_per_person = journey_cost / passengers # Return cost per passenger

    return journey_cost_per_person

# Given start and end position, find all possible routes from start to end, return list of JSON objects
def find_all_paths(graph, start, end, path=None, path_distance=0):
    if path is None:
        path = {'route': [], 'route_distance': 0} 

    path['route'] = path['route'] + [start]

    if start == end:
        return [path]
    if start not in graph:
        return []
    paths = []

    for connection in graph[start]:  # Iterate over connections (which are dicts)
        connection_distance = graph[start][connection]

        if connection not in path['route']:  # Avoid cycles
            new_path = {'route': path['route'], 'route_distance': path['route_distance'] + connection_distance}
            paths.extend(find_all_paths(graph, connection, end, new_path))

    return paths

@bp.route('/gates', methods=['GET'])
def display_gates():
    """Display gates
        ---
        responses:
          200:
            description: A list of JSON objects representing hyperspace gates
            schema:
              type: object
              properties:
                gates:
                    type: array
                    items:
                        type: object
                        properties:
                            id:
                                type: string
                            name:
                                type: string
                            connections:
                                type: array
                                items:
                                    type: object
                                    properties:
                                        destination_id:
                                            type: string
                                        distance:
                                            type: integer   

                   
    """
    gates_data = get_gates()
    return jsonify({'gates': gates_data})


@bp.route('/gates/<gateCode>', methods=['GET'])
def get_gate_by_id(gateCode):
    """Display specific gate
        ---
        parameters:
          - name: gateCode
            in: path
            type: string
            required: true
            description: The ID of the gate of info to retrieve
        responses:
          404:
            description: Gate not found
          200:
            description: A gate JSON object
            schema:
                type: object
                properties:
                    id:
                        type: string
                    name:
                        type: string
                    connections:
                        type: array
                        items:
                            type: object
                            properties:
                                destination_id:
                                    type: string
                                distance:
                                    type: integer   
    """
    gate_data = get_single_gate_data(gateCode)
    return jsonify(gate_data)  

# Returns the cheapest vehicle to use and the cost of the journey for the given distance (in AUs), number of passengers and days parking 
@bp.route('/transport/<distance>', methods=['GET'])
def get_cheapest_route(distance):
    """Find cheapest vehicle to travel
        ---
        parameters:
          - name: distance
            in: path
            type: integer
            required: true
            description: The distance in AUs required to travel
          - name: passengers
            in: query
            type: integer
            required: true
            description: The number of passengers required to travel
          - name: parking
            in: query
            type: integer
            required: true
            description: The number of days parking required for journey
        responses:
          200:
            description: Cheapest vehicle and cost per passenger
            schema:
                type: object
                properties:
                    cheapest_cost_per_person: 
                        type: number
                        format: float
                    cheapest_vehicle:
                        type: string

"""
    passengers = request.args.get('passengers', default=1, type=int)
    parking_days = request.args.get('parking', default=0, type=int)
    results={}

    distance = float(distance)

    cost_with_personal_transport = calc_cost_with_personal_vehicle(distance,passengers,parking_days)
    cost_with_hstc_transport = calc_cost_with_hstc_transport(distance,passengers)

    if cost_with_personal_transport < cost_with_hstc_transport:
        results.update({
            'cheapest_vehicle': 'personal_transport',
            'chapest_cost_per_person' : round(cost_with_personal_transport,2)
        })
    elif cost_with_hstc_transport < cost_with_personal_transport:
        results.update({
            'cheapest_vehicle': 'hstc_transport',
            'chapest_cost_per_person' : round(cost_with_hstc_transport,2)
        })
    else:
        results.update({
            'cheapest_vehicle': 'either!',
            'chapest_cost_per_person' : round(cost_with_personal_transport,2)
        })

    return jsonify(results)

# Calculates cost using both types of vehicles and find the cheapest one. Retur cheapest cost and vehicle type
@bp.route('/gates/<gateCode>/to/<targetGateCode>')
def get_cheapest_route_between_gates(gateCode, targetGateCode):
    """Find cheapest route from start to target gate
        ---
        parameters:
          - name: gateCode
            in: path
            type: string
            required: true
            description: The id of the starting gate
          - name: targetGateCode
            in: path
            type: string
            required: true
            description: The id of the target gate
        responses:
          200:
            description: Cheapest route and total cost
            schema:
                type: object
                properties:
                    cheapest_route: 
                        type: array
                        items:
                            type: string
                    cost:
                        type: number
                        format: float
                    distanct:
                        type: integer

"""
    all_gates = get_gates()
    graph = {}

    for gate in all_gates:
        graph[gate["id"]] = {conn["destination_id"]: conn["distance"] for conn in gate["connections"]}

    routes = find_all_paths(graph, gateCode, targetGateCode)

    min_distance = 0
    min_index=-1
    for index,route in enumerate(routes):
        if route['route_distance'] < min_distance or min_distance == 0:
                min_distance = route['route_distance']
                min_index = index
                min_cost = round(min_distance*0.1, 2)

    results={'cheapest_route':routes[min_index]['route'], 'distance': min_distance, 'cost': min_cost}

    return(jsonify(results))
