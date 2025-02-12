from . import db


# Define a Sample Model
class Gate(db.Model):
    __tablename__ = 'gate'
    id = db.Column(db.String, primary_key=True)
    name = db.Column(db.String, nullable=False)

class GateConnection(db.Model):
    __tablename__ = 'gate_connections'
    id = db.Column(db.Integer, primary_key=True)    
    gate_start_id = db.Column(db.String)
    gate_end_id = db.Column(db.String)
    distance = db.Column(db.Integer)