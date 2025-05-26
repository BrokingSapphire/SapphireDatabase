ALTER TABLE signup_checkpoints 
ADD COLUMN income_proof TEXT;

ALTER TABLE signup_verification_status 
ADD COLUMN income_proof_status compliance_verification_status NOT NULL DEFAULT 'processing';