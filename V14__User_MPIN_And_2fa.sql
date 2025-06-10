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