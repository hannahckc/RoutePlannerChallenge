from flask import Blueprint
from app.utils.get_gate import get_single_gate_data
from flask import Blueprint, jsonify, request, Flask
from app.models import Gate, GateConnection
from flasgger import Swagger, swag_from

app = Flask(__name__)
swagger = Swagger(app)
gate_by_id_bp = Blueprint('gatebyid', __name__)

@gate_by_id_bp.route('/gates/<gateCode>', methods=['GET'])
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