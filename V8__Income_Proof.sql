ALTER TABLE signup_checkpoints
    ADD COLUMN income_proof TEXT;

ALTER TABLE signup_verification_status
    ADD COLUMN income_proof_status compliance_verification_status NOT NULL DEFAULT 'processing';

ALTER TABLE signup_checkpoints
    ADD COLUMN esign               TEXT,
    ADD COLUMN pan_document        TEXT,
    ADD COLUMN pan_document_issuer VARCHAR(100);

ALTER TABLE "user"
    ADD COLUMN esign               TEXT,
    ADD COLUMN pan_document        TEXT,
    ADD COLUMN pan_document_issuer VARCHAR(100);
