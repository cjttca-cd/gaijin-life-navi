"""AI Service configuration via environment variables."""

from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    """AI Service settings loaded from environment variables."""

    # Application
    APP_NAME: str = "Gaijin Life Navi - AI Service"
    APP_VERSION: str = "0.1.0"
    DEBUG: bool = False

    # Database (shared with App Service — absolute path for consistency)
    DATABASE_URL: str = "sqlite+aiosqlite:////root/.openclaw/projects/gaijin-life-navi/data/app.db"

    # Claude API
    ANTHROPIC_API_KEY: str = ""
    CLAUDE_MODEL: str = "claude-sonnet-4-20250514"
    CLAUDE_MAX_TOKENS: int = 2000

    # OpenAI Embedding
    OPENAI_API_KEY: str = ""
    EMBEDDING_MODEL: str = "text-embedding-3-small"

    # Pinecone
    PINECONE_API_KEY: str = ""
    PINECONE_INDEX_NAME: str = "gaijin-life-navi"
    PINECONE_ENVIRONMENT: str = ""

    # Firebase
    FIREBASE_PROJECT_ID: str = "gaijin-life-navi"
    FIREBASE_CREDENTIALS: str = ""

    # CORS
    CORS_ORIGINS: str = "*"

    # Tier limits (from BUSINESS_RULES.md §2)
    FREE_CHAT_DAILY_LIMIT: int = 5

    @property
    def cors_origins_list(self) -> list[str]:
        if self.CORS_ORIGINS == "*":
            return ["*"]
        return [o.strip() for o in self.CORS_ORIGINS.split(",") if o.strip()]

    @property
    def claude_available(self) -> bool:
        return bool(self.ANTHROPIC_API_KEY)

    @property
    def rag_available(self) -> bool:
        return bool(self.OPENAI_API_KEY) and bool(self.PINECONE_API_KEY)

    model_config = {"env_file": ".env", "env_file_encoding": "utf-8"}


settings = Settings()
