import os
from typing import List, Dict, Any, Optional
from openai import AsyncOpenAI
from app.core.config import settings


class AIService:
    """Core AI service for AURA - handles all LLM interactions."""
    
    def __init__(self):
        self.client = AsyncOpenAI(api_key=settings.OPENAI_API_KEY or os.getenv("OPENAI_API_KEY"))
        self.model = settings.OPENAI_MODEL
        self.max_tokens = settings.OPENAI_MAX_TOKENS
        self.temperature = settings.OPENAI_TEMPERATURE
    
    async def chat(
        self,
        messages: List[Dict[str, str]],
        system_prompt: Optional[str] = None,
        tools: Optional[List[Dict]] = None,
    ) -> Dict[str, Any]:
        """Send a chat completion request to OpenAI."""
        formatted_messages = []
        
        if system_prompt:
            formatted_messages.append({
                "role": "system",
                "content": system_prompt,
            })
        
        formatted_messages.extend(messages)
        
        kwargs = {
            "model": self.model,
            "messages": formatted_messages,
            "max_tokens": self.max_tokens,
            "temperature": self.temperature,
        }
        
        if tools:
            kwargs["tools"] = tools
            kwargs["tool_choice"] = "auto"
        
        response = await self.client.chat.completions.create(**kwargs)
        
        message = response.choices[0].message
        return {
            "content": message.content,
            "role": message.role,
            "tool_calls": message.tool_calls if hasattr(message, "tool_calls") else None,
            "usage": {
                "prompt_tokens": response.usage.prompt_tokens,
                "completion_tokens": response.usage.completion_tokens,
                "total_tokens": response.usage.total_tokens,
            },
        }
    
    async def transcribe_audio(self, audio_file_path: str) -> str:
        """Transcribe audio using Whisper."""
        with open(audio_file_path, "rb") as audio_file:
            response = await self.client.audio.transcriptions.create(
                model=settings.WHISPER_MODEL,
                file=audio_file,
            )
        return response.text
    
    async def generate_summary(self, text: str, max_length: int = 200) -> str:
        """Generate a summary of the provided text."""
        system_prompt = f"Summarize the following text in {max_length} characters or less. Be concise and capture key points."
        
        response = await self.chat(
            messages=[{"role": "user", "content": text}],
            system_prompt=system_prompt,
        )
        return response["content"]
    
    async def extract_action_items(self, text: str) -> List[Dict[str, str]]:
        """Extract action items from text."""
        system_prompt = """Extract action items from the following text. 
        Return ONLY a JSON array of objects with 'task' and 'assignee' (if mentioned) fields.
        Example: [{"task": "Follow up with client", "assignee": "John"}]"""
        
        response = await self.chat(
            messages=[{"role": "user", "content": text}],
            system_prompt=system_prompt,
        )
        
        try:
            import json
            return json.loads(response["content"])
        except:
            return []
    
    async def extract_events(self, text: str) -> List[Dict[str, Any]]:
        """Extract calendar events from text."""
        system_prompt = """Extract calendar events from the following text.
        Return ONLY a JSON array of objects with 'title', 'date', 'time', and 'duration_minutes' fields.
        Use ISO format for dates. Example: [{"title": "Team Meeting", "date": "2024-01-15", "time": "14:00", "duration_minutes": 60}]"""
        
        response = await self.chat(
            messages=[{"role": "user", "content": text}],
            system_prompt=system_prompt,
        )
        
        try:
            import json
            return json.loads(response["content"])
        except:
            return []
    
    async def draft_email_reply(self, email_content: str, tone: str = "professional") -> str:
        """Draft an email reply."""
        system_prompt = f"Draft a {tone} email reply to the following message. Be concise and professional."
        
        response = await self.chat(
            messages=[{"role": "user", "content": email_content}],
            system_prompt=system_prompt,
        )
        return response["content"]
    
    async def generate_daily_briefing(self, context: Dict[str, Any]) -> str:
        """Generate a personalized daily briefing."""
        system_prompt = """You are AURA, an AI executive assistant. Generate a concise, helpful daily briefing 
        based on the user's schedule, tasks, and emails. Be warm but professional. Highlight urgent items 
        and suggest priorities."""
        
        context_text = f"""
        Schedule: {context.get('events', [])}
        Pending Tasks: {context.get('tasks', [])}
        Unread Emails: {context.get('emails', [])}
        """
        
        response = await self.chat(
            messages=[{"role": "user", "content": context_text}],
            system_prompt=system_prompt,
        )
        return response["content"]
    
    async def generate_productivity_plan(
        self,
        tasks: List[Dict],
        events: List[Dict],
        preferences: Optional[Dict] = None,
    ) -> Dict[str, Any]:
        """Generate an optimized productivity plan."""
        system_prompt = """Create an optimized daily schedule that balances the user's tasks and events.
        Consider energy levels, task priority, and meeting times. Return a structured plan."""
        
        context = {
            "tasks": tasks,
            "events": events,
            "preferences": preferences or {},
        }
        
        import json
        response = await self.chat(
            messages=[{"role": "user", "content": json.dumps(context)}],
            system_prompt=system_prompt,
        )
        
        try:
            return json.loads(response["content"])
        except:
            return {"schedule": [], "recommendations": []}