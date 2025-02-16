from flask import Blueprint
from app.utils.calc_costs import calc_cost_with_hstc_transport, calc_cost_with_personal_vehicle
from flask import Blueprint, jsonify, request, Flask
from app.models import Gate, GateConnection
from flasgger import Swagger, swag_from

app = Flask(__name__)
swagger = Swagger(app)
cheapest_vehicle_bp = Blueprint('cheapest_vehicle', __name__)

# Returns the cheapest vehicle to use and the cost of the journey for the given distance (in AUs), number of passengers and days parking 
@cheapest_vehicle_bp.route('/transport/<distance>', methods=['GET'])
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
            'cheapest_cost_per_person' : round(cost_with_personal_transport,2)
        })
    elif cost_with_hstc_transport < cost_with_personal_transport:
        results.update({
            'cheapest_vehicle': 'hstc_transport',
            'cheapest_cost_per_person' : round(cost_with_hstc_transport,2)
        })
    else:
        results.update({
            'cheapest_vehicle': 'either!',
            'cheapest_cost_per_person' : round(cost_with_personal_transport,2)
        })

    return jsonify(results)