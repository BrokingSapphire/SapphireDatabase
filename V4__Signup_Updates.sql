CREATE TYPE occupation AS ENUM ('student', 'govt servant', 'retired', 'private sector', 'agriculturalist', 'self employed', 'housewife', 'other');
CREATE TYPE account_type AS ENUM ('savings', 'current');
CREATE TYPE nominee_relation AS ENUM ('Father', 'Mother', 'Son', 'Daughter', 'Sister', 'Brother', 'Spouse', 'Other');
CREATE TYPE nationality AS ENUM ('INDIAN', 'OTHER');
CREATE TYPE residential_status AS ENUM ('Resident Individual', 'NRI', 'Foreign Nation', 'Person of Indian Origin');
CREATE TYPE address_type AS ENUM ('Residential', 'Business', 'Unspecified');
CREATE TYPE yes_no AS ENUM ('YES', 'NO');
CREATE TYPE country_enum AS ENUM ('INDIA', 'OTHER');
CREATE TYPE user_account_type AS ENUM ('Individual', 'Non-Individual');

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

ALTER TABLE address
    ALTER COLUMN line_1 DROP NOT NULL;

ALTER TABLE address
    ADD COLUMN address_type address_type NOT NULL DEFAULT 'Residential';

ALTER TABLE address
    ALTER COLUMN address_type DROP DEFAULT;

ALTER TABLE "user" 
ADD CONSTRAINT CHK_User_Other_Nationality 
CHECK (
    (nationality = 'OTHER' AND other_nationality IS NOT NULL AND TRIM(other_nationality) != '') 
    OR 
    (nationality = 'INDIAN' AND other_nationality IS NULL)
);

ALTER TABLE "user" 
RENAME COLUMN address_id TO permanent_address_id;

ALTER TABLE signup_checkpoints 
RENAME COLUMN address_id TO permanent_address_id;

CREATE TABLE correspondence_address (
    id SERIAL,
    line_1 TEXT,
    line_2 TEXT,
    line_3 TEXT,
    country_id VARCHAR(3) NOT NULL,
    state_id INT NOT NULL,
    city_id INT NOT NULL,
    postal_id INT NOT NULL,
    address_type address_type NOT NULL DEFAULT 'Residential',
    CONSTRAINT PK_Correspondence_Address_Id PRIMARY KEY (id),
    CONSTRAINT FK_Correspondence_Address_Country FOREIGN KEY (country_id) REFERENCES country (iso),
    CONSTRAINT FK_Correspondence_Address_State FOREIGN KEY (state_id) REFERENCES state (id),
    CONSTRAINT FK_Correspondence_Address_City FOREIGN KEY (city_id) REFERENCES city (id),
    CONSTRAINT FK_Correspondence_Address_Postal FOREIGN KEY (postal_id) REFERENCES postal_code (id)
);

ALTER TABLE correspondence_address
    ALTER COLUMN address_type DROP DEFAULT;

ALTER TABLE "user" 
ADD COLUMN correspondence_address_id INT,
ADD CONSTRAINT FK_User_Correspondence_Address FOREIGN KEY (correspondence_address_id) REFERENCES correspondence_address (id);

ALTER TABLE signup_checkpoints 
ADD COLUMN correspondence_address_id INT,
ADD CONSTRAINT FK_Checkpoint_Correspondence_Address FOREIGN KEY (correspondence_address_id) REFERENCES correspondence_address (id);

ALTER TABLE "user" 
ADD COLUMN office_tel_num VARCHAR(15),      
ADD COLUMN residence_tel_num VARCHAR(15);

ALTER TABLE signup_checkpoints 
ADD COLUMN office_tel_num VARCHAR(15),     
ADD COLUMN residence_tel_num VARCHAR(15);   

ALTER TABLE "user"
ADD COLUMN is_us_person yes_no NOT NULL DEFAULT 'NO',
ADD COLUMN country_of_residence country_enum NOT NULL DEFAULT 'INDIA',
ADD COLUMN country_of_citizenship country_enum NOT NULL DEFAULT 'INDIA',
ADD COLUMN user_account_type user_account_type NOT NULL DEFAULT 'Individual';

ALTER TABLE "user"
    ALTER COLUMN is_us_person DROP DEFAULT,
    ALTER COLUMN country_of_residence DROP DEFAULT,
    ALTER COLUMN country_of_citizenship DROP DEFAULT,
    ALTER COLUMN user_account_type DROP DEFAULT;

