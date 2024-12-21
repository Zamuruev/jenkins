FROM ubuntu:latest
LABEL authors="zamur"

ENTRYPOINT ["top", "-b"]