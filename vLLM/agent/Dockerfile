FROM public.ecr.aws/docker/library/python:3.11-slim

WORKDIR /app

COPY pyproject.toml .
RUN pip install --no-cache-dir -e .

COPY app/ ./app/

# -m treat it as module so app folder path is included
CMD ["python", "-u", "-m", "app.main"]