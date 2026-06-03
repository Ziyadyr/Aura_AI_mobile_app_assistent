from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from typing import List, Optional

from app.db.database import get_db
from app.schemas.task import TaskCreate, TaskUpdate, TaskResponse
from app.services.task_service import TaskService

router = APIRouter(prefix="/tasks", tags=["Tasks"])


@router.get("", response_model=List[TaskResponse])
async def list_tasks(
    status: Optional[str] = Query(None, description="Filter by status"),
    priority: Optional[str] = Query(None, description="Filter by priority"),
    category: Optional[str] = Query(None, description="Filter by category"),
    skip: int = Query(0, ge=0),
    limit: int = Query(20, ge=1, le=100),
    db: Session = Depends(get_db),
):
    """List all tasks with optional filtering."""
    service = TaskService(db)
    return service.get_tasks(
        status=status,
        priority=priority,
        category=category,
        skip=skip,
        limit=limit,
    )


@router.post("", response_model=TaskResponse, status_code=201)
async def create_task(task: TaskCreate, db: Session = Depends(get_db)):
    """Create a new task."""
    service = TaskService(db)
    return service.create_task(task)


@router.get("/{task_id}", response_model=TaskResponse)
async def get_task(task_id: str, db: Session = Depends(get_db)):
    """Get a specific task by ID."""
    service = TaskService(db)
    task = service.get_task(task_id)
    if not task:
        raise HTTPException(status_code=404, detail="Task not found")
    return task


@router.put("/{task_id}", response_model=TaskResponse)
async def update_task(task_id: str, task_update: TaskUpdate, db: Session = Depends(get_db)):
    """Update a task."""
    service = TaskService(db)
    task = service.update_task(task_id, task_update)
    if not task:
        raise HTTPException(status_code=404, detail="Task not found")
    return task


@router.delete("/{task_id}", status_code=204)
async def delete_task(task_id: str, db: Session = Depends(get_db)):
    """Delete a task."""
    service = TaskService(db)
    success = service.delete_task(task_id)
    if not success:
        raise HTTPException(status_code=404, detail="Task not found")
    return None


@router.post("/{task_id}/complete", response_model=TaskResponse)
async def complete_task(task_id: str, db: Session = Depends(get_db)):
    """Mark a task as completed."""
    service = TaskService(db)
    task = service.complete_task(task_id)
    if not task:
        raise HTTPException(status_code=404, detail="Task not found")
    return task