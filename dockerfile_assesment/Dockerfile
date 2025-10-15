# George Davis
# Made for the Higher Ground Practical Assesment
# Referenced https://hub.docker.com/_/python 
# and https://docs.docker.com/get-started/docker-concepts/building-images/writing-a-dockerfile/


# General purpose python base image
FROM python:3.13
# Location of the working directory
WORKDIR /usr/local/app
# Bring in application dependencies
COPY requirements.txt ./
# Execute application dependencies
RUN pip install --no-cache-dir -r requirements.txt
# Copy in the source code
COPY src ./src
# Expose a port to host the app locally
EXPOSE 8080

# Set the command to execute the Docker Container
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8080"]