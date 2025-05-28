CREATE TYPE compliance_verification_status AS ENUM ('processing', 'pending', 'verified', 'rejected');

-- Table
CREATE TABLE signup_verification_status
(
    id                         INT                            NOT NULL,
    pan_status                 compliance_verification_status NOT NULL DEFAULT 'processing',
    aadhaar_status             compliance_verification_status NOT NULL DEFAULT 'processing',
    bank_status                compliance_verification_status NOT NULL DEFAULT 'processing',
    address_status             compliance_verification_status NOT NULL DEFAULT 'processing',
    signature_status           compliance_verification_status NOT NULL DEFAULT 'processing',
    ipv_status                 compliance_verification_status NOT NULL DEFAULT 'processing',
    front_office_status        compliance_verification_status NOT NULL DEFAULT 'processing',
    trading_preferences_status compliance_verification_status NOT NULL DEFAULT 'processing',
    nominee_status             compliance_verification_status NOT NULL DEFAULT 'processing',
    other_documents_status     compliance_verification_status NOT NULL DEFAULT 'processing',
    esign_status               compliance_verification_status NOT NULL DEFAULT 'processing',
    overall_status             compliance_verification_status NOT NULL GENERATED ALWAYS AS (
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
                 esign_status = 'rejected' THEN 'rejected'::compliance_verification_status
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
                 esign_status = 'processing' THEN 'processing'::compliance_verification_status
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
                 esign_status = 'pending' THEN 'pending'::compliance_verification_status
            ELSE 'verified'::compliance_verification_status
            END
        ) STORED,
    created_at                 TIMESTAMP                      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at                 TIMESTAMP                      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_Signup_Verification_Status_Id PRIMARY KEY (id)
);

CREATE TABLE compliance_processing (
    checkpoint_id INT NOT NULL,
    officer_id INT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_Compliance_Checkpoint_Id PRIMARY KEY (checkpoint_id),
    CONSTRAINT FK_Officer_Compliance_Id FOREIGN KEY (officer_id) REFERENCES "user" (id),
    CONSTRAINT FK_Checkpoint_Compliance_Id FOREIGN KEY (checkpoint_id) REFERENCES "signup_checkpoints" (id)
);