CREATE TABLE user_mpin (
    id SERIAL,
    client_id CHAR(6) NOT NULL,
    mpin_hash VARCHAR(250) NOT NULL,
    mpin_salt VARCHAR(100) NOT NULL,
    hash_algo_id INT NOT NULL,
    failed_attempts INTEGER NOT NULL DEFAULT 0,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    last_failed_attempt TIMESTAMP NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT PK_User_MPIN_Id PRIMARY KEY (id),
    CONSTRAINT UQ_User_MPIN_Client_id UNIQUE (client_id),
    CONSTRAINT FK_User_MPIN_Client FOREIGN KEY (client_id) REFERENCES "user"(id),
    CONSTRAINT FK_User_MPIN_Hash_Algo FOREIGN KEY (hash_algo_id) REFERENCES hashing_algorithm(id)
);


ALTER TABLE signup_verification_status 
ADD COLUMN mpin_status compliance_verification_status NOT NULL DEFAULT 'pending';

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
             demat_status = 'rejected' OR
             mpin_status = 'rejected' THEN 'rejected'::compliance_verification_status
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
             demat_status = 'processing' OR
             mpin_status = 'processing' THEN 'processing'::compliance_verification_status
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
             demat_status = 'pending' OR
             mpin_status = 'pending' THEN 'pending'::compliance_verification_status
        ELSE 'verified'::compliance_verification_status
        END
    ) STORED;