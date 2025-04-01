-- V2_Funds_Tables

-- Enums
CREATE TYPE deposit_transaction_type AS ENUM ('deposit', 'withdrawal');
CREATE TYPE status AS ENUM ('pending', 'completed', 'rejected', 'failed');

ALTER TABLE bank_account ADD COLUMN verification status NOT NULL DEFAULT 'pending';
ALTER TABLE bank_account ALTER COLUMN verification DROP DEFAULT;
ALTER TABLE bank_account ADD COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE bank_account ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;

-- Tables
CREATE TABLE user_balance
(
    id SERIAL,
    user_id INT NOT NULL,
    available_cash FLOAT4 NOT NULL,
    blocked_cash FLOAT4 NOT NULL,
    total_cash FLOAT4 NOT NULL GENERATED ALWAYS AS (available_cash + blocked_cash) STORED,
    available_liq_margin FLOAT4 NOT NULL,
    available_non_liq_margin FLOAT4 NOT NULL,
    available_margin FLOAT4 NOT NULL GENERATED ALWAYS AS (available_liq_margin + available_non_liq_margin) STORED,
    blocked_margin FLOAT4 NOT NULL,
    total_margin FLOAT4 NOT NULL GENERATED ALWAYS AS (available_margin + blocked_margin) STORED,
    total_available_balance FLOAT4 NOT NULL GENERATED ALWAYS AS (available_cash + available_margin) STORED,
    total_balance FLOAT4 GENERATED ALWAYS AS (total_cash + total_margin) STORED,
    CONSTRAINT PK_User_Balance_Id PRIMARY KEY (id),
    CONSTRAINT FK_User_Balance FOREIGN KEY (user_id) REFERENCES "user" (id)
);

CREATE TABLE funds_transactions
(
    transaction_id INT NOT NULL,
    transaction_type deposit_transaction_type NOT NULL,
    current_status status NOT NULL,
    bank_id INT NOT NULL,
    remarks TEXT NOT NULL,
    processing_window TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    original_amount FLOAT4 NOT NULL,
    safety_cut_amount FLOAT4 NOT NULL,
    safety_cut_percentage FLOAT4 NOT NULL,
    CONSTRAINT PK_Funds_Transactions_Id PRIMARY KEY (bank_id),
    CONSTRAINT UQ_Transaction_Id UNIQUE (transaction_id)
);