from . import db

# Model to hold info on individual gate
class Gate(db.Model):
    __tablename__ = 'gate'
    id = db.Column(db.String, primary_key=True)
    name = db.Column(db.String, nullable=False)

# Model to hold info on connections between gates
class GateConnection(db.Model):
    __tablename__ = 'gate_connections'
    id = db.Column(db.Integer, primary_key=True)    
    gate_start_id = db.Column(db.String)
    gate_end_id = db.Column(db.String)
    distance = db.Column(db.Integer)