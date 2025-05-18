CREATE TYPE occupation AS ENUM ('student', 'govt servant', 'retired', 'private sector', 'agriculturalist', 'self employed', 'housewife', 'other');
CREATE TYPE account_type AS ENUM ('savings', 'current');
CREATE TYPE nominee_relation AS ENUM ('Father', 'Mother', 'Son', 'Daughter', 'Sister', 'Brother', 'Spouse', 'Other');

ALTER TABLE bank_account
    ADD COLUMN account_type account_type DEFAULT 'savings';

ALTER TABLE bank_account
    ALTER COLUMN account_type DROP DEFAULT;

ALTER TABLE signup_checkpoints
    ALTER COLUMN occupation TYPE occupation USING 'self employed'::occupation,
    ADD COLUMN client_id VARCHAR(10);

ALTER TABLE nominees
    ADD COLUMN govt_id    VARCHAR(12)                         NOT NULL DEFAULT '',
    ADD COLUMN created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    ALTER COLUMN relationship TYPE nominee_relation USING 'Other'::nominee_relation,
    DROP CONSTRAINT FK_Nominees_Pan,
    DROP CONSTRAINT FK_Nominees_Aadhaar,
    DROP COLUMN aadhaar_id,
    DROP COLUMN pan_id,
    ADD CONSTRAINT CHK_Share CHECK (share > 0.0 AND share <= 100.0);

ALTER TABLE nominees
    ALTER COLUMN govt_id DROP DEFAULT;

ALTER TABLE signup_checkpoints
    DROP CONSTRAINT FK_Checkpoint_User_Payment,
    DROP COLUMN payment_id;

DROP TABLE razorpay_data;