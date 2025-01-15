# Use Python 3.12 as the base image
FROM python:3.12-slim

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container
COPY . .

# Install the dependencies from requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Expose the application port (FastAPI default is 8000)
EXPOSE 8000

# Define the environment variable for FastAPI
ENV UVICORN_CMD="uvicorn app:app --host 0.0.0.0 --port 8000 --reload"

# Run the FastAPI application using Uvicorn
CMD ["sh", "-c", "$UVICORN_CMD"]
