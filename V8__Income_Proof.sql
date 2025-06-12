ALTER TABLE signup_checkpoints 
ADD COLUMN income_proof TEXT;

ALTER TABLE signup_verification_status 
ADD COLUMN income_proof_status compliance_verification_status NOT NULL DEFAULT 'processing';

ALTER TABLE signup_checkpoints 
ADD COLUMN esign_s3_key VARCHAR(500) NULL,
ADD COLUMN esign_s3_url VARCHAR(1000) NULL,
ADD COLUMN esign_filename VARCHAR(255) NULL,
ADD COLUMN esign_mime_type VARCHAR(100) NULL,
ADD COLUMN esign_completed_at TIMESTAMP NULL,
ADD COLUMN esign_file_size INTEGER NULL;

ALTER TABLE "user" 
ADD COLUMN esign_s3_key VARCHAR(500) NULL,
ADD COLUMN esign_s3_url VARCHAR(1000) NULL,
ADD COLUMN esign_filename VARCHAR(255) NULL,
ADD COLUMN esign_mime_type VARCHAR(100) NULL,
ADD COLUMN esign_completed_at TIMESTAMP NULL,
ADD COLUMN esign_file_size INTEGER NULL;

CREATE INDEX idx_user_esign_s3 ON "user"(email, esign_s3_key);
CREATE INDEX idx_user_esign_completed ON "user"(esign_completed_at);
