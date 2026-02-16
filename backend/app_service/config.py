"""Application configuration via environment variables."""

from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    """Application settings loaded from environment variables."""

    # Application
    APP_NAME: str = "Gaijin Life Navi - App Service"
    APP_VERSION: str = "0.1.0"
    DEBUG: bool = False

    # Database
    DATABASE_URL: str = "sqlite+aiosqlite:///./app.db"

    # Firebase
    FIREBASE_PROJECT_ID: str = "gaijin-life-navi"
    FIREBASE_CREDENTIALS: str = ""  # Path to service account JSON; empty = mock mode

    # CORS
    CORS_ORIGINS: str = "*"  # Comma-separated origins or "*"

    @property
    def cors_origins_list(self) -> list[str]:
        if self.CORS_ORIGINS == "*":
            return ["*"]
        return [o.strip() for o in self.CORS_ORIGINS.split(",") if o.strip()]

    model_config = {"env_file": ".env", "env_file_encoding": "utf-8"}


settings = Settings()
