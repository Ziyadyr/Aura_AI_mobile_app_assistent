from sqlalchemy import Column, String, Text, DateTime, Boolean, ForeignKey, ARRAY
from sqlalchemy.sql import func
from sqlalchemy.dialects.postgresql import JSONB
from app.db.database import Base
import uuid


class Note(Base):
    __tablename__ = "notes"
    
    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    user_id = Column(String, ForeignKey("users.id"), nullable=False, index=True)
    title = Column(String, nullable=False)
    content = Column(Text, nullable=False)
    
    # Properties
    type = Column(String, default="plain")  # plain, rich_text, voice
    tags = Column(ARRAY(String), default=[])
    category = Column(String, default="general")
    is_favorite = Column(Boolean, default=False)
    
    # AI Features
    ai_summary = Column(Text, nullable=True)
    extracted_tasks = Column(ARRAY(String), default=[])
    extracted_events = Column(ARRAY(String), default=[])
    extracted_deadlines = Column(ARRAY(DateTime), default=[])
    is_ai_generated = Column(Boolean, default=False)
    
    # Timestamps
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())