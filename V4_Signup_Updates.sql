CREATE TYPE occupation AS ENUM ('student','govt.servant','retired','private sector','agriculturalist','self-employed','housewife','other' );

CREATE TYPE account_type AS ENUM ('savings','current' );

ALTER TABLE bank_account ADD COLUMN account_type account_type;

ALTER TABLE bank_account DROP CONSTRAINT IF EXISTS uq_bank_account;
ALTER TABLE bank_account ADD CONSTRAINT uq_bank_account UNIQUE (account_no, ifsc_code, account_type);

-- occupation change to enum
ALTER TABLE signup_checkpoints DROP COLUMN IF EXISTS occupation;
ALTER TABLE signup_checkpoints ADD COLUMN occupation occupation;

-- politically exposed person
ALTER TABLE signup_checkpoints ADD COLUMN IF NOT EXISTS is_politically_exposed BOOLEAN;


CREATE TYPE nominee_relation AS ENUM (
    'Father',
    'Mother',
    'Son', 
    'Daughter',
    'Sister',
    'Brother',
    'Spouse',
    'Other'
);

ALTER TABLE nominees
DROP CONSTRAINT IF EXISTS FK_Nominees_Pan,
DROP CONSTRAINT IF EXISTS FK_Nominees_Aadhaar;

ALTER TABLE nominees_to_checkpoint
DROP CONSTRAINT IF EXISTS FK_Nominees_To_Checkpoint_Nominees_Id;

ALTER TABLE nominees
DROP COLUMN IF EXISTS pan_id,
DROP COLUMN IF EXISTS aadhaar_id,
DROP COLUMN IF EXISTS relationship,
ADD COLUMN IF NOT EXISTS id_type VARCHAR(10) NOT NULL CHECK (id_type IN ('PAN', 'AADHAR')),
ADD COLUMN IF NOT EXISTS gov_id VARCHAR(16) NOT NULL,
ADD COLUMN IF NOT EXISTS relation nominee_relation NOT NULL,
ADD COLUMN IF NOT EXISTS created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
ALTER COLUMN share TYPE INT USING (share::INT),
ADD CONSTRAINT CHK_Share CHECK (share > 0 AND share <= 100);

ALTER TABLE nominees_to_checkpoint
ADD CONSTRAINT FK_Nominees_To_Checkpoint_Nominees_Id FOREIGN KEY (nominees_id) REFERENCES nominees (id) ON DELETE CASCADE;