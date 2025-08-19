########## base with uv ##########
FROM python:3.11-slim-bookworm AS base
WORKDIR /app
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# install uv (single static binary)
RUN apt-get update -y && apt-get install -y --no-install-recommends curl ca-certificates \
    && rm -rf /var/lib/apt/lists/* \
    && curl -LsSf https://astral.sh/uv/install.sh | sh \
    && /root/.local/bin/uv --version

ENV PATH="/root/.local/bin:${PATH}"

########## builder: resolve & sync deps ##########
FROM base AS builder
# copy only dependency manifests first for better layer caching
COPY pyproject.toml ./
# include lock file if it exists (recommended)
COPY uv.lock ./
# create in-project venv and install (no dev dependencies for runtime)
RUN uv venv && uv sync --frozen --no-dev

########## runtime ##########
FROM python:3.11-slim-bookworm AS runtime
WORKDIR /app
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PATH="/app/.venv/bin:${PATH}"

# copy the resolved venv and app src
COPY --from=builder /app/.venv /app/.venv
COPY src ./src

# run as non-root
RUN useradd -m -u 10001 appuser
USER appuser

EXPOSE 8000

ENTRYPOINT ["uvicorn", "src.main:app"]
CMD ["--host", "0.0.0.0", "--port", "8000"]
