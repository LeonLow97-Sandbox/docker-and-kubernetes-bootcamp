FROM ubuntu:18.04

RUN apt-get update
RUN apt-get install -y python2.7
RUN alias python=python2.7
RUN apt-get install -y python-pip
RUN alias pip=pip2
RUN pip install flask

COPY app.py /opt/app.py

ENTRYPOINT FLASK_APP=/opt/app.py flask run --host=0.0.0.0