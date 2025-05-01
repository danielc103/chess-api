# Chess API Example

![Flask](https://img.shields.io/badge/flask-%23000.svg?style=for-the-badge&logo=flask&logoColor=white)

[![forthebadge](https://forthebadge.com/images/badges/60-percent-of-the-time-works-every-time.svg)](https://forthebadge.com)

This is a small example API for a chess game written in Python using Flask.

## Setup

Create virtual environment and install dependencies with:

```bash
    python3 -m venv venv
    source venv/bin/activate
    pip install -r requirements.txt
```

## Run the server

Run the server with flask:

```bash
   export FLASK_APP=chess.py
    flask run --host=0.0.0.0
```

## Build the server image

Build a Docker image for the server using:

```bash
   docker build -t chess-api .
```

and run the image with:

```bash
  docker run --rm -it -p 5000:5000 --name chess-api chess-api
```

## API endpoints

The following endpoints are available on `http://localhost:5000`:

- `/board`: returns the current board state as a JSON objec
- `/move`: moves a piece from one position to another. Requires a JSON object with two keys, `'from'` and `'to'`.
- `/remove` removes a piece at a given position. Requires a JSON object with the key `'position'` specifying where to remove the piece.

