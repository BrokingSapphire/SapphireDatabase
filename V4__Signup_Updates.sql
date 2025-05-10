CREATE TYPE occupation AS ENUM ('student','govt.servant','retired','private sector','agriculturalist','self-employed','housewife','other');
CREATE TYPE account_type AS ENUM ('savings','current');
CREATE TYPE nominee_relation AS ENUM ('Father', 'Mother', 'Son', 'Daughter', 'Sister', 'Brother', 'Spouse', 'Other');

ALTER TABLE bank_account 
  ADD COLUMN account_type account_type DEFAULT 'savings';

ALTER TABLE bank_account 
  DROP CONSTRAINT IF EXISTS uq_bank_account,
  ADD CONSTRAINT uq_bank_account UNIQUE (account_no, ifsc_code, account_type);

ALTER TABLE signup_checkpoints 
  ADD COLUMN occupation occupation DEFAULT 'self-employed';

ALTER TABLE signup_checkpoints 
  ADD COLUMN is_politically_exposed BOOLEAN DEFAULT FALSE;

ALTER TABLE nominees 
  ADD COLUMN id_type VARCHAR(10) NOT NULL DEFAULT 'PAN', 
  ADD COLUMN gov_id VARCHAR(16) NOT NULL, 
  ADD COLUMN relation nominee_relation NOT NULL DEFAULT 'Other', 
  ADD COLUMN created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL, 
  ADD COLUMN updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL;

ALTER TABLE nominees 
  ALTER COLUMN share SET DEFAULT 0;

ALTER TABLE nominees 
  ADD CONSTRAINT CHK_Share CHECK (share > 0 AND share <= 100);

ALTER TABLE nominees_to_checkpoint
  ADD CONSTRAINT FK_Nominees_To_Checkpoint_Nominees_Id FOREIGN KEY (nominees_id) REFERENCES nominees (id) ON DELETE CASCADE;

ALTER TABLE nominees 
  DROP COLUMN IF EXISTS pan_id, 
  DROP COLUMN IF EXISTS aadhaar_id, 
  DROP COLUMN IF EXISTS relationship;