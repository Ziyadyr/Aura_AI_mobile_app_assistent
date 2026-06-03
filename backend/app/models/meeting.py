from sqlalchemy import Column, String, Text, DateTime, ForeignKey, ARRAY
from sqlalchemy.dialects.postgresql import JSONB
from sqlalchemy.sql import func
from app.db.database import Base
import uuid


class Meeting(Base):
    __tablename__ = "meetings"
    
    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    user_id = Column(String, ForeignKey("users.id"), nullable=False, index=True)
    title = Column(String, nullable=False)
    
    # Timing
    start_time = Column(DateTime(timezone=True), nullable=True)
    end_time = Column(DateTime(timezone=True), nullable=True)
    
    # Audio
    audio_url = Column(String, nullable=True)
    audio_duration_seconds = Column(String, nullable=True)
    
    # AI Processing
    transcript = Column(Text, nullable=True)
    summary = Column(Text, nullable=True)
    key_points = Column(ARRAY(String), default=[])
    action_items = Column(ARRAY(String), default=[])
    deadlines = Column(JSONB, default=[])
    
    # Metadata
    attendees = Column(ARRAY(String), default=[])
    status = Column(String, default="pending")  # pending, processing, completed, failed
    language = Column(String, default="en")
    
    # Timestamps
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())