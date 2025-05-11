CREATE TYPE occupation AS ENUM ('student', 'govt.servant', 'retired', 'private sector', 'agriculturalist', 'self-employed', 'housewife', 'other');
CREATE TYPE account_type AS ENUM ('savings', 'current');
CREATE TYPE nominee_relation AS ENUM ('Father', 'Mother', 'Son', 'Daughter', 'Sister', 'Brother', 'Spouse', 'Other');

ALTER TABLE bank_account 
  ADD COLUMN account_type account_type DEFAULT 'savings';

ALTER TABLE bank_account 
ALTER COLUMN account_type DROP DEFAULT;

ALTER TABLE bank_account 
  DROP CONSTRAINT IF EXISTS uq_bank_account,
  ADD CONSTRAINT uq_bank_account UNIQUE (account_no, ifsc_code);

ALTER TABLE signup_checkpoints 
  ALTER COLUMN occupation TYPE occupation USING 'self-employed'::occupation;

ALTER TABLE nominees 
  DROP COLUMN pan_id, 
  DROP COLUMN aadhaar_id, 
  DROP COLUMN relationship;


ALTER TABLE nominees 
  ADD COLUMN id_type VARCHAR(10) NOT NULL DEFAULT 'PAN', 
  ADD COLUMN gov_id VARCHAR(16) NOT NULL, 
  ADD COLUMN relation nominee_relation NOT NULL DEFAULT 'Other', 
  ADD COLUMN created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL, 
  ADD COLUMN updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL;


ALTER TABLE nominees 
  ADD CONSTRAINT CHK_Share CHECK (share > 0 AND share <= 100);

