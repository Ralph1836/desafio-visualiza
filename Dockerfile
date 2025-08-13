########## Builder ##########
FROM python:3.9-slim-bullseye AS builder
WORKDIR /app

# Env for smaller, cleaner images
ENV PIP_NO_CACHE_DIR=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Create a self-contained virtualenv
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Copy only requirements first (better cache)
COPY requirements.txt .
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

########## Runtime ##########
FROM python:3.9-slim-bullseye
WORKDIR /app

# Same env in runtime
ENV PIP_NO_CACHE_DIR=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PATH="/opt/venv/bin:$PATH"

# Copy the venv from builder
COPY --from=builder /opt/venv /opt/venv

# Copy only app code (never copy .env)
COPY src ./src

# Security: run as non-root
RUN useradd -m -u 10001 appuser
USER appuser

EXPOSE 8000

# Fixed executable; default args are overridable
ENTRYPOINT ["/opt/venv/bin/uvicorn", "src.main:app"]
CMD ["--host", "0.0.0.0", "--port", "8000"]

# (Optional) Simple container-level healthcheck (adjust path/timeout if you like)
# HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
#   CMD wget -qO- http://127.0.0.1:8000/health || exit 1
