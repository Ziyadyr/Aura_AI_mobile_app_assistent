from pydantic import BaseModel, EmailStr
from typing import Optional
from datetime import datetime


class UserBase(BaseModel):
    email: EmailStr
    display_name: Optional[str] = None
    photo_url: Optional[str] = None
    phone_number: Optional[str] = None


class UserCreate(UserBase):
    password: str


class UserLogin(BaseModel):
    email: EmailStr
    password: str


class UserUpdate(BaseModel):
    display_name: Optional[str] = None
    photo_url: Optional[str] = None
    phone_number: Optional[str] = None
    ai_action_mode: Optional[str] = None
    ai_memory_enabled: Optional[bool] = None
    theme: Optional[str] = None
    notifications_enabled: Optional[bool] = None
    timezone: Optional[str] = None


class UserResponse(UserBase):
    id: str
    ai_action_mode: str
    ai_memory_enabled: bool
    theme: str
    notifications_enabled: bool
    timezone: str
    created_at: datetime
    updated_at: Optional[datetime] = None
    last_login_at: Optional[datetime] = None
    is_active: bool
    is_verified: bool

    class Config:
        from_attributes = True


class TokenResponse(BaseModel):
    access_token: str
    refresh_token: str
    token_type: str = "bearer"
    expires_in: int