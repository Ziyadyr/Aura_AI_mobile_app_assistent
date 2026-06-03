from fastapi import APIRouter

from app.api.v1.endpoints import tasks, auth, ai, calendar, notes, meetings, emails, reminders

api_router = APIRouter()

api_router.include_router(auth.router, prefix="/auth", tags=["Authentication"])
api_router.include_router(tasks.router, prefix="/tasks", tags=["Tasks"])
api_router.include_router(calendar.router, prefix="/calendar", tags=["Calendar"])
api_router.include_router(notes.router, prefix="/notes", tags=["Notes"])
api_router.include_router(meetings.router, prefix="/meetings", tags=["Meetings"])
api_router.include_router(emails.router, prefix="/emails", tags=["Emails"])
api_router.include_router(reminders.router, prefix="/reminders", tags=["Reminders"])
api_router.include_router(ai.router, prefix="/ai", tags=["AI Assistant"])