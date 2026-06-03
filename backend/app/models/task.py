from sqlalchemy import Column, String, Text, DateTime, ForeignKey, ARRAY
from sqlalchemy.sql import func
from app.db.database import Base
import uuid


class Task(Base):
    __tablename__ = "tasks"
    
    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    user_id = Column(String, ForeignKey("users.id"), nullable=False, index=True)
    title = Column(String, nullable=False)
    description = Column(Text, nullable=True)
    
    # Task Properties
    priority = Column(String, default="medium")  # low, medium, high, critical
    category = Column(String, default="general")
    status = Column(String, default="pending")  # pending, in_progress, completed, cancelled
    tags = Column(ARRAY(String), default=[])
    
    # Dates
    due_date = Column(DateTime(timezone=True), nullable=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())
    completed_at = Column(DateTime(timezone=True), nullable=True)
    
    # AI
    ai_suggestion = Column(Text, nullable=True)
    is_ai_generated = Column(String, default=False)