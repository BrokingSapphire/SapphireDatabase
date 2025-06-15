CREATE TABLE user_mpin
(
    id                  SERIAL,
    client_id           CHAR(6)      NOT NULL,
    mpin_hash           VARCHAR(250) NOT NULL,
    mpin_salt           VARCHAR(100) NOT NULL,
    hash_algo_id        INT          NOT NULL,
    failed_attempts     INTEGER      NOT NULL DEFAULT 0,
    is_active           BOOLEAN      NOT NULL DEFAULT TRUE,
    last_failed_attempt TIMESTAMP    NULL,
    created_at          TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT PK_User_MPIN_Id PRIMARY KEY (id),
    CONSTRAINT UQ_User_MPIN_Client_id UNIQUE (client_id),
    CONSTRAINT FK_User_MPIN_Client FOREIGN KEY (client_id) REFERENCES "user" (id),
    CONSTRAINT FK_User_MPIN_Hash_Algo FOREIGN KEY (hash_algo_id) REFERENCES hashing_algorithm (id)
);

CREATE TABLE user_2fa
(
    id           SERIAL PRIMARY KEY,
    user_id      CHAR(6)      NOT NULL,
    secret       VARCHAR(255) NOT NULL,
    backup_codes TEXT[],
    created_at   TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at   TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT FK_User_2fa FOREIGN KEY (user_id) REFERENCES "user" (id),
    CONSTRAINT UQ_User_2fa UNIQUE (user_id)
);

ALTER TABLE user_2fa 
ADD COLUMN method VARCHAR(20) NOT NULL DEFAULT 'disabled';

ALTER TABLE user_2fa 
ALTER COLUMN secret DROP NOT NULL;

UPDATE user_2fa 
SET method = 'authenticator' 
WHERE secret IS NOT NULL;

UPDATE user_2fa 
SET method = 'sms_otp' 
WHERE secret IS NULL AND method = 'disabled';

ALTER TABLE user_2fa 
ADD CONSTRAINT CHK_User_2fa_Method 
CHECK (method IN ('disabled', 'sms_otp', 'authenticator'));

CREATE TABLE user_login_history
(
    id               SERIAL,
    user_id          CHAR(6)      NOT NULL,
    email            VARCHAR(100) NOT NULL,
    ip_address       INET         NOT NULL,
    user_agent       TEXT         NOT NULL,
    browser          VARCHAR(100),
    device           VARCHAR(100),
    device_type      VARCHAR(50),
    location_country VARCHAR(100),
    location_region  VARCHAR(100),
    location_city    VARCHAR(100),
    login_time       TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    success          BOOLEAN      NOT NULL DEFAULT FALSE,
    failure_reason   VARCHAR(255),
    session_id       VARCHAR(255),
    
    CONSTRAINT PK_User_Login_History_Id PRIMARY KEY (id),
    CONSTRAINT FK_User_Login_History_User FOREIGN KEY (user_id) REFERENCES "user" (id)
);

-- User FCM-Token
CREATE TABLE user_fcm_tokens (
    id SERIAL PRIMARY KEY,
    user_id VARCHAR(255) NOT NULL,
    fcm_token TEXT NOT NULL,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Foreign key constraint
    CONSTRAINT fk_user_fcm_tokens_user_id 
        FOREIGN KEY (user_id) REFERENCES "user"(id) ON DELETE CASCADE,
    
    -- Unique constraint for user_id + fcm_token combination
    CONSTRAINT uq_user_fcm_token 
        UNIQUE (user_id, fcm_token)
);