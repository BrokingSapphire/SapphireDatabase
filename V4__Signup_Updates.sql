CREATE TYPE occupation AS ENUM ('student', 'govt servant', 'retired', 'private sector', 'agriculturalist', 'self employed', 'housewife', 'other');
CREATE TYPE account_type AS ENUM ('savings', 'current');
CREATE TYPE nominee_relation AS ENUM ('Father', 'Mother', 'Son', 'Daughter', 'Sister', 'Brother', 'Spouse', 'Other');
CREATE TYPE nationality AS ENUM ('INDIAN', 'OTHER');
CREATE TYPE residential_status AS ENUM ('Resident Individual', 'NRI', 'Foreign Nation', 'Person of Indian Origin');


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

ALTER TABLE address
    ALTER COLUMN address1 DROP NOT NULL;

ALTER TABLE aadhaar_detail
    ALTER COLUMN co DROP NOT NULL,
    ALTER COLUMN post_office DROP NOT NULL;

DROP TABLE razorpay_data;

-- fist login column
ALTER TABLE user_password_details
    ADD COLUMN is_first_login BOOLEAN NOT NULL DEFAULT TRUE;

ALTER TABLE signup_checkpoints 
ADD COLUMN doubt BOOLEAN DEFAULT FALSE,
ADD COLUMN user_provided_name INTEGER REFERENCES user_name(id),
ADD COLUMN user_provided_dob DATE;


ALTER TABLE "user"
ADD COLUMN maiden_name INT,
ADD CONSTRAINT FK_User_Maiden_Name FOREIGN KEY (maiden_name) REFERENCES user_name (id);

ALTER TABLE signup_checkpoints 
ADD COLUMN maiden_name INT,
ADD CONSTRAINT FK_Checkpoint_User_Maiden_Name FOREIGN KEY (maiden_name) REFERENCES user_name (id);

-- updating user father name to user/spouse name

ALTER TABLE "user" 
RENAME COLUMN father_name TO father_spouse_name;

ALTER TABLE "user" 
DROP CONSTRAINT FK_User_Father_Name;

ALTER TABLE "user" 
ADD CONSTRAINT FK_User_Father_Spouse_Name FOREIGN KEY (father_spouse_name) REFERENCES user_name (id);

ALTER TABLE signup_checkpoints 
RENAME COLUMN father_name TO father_spouse_name;

ALTER TABLE signup_checkpoints 
DROP CONSTRAINT FK_Checkpoint_User_Father_Name;

ALTER TABLE signup_checkpoints 
ADD CONSTRAINT FK_Checkpoint_User_Father_Spouse_Name FOREIGN KEY (father_spouse_name) REFERENCES user_name (id);

ALTER TABLE "user" 
ADD COLUMN nationality nationality NOT NULL DEFAULT 'INDIAN',
ADD COLUMN other_nationality VARCHAR(50),
ADD COLUMN residential_status residential_status NOT NULL DEFAULT 'Resident Individual';

ALTER TABLE address 
RENAME COLUMN address1 TO line_1;

ALTER TABLE address 
RENAME COLUMN address2 TO line_2;

ALTER TABLE address 
RENAME COLUMN street_name TO line_3;


ALTER TABLE "user" 
ADD CONSTRAINT CHK_User_Other_Nationality 
CHECK (
    (nationality = 'OTHER' AND other_nationality IS NOT NULL AND TRIM(other_nationality) != '') 
    OR 
    (nationality = 'INDIAN' AND other_nationality IS NULL)
);