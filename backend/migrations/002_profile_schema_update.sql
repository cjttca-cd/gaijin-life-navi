-- Migration 002: Profile schema update
-- - Rename arrival_date → visa_expiry
-- - Change preferred_language: NOT NULL DEFAULT 'en' → nullable
-- - Widen residence_region from VARCHAR(10) to VARCHAR(100)
--
-- For SQLite: ALTER TABLE has limited support, so we use a table rebuild strategy.
-- For PostgreSQL: Simple ALTER TABLE statements below can be used directly.
--
-- === SQLite version (full table rebuild) ===

-- Step 1: Create new table with updated schema
CREATE TABLE IF NOT EXISTS profiles_new (
    id VARCHAR(128) NOT NULL PRIMARY KEY,
    display_name VARCHAR(100) DEFAULT '' NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    avatar_url TEXT,
    nationality VARCHAR(2),
    residence_status VARCHAR(50),
    residence_region VARCHAR(100),
    visa_expiry DATE,
    preferred_language VARCHAR(10),
    subscription_tier VARCHAR(20) DEFAULT 'free' NOT NULL,
    onboarding_completed BOOLEAN DEFAULT 0 NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at DATETIME
);

-- Step 2: Copy data (arrival_date is dropped, visa_expiry starts as NULL)
INSERT OR IGNORE INTO profiles_new (
    id, display_name, email, avatar_url, nationality, residence_status,
    residence_region, visa_expiry, preferred_language, subscription_tier,
    onboarding_completed, created_at, updated_at, deleted_at
)
SELECT
    id, display_name, email, avatar_url, nationality, residence_status,
    residence_region, NULL, preferred_language, subscription_tier,
    onboarding_completed, created_at, updated_at, deleted_at
FROM profiles;

-- Step 3: Drop old table and rename
DROP TABLE IF EXISTS profiles;
ALTER TABLE profiles_new RENAME TO profiles;

-- === PostgreSQL version (uncomment if using PostgreSQL) ===
-- ALTER TABLE profiles DROP COLUMN IF EXISTS arrival_date;
-- ALTER TABLE profiles ADD COLUMN IF NOT EXISTS visa_expiry DATE;
-- ALTER TABLE profiles ALTER COLUMN preferred_language DROP NOT NULL;
-- ALTER TABLE profiles ALTER COLUMN preferred_language DROP DEFAULT;
-- ALTER TABLE profiles ALTER COLUMN preferred_language TYPE VARCHAR(10);
-- ALTER TABLE profiles ALTER COLUMN residence_region TYPE VARCHAR(100);
