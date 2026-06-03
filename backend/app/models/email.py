from sqlalchemy import Column, String, Text, DateTime, Boolean, ForeignKey, ARRAY
from sqlalchemy.sql import func
from app.db.database import Base
import uuid


class Email(Base):
    __tablename__ = "emails"
    
    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    user_id = Column(String, ForeignKey("users.id"), nullable=False, index=True)
    
    # Email Content
    subject = Column(String, nullable=False)
    sender = Column(String, nullable=False)
    sender_email = Column(String, nullable=False)
    body = Column(Text, nullable=True)
    body_html = Column(Text, nullable=True)
    
    # AI Summary
    summary = Column(Text, nullable=True)
    
    # Status
    is_read = Column(Boolean, default=False)
    is_starred = Column(Boolean, default=False)
    is_important = Column(Boolean, default=False)
    
    # Metadata
    labels = Column(ARRAY(String), default=[])
    attachments = Column(ARRAY(String), default=[])
    thread_id = Column(String, nullable=True, index=True)
    message_id = Column(String, nullable=True, unique=True)
    
    # Timestamps
    received_at = Column(DateTime(timezone=True), nullable=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())