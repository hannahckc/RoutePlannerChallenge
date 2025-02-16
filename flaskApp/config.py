import os

class Config:
    DB_USERNAME = "postgres_user"
    DB_PASSWORD = "Yell0wHamsterTree!"
    DB_HOST = "gatus-default.cly04kmwqnew.eu-north-1.rds.amazonaws.com"

    print(f"DB_USERNAME: ${DB_USERNAME}")
    print(f"DB_PASSWORD: ${DB_PASSWORD}")
    print(f"DB_HOST: ${DB_HOST}")

    SQLALCHEMY_DATABASE_URI = f"postgresql://{DB_USERNAME}:{DB_PASSWORD}@{DB_HOST}:5432/gatedb"
    #SQLALCHEMY_DATABASE_URI = f"postgresql://hannahcampbell@localhost:5432/gatedb"
    SQLALCHEMY_TRACK_MODIFICATIONS = False
