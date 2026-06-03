"""
AURA Multi-Agent Orchestrator

Routes user requests to the appropriate specialized AI agent.
Implements the multi-agent architecture with an orchestrator pattern.
"""

from typing import Dict, Any, Optional
from enum import Enum

from app.services.ai_service import AIService


class AgentType(str, Enum):
    ORCHESTRATOR = "orchestrator"
    CALENDAR = "calendar"
    TASK = "task"
    EMAIL = "email"
    MEETING = "meeting"
    PLANNING = "planning"
    MEMORY = "memory"
    NOTIFICATION = "notification"


class AgentRouter:
    """Routes requests to the appropriate agent based on intent classification."""
    
    def __init__(self):
        self.ai_service = AIService()
    
    async def classify_intent(self, message: str) -> Dict[str, Any]:
        """Classify user intent and determine which agent should handle the request."""
        system_prompt = """You are the AURA Orchestrator Agent. Analyze the user's message and classify their intent.
        Return ONLY a JSON object with the following structure:
        {
            "primary_agent": "calendar|task|email|meeting|planning|memory|notification",
            "confidence": 0.0-1.0,
            "entities": {
                "dates": [],
                "times": [],
                "people": [],
                "topics": []
            },
            "action": "create|read|update|delete|summarize|suggest",
            "requires_confirmation": true|false
        }"""
        
        response = await self.ai_service.chat(
            messages=[{"role": "user", "content": message}],
            system_prompt=system_prompt,
        )
        
        import json
        try:
            return json.loads(response["content"])
        except:
            return {
                "primary_agent": "orchestrator",
                "confidence": 0.5,
                "entities": {},
                "action": "suggest",
                "requires_confirmation": True,
            }
    
    async def route(self, message: str, user_context: Optional[Dict] = None) -> Dict[str, Any]:
        """Route a user message to the appropriate agent."""
        classification = await self.classify_intent(message)
        
        agent_type = classification.get("primary_agent", "orchestrator")
        
        # Route to appropriate agent
        agent_map = {
            "calendar": CalendarAgent(),
            "task": TaskAgent(),
            "email": EmailAgent(),
            "meeting": MeetingAgent(),
            "planning": PlanningAgent(),
            "memory": MemoryAgent(),
            "notification": NotificationAgent(),
        }
        
        agent = agent_map.get(agent_type, OrchestratorAgent())
        
        result = await agent.process(message, user_context, classification)
        
        return {
            "agent": agent_type,
            "classification": classification,
            "result": result,
        }


class BaseAgent:
    """Base class for all AURA agents."""
    
    def __init__(self):
        self.ai_service = AIService()
    
    async def process(
        self,
        message: str,
        user_context: Optional[Dict] = None,
        classification: Optional[Dict] = None,
    ) -> Dict[str, Any]:
        raise NotImplementedError


class OrchestratorAgent(BaseAgent):
    """Default agent for general queries and routing."""
    
    async def process(self, message, user_context=None, classification=None):
        system_prompt = """You are AURA, a helpful AI executive assistant. Provide a helpful response to the user's query.
        You can help with scheduling, tasks, emails, meetings, and productivity planning."""
        
        response = await self.ai_service.chat(
            messages=[{"role": "user", "content": message}],
            system_prompt=system_prompt,
        )
        
        return {
            "response": response["content"],
            "suggested_actions": [
                {"label": "View Schedule", "action": "view_schedule"},
                {"label": "Manage Tasks", "action": "view_tasks"},
                {"label": "Check Emails", "action": "view_emails"},
            ],
        }


class CalendarAgent(BaseAgent):
    """Handles calendar-related requests."""
    
    async def process(self, message, user_context=None, classification=None):
        system_prompt = """You are the Calendar Agent for AURA. Help users manage their calendar events.
        Extract event details, suggest times, check conflicts, and create/modify events."""
        
        # Extract events from message
        events = await self.ai_service.extract_events(message)
        
        response = await self.ai_service.chat(
            messages=[{"role": "user", "content": message}],
            system_prompt=system_prompt,
        )
        
        return {
            "response": response["content"],
            "extracted_events": events,
            "suggested_actions": [
                {"label": "Create Event", "action": "create_event"},
                {"label": "View Calendar", "action": "view_calendar"},
                {"label": "Check Conflicts", "action": "check_conflicts"},
            ],
        }


