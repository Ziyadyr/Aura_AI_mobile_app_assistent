from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List, Optional

from app.db.database import get_db

router = APIRouter()

@router.get("")
async def list_notes(
    search: Optional[str] = None,
    category: Optional[str] = None,
    db: Session = Depends(get_db),
):
    """List all notes with optional filtering."""
    pass

@router.post("")
async def create_note(db: Session = Depends(get_db)):
    """Create a new note."""
    pass

@router.get("/{note_id}")
async def get_note(note_id: str, db: Session = Depends(get_db)):
    """Get a specific note."""
    pass

@router.put("/{note_id}")
async def update_note(note_id: str, db: Session = Depends(get_db)):
    """Update a note."""
    pass

@router.delete("/{note_id}")
async def delete_note(note_id: str, db: Session = Depends(get_db)):
    """Delete a note."""
    pass

@router.post("/{note_id}/summarize")
async def summarize_note(note_id: str, db: Session = Depends(get_db)):
    """Generate AI summary for a note."""
    pass

@router.post("/{note_id}/extract")
async def extract_from_note(note_id: str, db: Session = Depends(get_db)):
    """Extract tasks and events from a note."""
    pass