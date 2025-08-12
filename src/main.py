from fastapi import FastAPI, HTTPException
from dotenv import load_dotenv
import os
import httpx
import certifi

# Load environment variables
load_dotenv()

app = FastAPI(title="Visualiza API")

NASA_API_KEY = os.getenv("NASA_API_KEY")
APOD_URL = "https://api.nasa.gov/planetary/apod"

@app.get("/")
def root():
    return {"message": "Bem-vindo à Visualiza API!"}

@app.get("/health")
def health():
    return {"status": "ok"}

@app.get("/apod")
async def get_apod():
    if not NASA_API_KEY:
        raise HTTPException(status_code=500, detail="NASA_API_KEY not configured")

    params = {"api_key": NASA_API_KEY}
    try:
        async with httpx.AsyncClient(verify=certifi.where(), timeout=10.0) as client:
            response = await client.get(APOD_URL, params=params)
            if response.status_code != 200:
                raise HTTPException(status_code=response.status_code, detail=response.text)
            return response.json()

    except httpx.RequestError as e:
        raise HTTPException(status_code=500, detail=f"Request error: {str(e)}")
