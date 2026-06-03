from sqlalchemy import Column, String, Text, DateTime, Boolean, ForeignKey, ARRAY, Integer
from sqlalchemy.sql import func
from app.db.database import Base
import uuid


class CalendarEvent(Base):
    __tablename__ = "calendar_events"
    
    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    user_id = Column(String, ForeignKey("users.id"), nullable=False, index=True)
    title = Column(String, nullable=False)
    description = Column(Text, nullable=True)
    
    # Timing
    start_time = Column(DateTime(timezone=True), nullable=False)
    end_time = Column(DateTime(timezone=True), nullable=False)
    is_all_day = Column(Boolean, default=False)
    recurrence = Column(String, nullable=True)  # RRULE format
    
    # Details
    location = Column(String, nullable=True)
    category = Column(String, default="personal")
    attendees = Column(ARRAY(String), default=[])
    meeting_url = Column(String, nullable=True)
    
    # Reminders
    reminders_enabled = Column(Boolean, default=True)
    reminder_minutes = Column(ARRAY(Integer), default=[15])
    
    # AI
    is_ai_generated = Column(Boolean, default=False)
    source = Column(String, nullable=True)  # email, note, voice, manual
    
    # Availability
    availability = Column(String, default="busy")  # busy, free, tentative
    
    # Timestamps
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())