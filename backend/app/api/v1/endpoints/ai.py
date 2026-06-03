"""
AI Assistant API Endpoints
Handles chat, voice processing, summarization, and agent routing.
"""

from fastapi import APIRouter, UploadFile, File, Depends, HTTPException
from typing import Optional, List
import tempfile
import os

from app.services.ai_service import AIService
from app.agents.orchestrator import AgentRouter

router = APIRouter()
ai_service = AIService()
agent_router = AgentRouter()


@router.post("/chat")
async def chat(
    message: str,
    conversation_id: Optional[str] = None,
    context: Optional[dict] = None,
):
    """Send a message to the AI assistant and get a response."""
    try:
        # Route through multi-agent system
        result = await agent_router.route(message, context)
        
        return {
            "response": result["result"]["response"],
            "agent": result["agent"],
            "confidence": result["classification"]["confidence"],
            "suggested_actions": result["result"].get("suggested_actions", []),
            "extracted_data": {
                "events": result["result"].get("extracted_events", []),
                "tasks": result["result"].get("extracted_tasks", []),
            },
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("/voice")
async def process_voice(
    audio: UploadFile = File(...),
    context: Optional[dict] = None,
):
    """Process voice input and return transcription + AI response."""
    try:
        # Save uploaded audio file temporarily
        with tempfile.NamedTemporaryFile(delete=False, suffix=".m4a") as tmp:
            content = await audio.read()
            tmp.write(content)
            tmp_path = tmp.name
        
        # Transcribe with Whisper
        transcription = await ai_service.transcribe_audio(tmp_path)
        
        # Clean up temp file
        os.unlink(tmp_path)
        
        # Process transcribed text through agent router
        result = await agent_router.route(transcription, context)
        
        return {
            "transcription": transcription,
            "response": result["result"]["response"],
            "agent": result["agent"],
            "suggested_actions": result["result"].get("suggested_actions", []),
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("/summarize")
async def summarize_text(
    text: str,
    max_length: int = 200,
):
    """Generate a summary of the provided text."""
    try:
        summary = await ai_service.generate_summary(text, max_length)
        return {"summary": summary}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("/extract-action-items")
async def extract_action_items(text: str):
    """Extract action items from text."""
    try:
        items = await ai_service.extract_action_items(text)
        return {"action_items": items}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("/extract-events")
async def extract_events(text: str):
    """Extract calendar events from text."""
    try:
        events = await ai_service.extract_events(text)
        return {"events": events}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("/draft-email")
async def draft_email_reply(
    email_content: str,
    tone: str = "professional",
):
    """Draft an email reply."""
    try:
        draft = await ai_service.draft_email_reply(email_content, tone)
        return {"draft": draft}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("/daily-briefing")
async def generate_daily_briefing(context: dict):
    """Generate a personalized daily briefing."""
    try:
        briefing = await ai_service.generate_daily_briefing(context)
        return {"briefing": briefing}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("/productivity-plan")
async def generate_productivity_plan(
    tasks: List[dict],
    events: List[dict],
    preferences: Optional[dict] = None,
):
    """Generate an optimized productivity plan."""
    try:
        plan = await ai_service.generate_productivity_plan(tasks, events, preferences)
        return plan
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("/process-meeting")
async def process_meeting(
    meeting_id: str,
    transcript: str,
):
    """Process a meeting transcript to extract insights."""
    try:
        # Run multiple AI operations in parallel
        summary_task = ai_service.generate_summary(transcript)
        actions_task = ai_service.extract_action_items(transcript)
        events_task = ai_service.extract_events(transcript)
        
        summary = await summary_task
        action_items = await actions_task
        events = await events_task
        
        return {
            "meeting_id": meeting_id,
            "summary": summary,
            "action_items": action_items,
            "extracted_events": events,
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))