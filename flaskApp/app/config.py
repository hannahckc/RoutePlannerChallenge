import os

class Config:
    DB_USER = os.getenv("DB_USER")
    DB_PASSWORD = os.getenv("DB_PASSWORD")
    DB_HOST = os.getenv("DB_HOST")

    SQLALCHEMY_DATABASE_URI = f"postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:5432/gatedb"
    #SQLALCHEMY_DATABASE_URI = f"postgresql://hannahcampbell@localhost:5432/gatedb"
    SQLALCHEMY_TRACK_MODIFICATIONS = False
