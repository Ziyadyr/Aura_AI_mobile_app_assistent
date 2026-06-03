from sqlalchemy import Column, String, Text, DateTime, Boolean, ForeignKey, Float
from sqlalchemy.sql import func
from app.db.database import Base
import uuid


class Reminder(Base):
    __tablename__ = "reminders"
    
    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    user_id = Column(String, ForeignKey("users.id"), nullable=False, index=True)
    title = Column(String, nullable=False)
    description = Column(Text, nullable=True)
    
    # Trigger
    trigger_type = Column(String, default="time")  # time, location
    due_date = Column(DateTime(timezone=True), nullable=True)
    
    # Location (for geofencing)
    location_name = Column(String, nullable=True)
    latitude = Column(Float, nullable=True)
    longitude = Column(Float, nullable=True)
    
    # Recurrence
    is_recurring = Column(Boolean, default=False)
    recurrence_rule = Column(String, nullable=True)  # RRULE format
    
    # Properties
    priority = Column(String, default="medium")
    is_active = Column(Boolean, default=True)
    
    # Completion
    completed_at = Column(DateTime(timezone=True), nullable=True)
    
    # Timestamps
    created_at = Column(DateTime(timezone=True), server_default=func.now())