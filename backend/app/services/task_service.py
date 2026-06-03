from sqlalchemy.orm import Session
from typing import List, Optional
from app.models.task import Task
from app.schemas.task import TaskCreate, TaskUpdate
import uuid
from datetime import datetime


class TaskService:
    """Service layer for Task operations following Repository Pattern."""
    
    def __init__(self, db: Session):
        self.db = db
    
    def get_tasks(
        self,
        user_id: Optional[str] = None,
        status: Optional[str] = None,
        priority: Optional[str] = None,
        category: Optional[str] = None,
        skip: int = 0,
        limit: int = 20,
    ) -> List[Task]:
        """Get tasks with optional filtering."""
        query = self.db.query(Task)
        
        if user_id:
            query = query.filter(Task.user_id == user_id)
        if status:
            query = query.filter(Task.status == status)
        if priority:
            query = query.filter(Task.priority == priority)
        if category:
            query = query.filter(Task.category == category)
        
        return query.order_by(Task.created_at.desc()).offset(skip).limit(limit).all()
    
    def get_task(self, task_id: str) -> Optional[Task]:
        """Get a specific task by ID."""
        return self.db.query(Task).filter(Task.id == task_id).first()
    
    def create_task(self, task_data: TaskCreate, user_id: str = "default") -> Task:
        """Create a new task."""
        db_task = Task(
            id=str(uuid.uuid4()),
            user_id=user_id,
            title=task_data.title,
            description=task_data.description,
            priority=task_data.priority,
            category=task_data.category,
            status=task_data.status,
            tags=task_data.tags,
            due_date=task_data.due_date,
            created_at=datetime.utcnow(),
        )
        self.db.add(db_task)
        self.db.commit()
        self.db.refresh(db_task)
        return db_task
    
    def update_task(self, task_id: str, task_update: TaskUpdate) -> Optional[Task]:
        """Update an existing task."""
        task = self.get_task(task_id)
        if not task:
            return None
        
        update_data = task_update.dict(exclude_unset=True)
        for field, value in update_data.items():
            setattr(task, field, value)
        
        task.updated_at = datetime.utcnow()
        self.db.commit()
        self.db.refresh(task)
        return task
    
    def delete_task(self, task_id: str) -> bool:
        """Delete a task."""
        task = self.get_task(task_id)
        if not task:
            return False
        
        self.db.delete(task)
        self.db.commit()
        return True
    
    def complete_task(self, task_id: str) -> Optional[Task]:
        """Mark a task as completed."""
        task = self.get_task(task_id)
        if not task:
            return None
        
        task.status = "completed"
        task.completed_at = datetime.utcnow()
        self.db.commit()
        self.db.refresh(task)
        return task
    
    def get_task_stats(self, user_id: str) -> dict:
        """Get task statistics for a user."""
        total = self.db.query(Task).filter(Task.user_id == user_id).count()
        completed = self.db.query(Task).filter(
            Task.user_id == user_id,
            Task.status == "completed"
        ).count()
        pending = self.db.query(Task).filter(
            Task.user_id == user_id,
            Task.status == "pending"
        ).count()
        in_progress = self.db.query(Task).filter(
            Task.user_id == user_id,
            Task.status == "in_progress"
        ).count()
        
        return {
            "total": total,
            "completed": completed,
            "pending": pending,
            "in_progress": in_progress,
            "completion_rate": round(completed / total * 100, 1) if total > 0 else 0,
        }