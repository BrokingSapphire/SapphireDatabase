-- V2_Funds_Tables

-- Enums
CREATE TYPE deposit_transaction_type AS ENUM ('deposit', 'withdrawal');
CREATE TYPE bank_verification_status AS ENUM ('pending', 'verified', 'failed');
CREATE TYPE balance_transaction_status AS ENUM ('pending', 'completed', 'rejected', 'failed');

-- Alters
ALTER TABLE user_sessions
    ALTER COLUMN is_active SET NOT NULL;
ALTER TABLE bank_account
    ADD COLUMN verification bank_verification_status NOT NULL DEFAULT 'pending';
ALTER TABLE bank_account
    ALTER COLUMN verification DROP DEFAULT;
ALTER TABLE bank_account
    ADD COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE bank_account
    ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;

-- Tables
CREATE TABLE user_balance
(
    id                       SERIAL,
    user_id                  INT       NOT NULL,
    available_cash           FLOAT4    NOT NULL,
    blocked_cash             FLOAT4    NOT NULL,
    total_cash               FLOAT4    NOT NULL GENERATED ALWAYS AS (available_cash + blocked_cash) STORED,
    available_liq_margin     FLOAT4    NOT NULL,
    available_non_liq_margin FLOAT4    NOT NULL,
    available_margin         FLOAT4    NOT NULL GENERATED ALWAYS AS (available_liq_margin + available_non_liq_margin) STORED,
    blocked_margin           FLOAT4    NOT NULL,
    total_margin             FLOAT4    NOT NULL GENERATED ALWAYS AS (available_liq_margin + available_non_liq_margin + blocked_margin) STORED,
    total_available_balance  FLOAT4    NOT NULL GENERATED ALWAYS AS (available_cash + available_liq_margin + available_non_liq_margin) STORED,
    total_balance            FLOAT4    NOT NULL GENERATED ALWAYS AS (available_cash + blocked_cash +
                                                                     available_liq_margin +
                                                                     available_non_liq_margin + blocked_margin) STORED,
    created_at               TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at               TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_User_Balance_Id PRIMARY KEY (id),
    CONSTRAINT FK_User_Balance FOREIGN KEY (user_id) REFERENCES "user" (id)
);

CREATE TABLE balance_transactions
(
    reference_no          VARCHAR(30)                NOT NULL,
    transaction_id        VARCHAR(20)                NOT NULL,
    user_id               INT                        NOT NULL,
    transaction_type      deposit_transaction_type   NOT NULL,
    status                balance_transaction_status NOT NULL,
    bank_id               INT,
    amount                FLOAT4                     NOT NULL,
    safety_cut_amount     FLOAT4                     NOT NULL,
    safety_cut_percentage FLOAT4                     NOT NULL,
    transaction_time      TIMESTAMP                  NOT NULL,
    created_at            TIMESTAMP                  NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at            TIMESTAMP                  NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_Balance_Reference_no PRIMARY KEY (reference_no),
    CONSTRAINT UQ_Balance_Transaction_Id UNIQUE (transaction_id),
    CONSTRAINT FK_Balance_Transaction_User FOREIGN KEY (user_id) REFERENCES "user" (id),
    CONSTRAINT FK_Balance_Transaction_Bank FOREIGN KEY (bank_id) REFERENCES bank_account (id)
);