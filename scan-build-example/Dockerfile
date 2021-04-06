# Debian10 image
FROM gcr.io/google-appengine/debian10:latest

# Ensures that the built image is always unique
RUN apt-get update && apt-get -y install uuid-runtime && uuidgen > /IAMUNIQUE

