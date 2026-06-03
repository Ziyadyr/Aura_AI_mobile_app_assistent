from sqlalchemy import Column, String, Boolean, DateTime, Text
from sqlalchemy.sql import func
from app.db.database import Base
import uuid


class User(Base):
    __tablename__ = "users"
    
    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    email = Column(String, unique=True, index=True, nullable=False)
    display_name = Column(String, nullable=True)
    photo_url = Column(String, nullable=True)
    phone_number = Column(String, nullable=True)
    
    # AI Preferences
    ai_action_mode = Column(String, default="confirmation")  # suggest, confirmation, trusted, autonomous
    ai_memory_enabled = Column(Boolean, default=True)
    
    # Settings
    theme = Column(String, default="light")
    notifications_enabled = Column(Boolean, default=True)
    locale = Column(String, default="en_US")
    timezone = Column(String, default="UTC")
    
    # Security
    password_hash = Column(String, nullable=True)
    firebase_uid = Column(String, nullable=True, index=True)
    google_id = Column(String, nullable=True, index=True)
    apple_id = Column(String, nullable=True, index=True)
    
    # Timestamps
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())
    last_login_at = Column(DateTime(timezone=True), nullable=True)
    
    # Status
    is_active = Column(Boolean, default=True)
    is_verified = Column(Boolean, default=False)