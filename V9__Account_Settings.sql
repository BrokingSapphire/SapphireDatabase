CREATE TYPE theme AS ENUM ('light', 'dark');
CREATE TYPE chart_provider AS ENUM ('TradingView', 'ChartIQ');

CREATE TABLE account_deletions
(
    id              SERIAL,
    user_id         VARCHAR(10) NOT NULL,
    email           VARCHAR(100) NOT NULL,
    deletion_reason TEXT,
    deleted_at      TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_Account_Deletions_Id PRIMARY KEY (id),
    CONSTRAINT FK_Account_Deletions_User FOREIGN KEY (user_id) REFERENCES "user" (id)
);

CREATE TABLE user_preferences
(
    id                         SERIAL,
    user_id                    VARCHAR(10) NOT NULL,
    theme                      theme       NOT NULL DEFAULT 'light',
    biometric_authentication   BOOLEAN     NOT NULL DEFAULT FALSE,
    biometric_permission       BOOLEAN     NOT NULL DEFAULT FALSE,
    two_factor_authentication  BOOLEAN     NOT NULL DEFAULT FALSE,
    internet_permission        BOOLEAN     NOT NULL DEFAULT FALSE,
    storage_permission         BOOLEAN     NOT NULL DEFAULT FALSE,
    location_permission        BOOLEAN     NOT NULL DEFAULT FALSE,
    sms_reading_permission     BOOLEAN     NOT NULL DEFAULT FALSE,
    notification_permission    BOOLEAN     NOT NULL DEFAULT FALSE,
    order_preferences          JSONB       NOT NULL DEFAULT '{}',
    chart_provider             chart_provider NOT NULL DEFAULT 'TradingView',
    order_notifications        BOOLEAN     NOT NULL DEFAULT TRUE,
    trade_notifications        BOOLEAN     NOT NULL DEFAULT TRUE,
    trade_recommendations      BOOLEAN     NOT NULL DEFAULT TRUE,
    promotion_notifications    BOOLEAN     NOT NULL DEFAULT TRUE,
    created_at                 TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at                 TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_User_Preferences_Id PRIMARY KEY (id),
    CONSTRAINT FK_User_Preferences_User FOREIGN KEY (user_id) REFERENCES "user" (id),
    CONSTRAINT UQ_User_Preferences_User UNIQUE (user_id)
);


ALTER TABLE user_preferences
    ALTER COLUMN theme DROP DEFAULT;

ALTER TABLE user_preferences
    ALTER COLUMN chart_provider DROP DEFAULT;