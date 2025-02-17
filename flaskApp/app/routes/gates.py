from flask import Blueprint
from app.utils.get_all_gates import get_gates
from flask import Blueprint, jsonify, request, Flask
from app.models import Gate, GateConnection
from flasgger import Swagger, swag_from

app = Flask(__name__)
swagger = Swagger(app)
gates_bp = Blueprint('gates', __name__)

@gates_bp.route('/gates', methods=['GET'])
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