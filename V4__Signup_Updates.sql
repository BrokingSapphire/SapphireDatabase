CREATE TYPE occupation AS ENUM ('student', 'govt.servant', 'retired', 'private sector', 'agriculturalist', 'self-employed', 'housewife', 'other');
CREATE TYPE account_type AS ENUM ('savings', 'current');
CREATE TYPE nominee_relation AS ENUM ('Father', 'Mother', 'Son', 'Daughter', 'Sister', 'Brother', 'Spouse', 'Other');

ALTER TABLE bank_account 
  ADD COLUMN account_type account_type DEFAULT 'savings';

ALTER TABLE bank_account 
  ALTER COLUMN account_type DROP DEFAULT;

ALTER TABLE signup_checkpoints 
  ALTER COLUMN occupation TYPE occupation USING 'self-employed'::occupation;

ALTER TABLE nominees 
  ADD COLUMN id_type VARCHAR(10) NOT NULL DEFAULT 'PAN', 
  ADD COLUMN created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL, 
  ADD COLUMN updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL;
ALTER TABLE nominees
  ALTER COLUMN relationship TYPE nominee_relation USING 'Other'::nominee_relation;

ALTER TABLE nominees 
  ADD CONSTRAINT CHK_Share CHECK (share > 0 AND share <= 100);

ALTER TABLE nominees
  ADD CONSTRAINT CHK_ID_Type_Consistency 
  CHECK (
    (id_type = 'PAN' AND pan_id IS NOT NULL AND aadhaar_id IS NULL) OR
    (id_type = 'AADHAAR' AND aadhaar_id IS NOT NULL AND pan_id IS NULL)
  );
