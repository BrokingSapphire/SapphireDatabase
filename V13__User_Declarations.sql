CREATE TYPE contract_note_type AS ENUM ('Electronic', 'Physical');
CREATE TYPE annual_report_type AS ENUM ('Electronic', 'Physical', 'Both');
CREATE TYPE dp_settlement AS ENUM ('Monthly', 'Fortnightly', 'Weekly', 'As per SEBI regulations');
CREATE TYPE declaration_relation AS ENUM ('Self', 'Spouse', 'Child', 'Parent');
CREATE TYPE email_declaration AS ENUM ('Self', 'Spouse', 'Child', 'Parent', 'Do not have');
CREATE TYPE client_category_commercial_non_commercial AS ENUM ('Value Chain Participation', 'Exporter', 'Importer', 'Hedger' , 'Financial Participation', 'Trader' , 'Arbitrager' , 'Other');
CREATE TYPE business_categorization AS ENUM ('B2B', 'D2C');

ALTER TABLE "user"
ADD COLUMN contract_note_type contract_note_type NOT NULL DEFAULT 'Electronic',
ADD COLUMN dis_facility yes_no NOT NULL DEFAULT 'NO',
ADD COLUMN email_with_registrar yes_no NOT NULL DEFAULT 'YES',
ADD COLUMN annual_report_type annual_report_type NOT NULL DEFAULT 'Electronic',
ADD COLUMN dp_account_settlement dp_settlement NOT NULL DEFAULT 'As per SEBI regulations',
ADD COLUMN mobile_declaration declaration_relation NOT NULL DEFAULT 'Self',
ADD COLUMN email_declaration email_declaration NOT NULL DEFAULT 'Self',

ADD COLUMN internet_trading_facility yes_no NOT NULL DEFAULT 'YES',
ADD COLUMN margin_trading_facility yes_no NOT NULL DEFAULT 'YES',
ADD COLUMN bsda_facility yes_no NOT NULL DEFAULT 'NO';


ALTER TABLE "user"
    ALTER COLUMN contract_note_type DROP DEFAULT,
    ALTER COLUMN dis_facility DROP DEFAULT,
    ALTER COLUMN email_with_registrar DROP DEFAULT,
    ALTER COLUMN annual_report_type DROP DEFAULT,
    ALTER COLUMN dp_account_settlement DROP DEFAULT,
    ALTER COLUMN mobile_declaration DROP DEFAULT,
    ALTER COLUMN email_declaration DROP DEFAULT,
    ALTER COLUMN internet_trading_facility DROP DEFAULT,
    ALTER COLUMN margin_trading_facility DROP DEFAULT,
    ALTER COLUMN bsda_facility DROP DEFAULT;


ALTER TABLE "user"
ADD COLUMN client_category_commercial_non_commercial client_category_commercial_non_commercial NOT NULL DEFAULT 'Other',
ADD COLUMN past_actions yes_no NOT NULL DEFAULT 'NO';

ALTER TABLE "user"
    ALTER COLUMN client_category_commercial_non_commercial DROP DEFAULT,
    ALTER COLUMN past_actions DROP DEFAULT;

CREATE TABLE gst_registration (
    id SERIAL,
    register_no VARCHAR(15),  
    validity_date DATE,          
    state_name VARCHAR(50),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_GST_Registration_Id PRIMARY KEY (id),
    CONSTRAINT UQ_GST_Register_No UNIQUE (register_no),
    CONSTRAINT CHK_GST_Register_No_Format CHECK (register_no ~ '^[0-9]{2}[A-Z0-9]{13}$'),
    CONSTRAINT CHK_Validity_Date CHECK (validity_date > CURRENT_DATE)
);

ALTER TABLE "user"
ADD COLUMN gst_registration_id INT,
ADD CONSTRAINT FK_User_GST_Registration FOREIGN KEY (gst_registration_id) REFERENCES gst_registration (id);

ALTER TABLE "user"
ADD COLUMN business_categorization business_categorization NOT NULL DEFAULT 'D2C';

ALTER TABLE "user"
    ALTER COLUMN business_categorization DROP DEFAULT;