class TaskAgent(BaseAgent):
    """Handles task management requests."""
    
    async def process(self, message, user_context=None, classification=None):
        system_prompt = """You are the Task Agent for AURA. Help users create, organize, and prioritize tasks.
        Extract action items, suggest priorities, and help with task breakdown."""
        
        # Extract action items
        action_items = await self.ai_service.extract_action_items(message)
        
        response = await self.ai_service.chat(
            messages=[{"role": "user", "content": message}],
            system_prompt=system_prompt,
        )
        
        return {
            "response": response["content"],
            "extracted_tasks": action_items,
            "suggested_actions": [
                {"label": "Create Tasks", "action": "create_tasks"},
                {"label": "View Tasks", "action": "view_tasks"},
                {"label": "Prioritize", "action": "prioritize"},
            ],
        }


class EmailAgent(BaseAgent):
    """Handles email-related requests."""
    
    async def process(self, message, user_context=None, classification=None):
        system_prompt = """You are the Email Agent for AURA. Help users manage emails, draft responses,
        summarize threads, and organize their inbox."""
        
        response = await self.ai_service.chat(
            messages=[{"role": "user", "content": message}],
            system_prompt=system_prompt,
        )
        
        return {
            "response": response["content"],
            "suggested_actions": [
                {"label": "Summarize Emails", "action": "summarize_emails"},
                {"label": "Draft Reply", "action": "draft_reply"},
                {"label": "View Inbox", "action": "view_inbox"},
            ],
        }


class MeetingAgent(BaseAgent):
    """Handles meeting-related requests including transcription and summarization."""
    
    async def process(self, message, user_context=None, classification=None):
        system_prompt = """You are the Meeting Agent for AURA. Help users with meeting transcription,
        summarization, action item extraction, and meeting insights."""
        
        response = await self.ai_service.chat(
            messages=[{"role": "user", "content": message}],
            system_prompt=system_prompt,
        )
        
        return {
            "response": response["content"],
            "suggested_actions": [
                {"label": "Start Recording", "action": "record_meeting"},
                {"label": "View Transcripts", "action": "view_transcripts"},
                {"label": "Meeting Insights", "action": "meeting_insights"},
            ],
        }


class PlanningAgent(BaseAgent):
    """Handles productivity planning and schedule optimization."""
    
    async def process(self, message, user_context=None, classification=None):
        system_prompt = """You are the Planning Agent for AURA. Create optimized schedules,
        balance workloads, and suggest productivity improvements."""
        
        response = await self.ai_service.chat(
            messages=[{"role": "user", "content": message}],
            system_prompt=system_prompt,
        )
        
        return {
            "response": response["content"],
            "suggested_actions": [
                {"label": "Generate Plan", "action": "generate_plan"},
                {"label": "Optimize Schedule", "action": "optimize"},
                {"label": "Focus Mode", "action": "focus_mode"},
            ],
        }


class MemoryAgent(BaseAgent):
    """Manages user preferences and long-term memory."""
    
    async def process(self, message, user_context=None, classification=None):
        system_prompt = """You are the Memory Agent for AURA. Remember user preferences,
        learn from interactions, and provide personalized experiences."""
        
        response = await self.ai_service.chat(
            messages=[{"role": "user", "content": message}],
            system_prompt=system_prompt,
        )
        
        return {
            "response": response["content"],
            "memory_update": {},
            "suggested_actions": [
                {"label": "View Preferences", "action": "view_preferences"},
                {"label": "Update Memory", "action": "update_memory"},
            ],
        }


class NotificationAgent(BaseAgent):
    """Handles reminders and notification management."""
    
    async def process(self, message, user_context=None, classification=None):
        system_prompt = """You are the Notification Agent for AURA. Manage reminders,
        smart notifications, and alert preferences."""
        
        response = await self.ai_service.chat(
            messages=[{"role": "user", "content": message}],
            system_prompt=system_prompt,
        )
        
        return {
            "response": response["content"],
            "suggested_actions": [
                {"label": "Set Reminder", "action": "set_reminder"},
                {"label": "View Reminders", "action": "view_reminders"},
                {"label": "Smart Alerts", "action": "smart_alerts"},
            ],
        }