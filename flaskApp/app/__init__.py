from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
from flasgger import Swagger


# Initialize the database and migration components
db = SQLAlchemy()
migrate = Migrate()
swagger = Swagger()


def create_app():
    app = Flask(__name__)
    
    # Load configuration
    app.config.from_object('config.Config')

    # Initialize components
    db.init_app(app)
    migrate.init_app(app, db)

    Swagger(app)

    from app.routes.cheapest_route import cheapest_route_bp
    from app.routes.cheapest_vehicle import cheapest_vehicle_bp
    from app.routes.gate_by_id import gate_by_id_bp
    from app.routes.gates import gates_bp

    app.register_blueprint(gates_bp)
    app.register_blueprint(gate_by_id_bp)
    app.register_blueprint(cheapest_route_bp)
    app.register_blueprint(cheapest_vehicle_bp)

    return app
