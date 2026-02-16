"""Application configuration via environment variables."""

from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    """Application settings loaded from environment variables."""

    # Application
    APP_NAME: str = "Gaijin Life Navi - App Service"
    APP_VERSION: str = "0.1.0"
    DEBUG: bool = False

    # Database (absolute path — shared with AI Service)
    DATABASE_URL: str = "sqlite+aiosqlite:////root/.openclaw/projects/gaijin-life-navi/data/app.db"

    # Firebase
    FIREBASE_PROJECT_ID: str = "gaijin-life-navi"
    FIREBASE_CREDENTIALS: str = ""  # Path to service account JSON; empty = mock mode

    # Stripe
    STRIPE_SECRET_KEY: str = ""  # Empty = mock mode
    STRIPE_WEBHOOK_SECRET: str = ""
    STRIPE_PREMIUM_PRICE_ID: str = "price_premium_monthly"
    STRIPE_PREMIUM_PLUS_PRICE_ID: str = "price_premium_plus_monthly"

    # Tier limits (BUSINESS_RULES.md §2 — SSOT)
    FREE_COMMUNITY_POST_ALLOWED: bool = False  # Free tier cannot post/reply/vote

    # AI Service URL (for internal moderation calls)
    AI_SERVICE_URL: str = "http://localhost:8001"

    # CORS
    CORS_ORIGINS: str = "*"  # Comma-separated origins or "*"

    @property
    def cors_origins_list(self) -> list[str]:
        if self.CORS_ORIGINS == "*":
            return ["*"]
        return [o.strip() for o in self.CORS_ORIGINS.split(",") if o.strip()]

    model_config = {"env_file": ".env", "env_file_encoding": "utf-8"}


settings = Settings()
