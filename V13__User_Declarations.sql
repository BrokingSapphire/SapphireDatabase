CREATE TYPE contract_note_type AS ENUM ('Electronic', 'Physical');
CREATE TYPE annual_report_type AS ENUM ('Electronic', 'Physical', 'Both');
CREATE TYPE dp_settlement AS ENUM ('Monthly', 'Fortnightly', 'Weekly', 'As per SEBI regulations');
CREATE TYPE declaration_relation AS ENUM ('Self', 'Spouse', 'Child', 'Parent');
CREATE TYPE email_declaration AS ENUM ('Self', 'Spouse', 'Child', 'Parent', 'Do not have');


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