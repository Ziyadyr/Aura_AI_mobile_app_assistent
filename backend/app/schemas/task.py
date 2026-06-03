from pydantic import BaseModel
from typing import Optional, List
from datetime import datetime


class TaskBase(BaseModel):
    title: str
    description: Optional[str] = None
    priority: str = "medium"
    category: str = "general"
    status: str = "pending"
    tags: Optional[List[str]] = []
    due_date: Optional[datetime] = None


class TaskCreate(TaskBase):
    pass


class TaskUpdate(BaseModel):
    title: Optional[str] = None
    description: Optional[str] = None
    priority: Optional[str] = None
    category: Optional[str] = None
    status: Optional[str] = None
    tags: Optional[List[str]] = None
    due_date: Optional[datetime] = None


class TaskResponse(TaskBase):
    id: str
    user_id: str
    completed_at: Optional[datetime] = None
    ai_suggestion: Optional[str] = None
    is_ai_generated: bool = False
    created_at: datetime
    updated_at: Optional[datetime] = None

    class Config:
        from_attributes = True