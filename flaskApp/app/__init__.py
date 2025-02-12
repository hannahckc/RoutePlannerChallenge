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
    app.config.from_object('app.config.Config')

    # Initialize components
    db.init_app(app)
    migrate.init_app(app, db)

    Swagger(app)

     # Import and register the Blueprint
    from .routes import bp  # Import the Blueprint
    app.register_blueprint(bp)

    return app
