from flask import Blueprint
from app.utils.get_all_gates import get_gates
from app.utils.find_paths import find_all_paths
from flask import Blueprint, jsonify, request, Flask
from app.models import Gate, GateConnection
from flasgger import Swagger, swag_from

app = Flask(__name__)
swagger = Swagger(app)
cheapest_route_bp = Blueprint('cheapest_route', __name__)

# Calculates cost using both types of vehicles and find the cheapest one. Retur cheapest cost and vehicle type
@cheapest_route_bp.route('/gates/<gateCode>/to/<targetGateCode>')
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
