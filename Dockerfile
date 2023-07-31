FROM ubuntu:jammy

# Install dependencies
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y curl
