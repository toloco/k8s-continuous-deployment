FROM python:3.7-slim

EXPOSE 8000

# Add Tini
ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

WORKDIR /code

#
# Install the application.
#
# Note: pull the pipenv dependencies first (lest frequently changed),
# so they get Docker-cached.
#
RUN pip install pipenv
COPY ./src/Pipfile ./src/Pipfile.lock /code/
RUN pipenv sync --dev

COPY ./src /code

#
# Setup and run the application.
#
ENV FLASK_APP=app.py
ENV FLASK_DEBUG=1
ENV GUNICORN_PROCESS=2

ENTRYPOINT ["/tini", "--"]
CMD ["/code/run.sh"]
