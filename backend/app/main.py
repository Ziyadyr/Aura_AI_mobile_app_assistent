from fastapi import FastAPI, Depends, HTTPException, status
from fastapi.middleware.cors import CORSMiddleware
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from contextlib import asynccontextmanager

from app.api.v1.router import api_router
from app.core.config import settings
from app.db.database import engine, Base

# Create tables
Base.metadata.create_all(bind=engine)

security = HTTPBearer()

@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup
    print("🚀 AURA API starting up...")
    yield
    # Shutdown
    print("👋 AURA API shutting down...")

app = FastAPI(
    title="AURA AI Executive Assistant API",
    description="Production-ready API for AURA - AI Executive Assistant",
    version="1.0.0",
    lifespan=lifespan,
)

# CORS Middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include API router
app.include_router(api_router, prefix="/api/v1")

@app.get("/")
async def root():
    return {
        "name": "AURA API",
        "version": "1.0.0",
        "status": "operational",
        "docs": "/docs",
    }

@app.get("/health")
async def health_check():
    return {"status": "healthy", "service": "aura-api"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)