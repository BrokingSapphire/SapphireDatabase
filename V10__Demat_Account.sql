CREATE TYPE depository AS ENUM ('CDSL', 'NSDL');
CREATE TYPE demat_status AS ENUM ('active', 'frozen', 'suspended', 'under_review', 'processing');
CREATE TYPE demat_action AS ENUM ('freeze', 'unfreeze');
CREATE TYPE funds_settlement_frequency AS ENUM ('30_days', '90_days', 'bill_to_bill');

-- Create demat account table
CREATE TABLE demat_account
(
    id          SERIAL,
    depository  depository   NOT NULL,
    dp_name     VARCHAR(100) NOT NULL,
    dp_id       VARCHAR(20)  NOT NULL,
    bo_id       VARCHAR(20)  NOT NULL,
    client_name INT          NOT NULL,
    created_at  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_Demat_Account_Id PRIMARY KEY (id),
    CONSTRAINT FK_Demat_Account_Client_Name FOREIGN KEY (client_name) REFERENCES user_name (id),
    CONSTRAINT UQ_Demat_Account_DP_BO UNIQUE (dp_id, bo_id)
);


ALTER TABLE signup_checkpoints 
ADD COLUMN demat_account_id INT,
ADD CONSTRAINT FK_Signup_Checkpoints_Demat_Account 
    FOREIGN KEY (demat_account_id) REFERENCES demat_account (id);

ALTER TABLE "user" 
ADD COLUMN demat_account_id INT,
ADD CONSTRAINT FK_User_Demat_Account 
    FOREIGN KEY (demat_account_id) REFERENCES demat_account (id);

ALTER TABLE signup_verification_status 
ADD COLUMN demat_status compliance_verification_status NOT NULL DEFAULT 'processing';

-- Drop and recreate the overall_status generated column to include demat_status
ALTER TABLE signup_verification_status 
DROP COLUMN overall_status;

ALTER TABLE signup_verification_status 
ADD COLUMN overall_status compliance_verification_status NOT NULL GENERATED ALWAYS AS (
    CASE
        WHEN pan_status = 'rejected' OR
             aadhaar_status = 'rejected' OR
             bank_status = 'rejected' OR
             address_status = 'rejected' OR
             signature_status = 'rejected' OR
             ipv_status = 'rejected' OR
             front_office_status = 'rejected' OR
             trading_preferences_status = 'rejected' OR
             nominee_status = 'rejected' OR
             other_documents_status = 'rejected' OR
             esign_status = 'rejected' OR
             income_proof_status = 'rejected' OR
             demat_status = 'rejected' THEN 'rejected'::compliance_verification_status
        WHEN pan_status = 'processing' OR
             aadhaar_status = 'processing' OR
             bank_status = 'processing' OR
             address_status = 'processing' OR
             signature_status = 'processing' OR
             ipv_status = 'processing' OR
             front_office_status = 'processing' OR
             trading_preferences_status = 'processing' OR
             nominee_status = 'processing' OR
             other_documents_status = 'processing' OR
             esign_status = 'processing' OR
             income_proof_status = 'processing' OR
             demat_status = 'processing' THEN 'processing'::compliance_verification_status
        WHEN pan_status = 'pending' OR
             aadhaar_status = 'pending' OR
             bank_status = 'pending' OR
             address_status = 'pending' OR
             signature_status = 'pending' OR
             ipv_status = 'pending' OR
             front_office_status = 'pending' OR
             trading_preferences_status = 'pending' OR
             nominee_status = 'pending' OR
             other_documents_status = 'pending' OR
             esign_status = 'pending' OR
             income_proof_status = 'pending' OR
             demat_status = 'pending' THEN 'pending'::compliance_verification_status
        ELSE 'verified'::compliance_verification_status
        END
    ) STORED;

CREATE TABLE user_demat_status
(
    id           SERIAL,
    user_id      CHAR(6)       NOT NULL,
    demat_status demat_status  NOT NULL DEFAULT 'active',
    freeze_until TIMESTAMP     NULL,
    created_at   TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at   TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_User_Demat_Status_Id PRIMARY KEY (id),
    CONSTRAINT FK_User_Demat_Status_User FOREIGN KEY (user_id) REFERENCES "user" (id),
    CONSTRAINT UQ_User_Demat_Status_User UNIQUE (user_id)
);

CREATE TABLE demat_freeze_log
(
    id               SERIAL,
    user_id          CHAR(6)       NOT NULL,
    previous_status  demat_status  NOT NULL,
    new_status       demat_status  NOT NULL,
    action           demat_action  NOT NULL,
    reason           TEXT          NULL,
    freeze_until     TIMESTAMP     NULL,
    created_at       TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_Demat_Freeze_Log_Id PRIMARY KEY (id),
    CONSTRAINT FK_Demat_Freeze_Log_User FOREIGN KEY (user_id) REFERENCES "user" (id)
);

CREATE TABLE user_settlement_frequency
(
    id                    SERIAL,
    user_id               CHAR(6)                     NOT NULL,
    settlement_frequency  funds_settlement_frequency  NOT NULL,
    created_at            TIMESTAMP                   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at            TIMESTAMP                   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_User_Settlement_Frequency_Id PRIMARY KEY (id),
    CONSTRAINT FK_User_Settlement_Frequency_User FOREIGN KEY (user_id) REFERENCES "user" (id),
    CONSTRAINT UQ_User_Settlement_Frequency_User UNIQUE (user_id)
);

ALTER TABLE demat_freeze_log
    ADD CONSTRAINT CHK_Freeze_Action_Status 
    CHECK (
        (action = 'freeze' AND new_status IN ('frozen', 'suspended', 'under_review')) OR
        (action = 'unfreeze' AND new_status = 'active')
    );
