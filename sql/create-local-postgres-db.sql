DROP TABLE gate;
DROP TABLE gate_connections;

CREATE TABLE gate (
    id VARCHAR(3) PRIMARY KEY,
    name VARCHAR(20)
);
INSERT INTO gate (id, name) VALUES
    ('SOL', 'Sol'),
    ('PRX', 'Proxima'),
    ('SIR', 'Sirius'),
    ('CAS', 'Castor'),
    ('PRO', 'Procyon'),
    ('DEN', 'Denebula'),
    ('RAN', 'Ran'),
    ('ARC', 'Arcturus'),
    ('FOM', 'Fomalhaut'),
    ('ALT', 'Altair'),
    ('VEG', 'Vega'),
    ('ALD', 'Aldermain'),
    ('ALS', 'Alshain');

CREATE TABLE gate_connections (
    id SERIAL PRIMARY KEY,
    gate_start_id VARCHAR(3),
    gate_end_id VARCHAR(3),
    distance INTEGER
);

INSERT INTO gate_connections (gate_start_id, gate_end_id, distance) VALUES
    ('SOL', 'RAN', 100),
    ('SOL', 'PRX', 90),
    ('SOL', 'SIR', 100),
    ('SOL', 'ARC', 200),
    ('SOL', 'ALD', 250),
    ('PRX', 'SOL', 90),
    ('PRX', 'SIR', 100),
    ('PRX', 'ALT', 150),
    ('SIR', 'SOL', 80),
    ('SIR', 'PRX', 10),
    ('SIR', 'CAS', 200),
    ('CAS', 'SIR', 200),
    ('CAS', 'PRO', 120),
    ('PRO', 'CAS', 80),
    ('DEN', 'PRO', 5),
    ('DEN', 'ARC', 2),
    ('DEN', 'FOM', 8),
    ('DEN', 'RAN', 100),
    ('DEN', 'ALD', 3),
    ('RAN', 'SOL', 100),
    ('ARC', 'SOL', 500),
    ('ARC', 'DEN', 120),
    ('FOM', 'PRX', 10),
    ('FOM', 'DEN', 20),
    ('FOM', 'ALS', 9),
    ('ALT', 'FOM', 140),
    ('ALT', 'VEG', 220),
    ('VEG', 'ARC', 220),
    ('VEG', 'ALD', 580),
    ('ALD', 'SOL', 200),
    ('ALD', 'ALS', 160),
    ('ALD', 'VEG', 320),
    ('ALS', 'ATL', 1),
    ('ALS', 'ALD', 1);