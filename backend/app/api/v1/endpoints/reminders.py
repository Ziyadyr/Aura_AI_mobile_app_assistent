from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import Optional, List

from app.db.database import get_db

router = APIRouter()

@router.get("")
async def list_reminders(
    is_active: Optional[bool] = None,
    db: Session = Depends(get_db),
):
    """List all reminders with optional filtering."""
    pass

@router.post("")
async def create_reminder(db: Session = Depends(get_db)):
    """Create a new reminder."""
    pass

@router.get("/{reminder_id}")
async def get_reminder(reminder_id: str, db: Session = Depends(get_db)):
    """Get a specific reminder."""
    pass

@router.put("/{reminder_id}")
async def update_reminder(reminder_id: str, db: Session = Depends(get_db)):
    """Update a reminder."""
    pass

@router.delete("/{reminder_id}")
async def delete_reminder(reminder_id: str, db: Session = Depends(get_db)):
    """Delete a reminder."""
    pass

@router.post("/{reminder_id}/toggle")
async def toggle_reminder(reminder_id: str, db: Session = Depends(get_db)):
    """Toggle reminder active state."""
    pass