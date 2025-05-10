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
