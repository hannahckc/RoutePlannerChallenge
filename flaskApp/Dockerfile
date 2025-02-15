# Use an official Python 3.11 runtime as a parent image
FROM python:3.11-slim

# Set the working directory in the container
WORKDIR /app

RUN ls

# Install the PostgreSQL client (psql)
RUN apt-get update && \
    apt-get install -y postgresql-client && \
    rm -rf /var/lib/apt/lists/*

# Copy the current directory contents into the container at /app
COPY . /app

COPY sql/create-local-postgres-db.sql /app/

# Define build-time arguments
ARG DB_HOST
ARG DB_USERNAME
ARG DB_PASSWORD
ARG DB_PORT
ARG DB_NAME

# Set environment variables from build-time arguments
ENV DB_HOST=$DB_HOST
ENV DB_USERNAME=$DB_USERNAME
ENV PGPASSWORD=$DB_PASSWORD
ENV DB_PORT=$DB_PORT
ENV DB_NAME=$DB_NAME

RUN echo "DB_HOST: $DB_HOST"
RUN echo "DB_USERNAME: $DB_USERNAME"
RUN echo "PGPASSWORD: $PGPASSWORD"
RUN echo "DB_PORT: $DB_PORT"
RUN echo "DB_NAME: $DB_NAME"

# Install any dependencies specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

RUN psql -h $DB_HOST -U $DB_USERNAME -d $DB_NAME -f /app/create-local-postgres-db.sql

# Expose port 80 for the Flask app
EXPOSE 80

# Define environment variable
ENV FLASK_APP=app.py

# Run the Flask app when the container starts
CMD ["flask", "run", "--host=0.0.0.0"]
