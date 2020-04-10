#!/bin/sh
set -ue

# Run the application.
echo "-= Starting gUnicorn =-"
exec pipenv run gunicorn  -b 0.0.0.0:8000 \
    --workers=$GUNICORN_PROCESS \
    --timeout 90 \
    --limit-request-field_size 0  \
    --preload  \
    --max-requests=2000  \
    --log-file='-'  --access-logfile='-' --error-logfile='-' \
    app:app
