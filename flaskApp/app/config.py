import os

class Config:
    DB_USERNAME = os.getenv("DB_USERNAME")
    DB_PASSWORD = os.getenv("DB_PASSWORD")
    DB_HOST = os.getenv("DB_HOST")

    print(f"DB_USERNAME: {DB_USERNAME}")
    print(f"DB_PASSWORD: {DB_PASSWORD}")
    print(f"DB_HOST: {DB_HOST}")

    SQLALCHEMY_DATABASE_URI = f"postgresql://{DB_USERNAME}:{DB_PASSWORD}@{DB_HOST}:5432/gatedb"
    #SQLALCHEMY_DATABASE_URI = f"postgresql://hannahcampbell@localhost:5432/gatedb"
    SQLALCHEMY_TRACK_MODIFICATIONS = False
