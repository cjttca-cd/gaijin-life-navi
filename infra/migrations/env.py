"""Alembic environment configuration.

Supports both:
- SQLite  (local development / testing)
- PostgreSQL (production)

The DATABASE_URL env var overrides alembic.ini's sqlalchemy.url.
"""

import os
from logging.config import fileConfig

from alembic import context
from sqlalchemy import create_engine, pool

# ── Import models so metadata is populated ────────────────────────────
# prepend_sys_path in alembic.ini adds backend/app_service to sys.path.
from database import Base  # noqa: F401
from models import Profile, DailyUsage  # noqa: F401
from models.banking_guide import BankingGuide  # noqa: F401
from models.visa_procedure import VisaProcedure  # noqa: F401
from models.admin_procedure import AdminProcedure  # noqa: F401
from models.user_procedure import UserProcedure  # noqa: F401
from models.medical_phrase import MedicalPhrase  # noqa: F401

# ── Alembic Config ────────────────────────────────────────────────────
config = context.config

if config.config_file_name is not None:
    fileConfig(config.config_file_name)

target_metadata = Base.metadata

# Override URL from environment if set
database_url = os.environ.get("DATABASE_URL")
if database_url:
    # Convert async URLs to sync for Alembic (which runs synchronously)
    database_url = database_url.replace("sqlite+aiosqlite", "sqlite")
    database_url = database_url.replace("postgresql+asyncpg", "postgresql")
    config.set_main_option("sqlalchemy.url", database_url)


def run_migrations_offline() -> None:
    """Run migrations in 'offline' mode — emits SQL without connecting."""
    url = config.get_main_option("sqlalchemy.url")
    context.configure(
        url=url,
        target_metadata=target_metadata,
        literal_binds=True,
        dialect_opts={"paramstyle": "named"},
        render_as_batch=True,  # Required for SQLite ALTER TABLE support
    )
    with context.begin_transaction():
        context.run_migrations()


def run_migrations_online() -> None:
    """Run migrations in 'online' mode — connects to the database."""
    url = config.get_main_option("sqlalchemy.url")

    # Detect SQLite
    is_sqlite = url and url.startswith("sqlite")

    connect_args = {}
    if is_sqlite:
        connect_args["check_same_thread"] = False

    connectable = create_engine(
        url,
        poolclass=pool.NullPool,
        connect_args=connect_args,
    )

    with connectable.connect() as connection:
        context.configure(
            connection=connection,
            target_metadata=target_metadata,
            render_as_batch=True,  # Required for SQLite ALTER TABLE support
        )
        with context.begin_transaction():
            context.run_migrations()


if context.is_offline_mode():
    run_migrations_offline()
else:
    run_migrations_online()
