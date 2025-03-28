-- V1_User_Tables

-- Enums
CREATE TYPE user_annual_income AS ENUM ('le_1_Lakh', '1_5_Lakh', '5_10_Lakh', '10_25_Lakh', '25_1_Cr', 'Ge_1_Cr');
CREATE TYPE user_trading_exp AS ENUM ('1', '1-5', '5-10', '10');
CREATE TYPE user_settlement AS ENUM ('Quarterly', 'Monthly');
CREATE TYPE user_investment_segment AS ENUM ('Cash', 'F&O', 'Debt', 'Currency', 'Commodity');
CREATE TYPE user_marital_status AS ENUM ('Single', 'Married', 'Divorced');

-- Address
CREATE TABLE country
(
    iso  VARCHAR(3)  NOT NULL,
    name VARCHAR(20) NOT NULL,
    CONSTRAINT PK_Country_Iso PRIMARY KEY (iso),
    CONSTRAINT UQ_Country_Name UNIQUE (name)
);

CREATE TABLE state
(
    id         SERIAL,
    name       VARCHAR(30) NOT NULL,
    country_id VARCHAR(3)  NOT NULL,
    CONSTRAINT PK_State_Id PRIMARY KEY (id),
    CONSTRAINT FK_State_Room FOREIGN KEY (country_id) REFERENCES country (iso),
    CONSTRAINT UQ_State_Country UNIQUE (name, country_id)
);

CREATE TABLE city
(
    id       SERIAL,
    name     VARCHAR(50) NOT NULL,
    state_id INT         NOT NULL,
    CONSTRAINT PK_City_Id PRIMARY KEY (id),
    CONSTRAINT FK_City_State FOREIGN KEY (state_id) REFERENCES state (id),
    CONSTRAINT UQ_City_State UNIQUE (name, state_id)
);

CREATE TABLE postal_code
(
    id          SERIAL,
    country_id  VARCHAR(3) NOT NULL,
    postal_code VARCHAR(8) NOT NULL,
    CONSTRAINT PK_Postal_Code_Id PRIMARY KEY (id),
    CONSTRAINT UQ_Postal_Country UNIQUE (country_id, postal_code)
);

CREATE TABLE address
(
    id          SERIAL,
    address1    TEXT       NOT NULL,
    address2    TEXT,
    street_name VARCHAR(100),
    country_id  VARCHAR(3) NOT NULL,
    state_id    INT        NOT NULL,
    city_id     INT        NOT NULL,
    postal_id   INT        NOT NULL,
    CONSTRAINT PK_Address_Id PRIMARY KEY (id),
    CONSTRAINT FK_Address_Country FOREIGN KEY (country_id) REFERENCES country (iso),
    CONSTRAINT FK_Address_State FOREIGN KEY (state_id) REFERENCES state (id),
    CONSTRAINT FK_Address_City FOREIGN KEY (city_id) REFERENCES city (id),
    CONSTRAINT FK_Address_Postal FOREIGN KEY (postal_id) REFERENCES postal_code (id),
    CONSTRAINT UQ_Address UNIQUE (address1, address2, country_id, state_id, city_id, postal_id)
);

-- user
CREATE TABLE ip_address
(
    id      SERIAL,
    address INET NOT NULL,
    CONSTRAINT PK_Ip_Address_Id PRIMARY KEY (id),
    CONSTRAINT UQ_Ip_Address UNIQUE (address)
);

CREATE TABLE user_name
(
    id          SERIAL,
    first_name  VARCHAR(30) NOT NULL,
    middle_name VARCHAR(30),
    last_name   VARCHAR(30),
    full_name   VARCHAR(92) GENERATED ALWAYS AS (TRIM(first_name || ' ' || COALESCE(middle_name || ' ', '') ||
                                                      COALESCE(last_name, ''))) STORED,
    CONSTRAINT PK_User_Name_Id PRIMARY KEY (id),
    CONSTRAINT UQ_User_Name UNIQUE (first_name, middle_name, last_name)
);

CREATE TABLE profile_pictures
(
    id      SERIAL,
    data    TEXT NOT NULL,
    user_id INT  NOT NULL,
    CONSTRAINT PK_Profile_Picture_Id PRIMARY KEY (id)
);

CREATE TABLE bank_account
(
    id         SERIAL,
    account_no VARCHAR(18) NOT NULL,
    ifsc_code  VARCHAR(11) NOT NULL,
    CONSTRAINT PK_Bank_Account_Id PRIMARY KEY (id),
    CONSTRAINT UQ_Bank_Account UNIQUE (account_no, ifsc_code)
);

CREATE TABLE phone_number
(
    id    SERIAL,
    phone VARCHAR(10) NOT NULL,
    CONSTRAINT PK_Phone_Number_Id PRIMARY KEY (id),
    CONSTRAINT UQ_Phone UNIQUE (phone)
);

CREATE TABLE aadhaar_detail
(
    id                SERIAL,
    masked_aadhaar_no VARCHAR(4)  NOT NULL,
    name              INT         NOT NULL,
    dob               DATE,
    co                INT         NOT NULL,
    address_id        INT         NOT NULL,
    post_office       VARCHAR(30) NOT NULL,
    gender            VARCHAR(1)  NOT NULL,
    created_at        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_Aadhaar_Id PRIMARY KEY (id),
    CONSTRAINT FK_Aadhaar_Name FOREIGN KEY (name) REFERENCES user_name (id),
    CONSTRAINT FK_Aadhaar_CO FOREIGN KEY (co) REFERENCES user_name (id),
    CONSTRAINT FK_Aadhaar_Address FOREIGN KEY (address_id) REFERENCES address (id),
    CONSTRAINT UQ_Aadhaar UNIQUE (masked_aadhaar_no, name, dob, co, address_id, post_office, gender),
    CONSTRAINT CHK_DOB CHECK (dob > '1900-01-01' AND dob < CURRENT_DATE)
);

CREATE TABLE pan_detail
(
    id             SERIAL,
    pan_number     VARCHAR(10) NOT NULL,
    name           INT         NOT NULL,
    masked_aadhaar VARCHAR(4)  NOT NULL,
    address_id     INT         NOT NULL,
    dob            DATE        NOT NULL,
    gender         VARCHAR(1)  NOT NULL,
    aadhaar_linked BOOLEAN     NOT NULL,
    dob_verified   BOOLEAN     NOT NULL,
    dob_check      BOOLEAN     NOT NULL,
    category       VARCHAR(20) NOT NULL,
    status         VARCHAR(20) NOT NULL,
    created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_Pan_Detail_Id PRIMARY KEY (id),
    CONSTRAINT FK_Pan_Name FOREIGN KEY (name) REFERENCES user_name (id),
    CONSTRAINT FK_Pan_Address FOREIGN KEY (address_id) REFERENCES address (id),
    CONSTRAINT UQ_Pan_Number UNIQUE (pan_number),
    CONSTRAINT CHK_DOB CHECK (dob > '1900-01-01' AND dob < CURRENT_DATE)
);

CREATE TABLE razorpay_data
(
    order_id   VARCHAR(22) NOT NULL,
    payment_id VARCHAR(20) NOT NULL,
    signature  VARCHAR(64) NOT NULL,
    CONSTRAINT PK_RazorPayOrder PRIMARY KEY (order_id),
    CONSTRAINT UQ_RazorPayPayment UNIQUE (payment_id),
    CONSTRAINT UQ_RazorPaySignature UNIQUE (signature)
);

CREATE TABLE "user"
(
    id                     INT                 NOT NULL,
    email                  VARCHAR(100)        NOT NULL,
    name                   INT                 NOT NULL,
    dob                    DATE                NOT NULL,
    pan_id                 INT                 NOT NULL,
    aadhaar_id             INT                 NOT NULL,
    address_id             INT                 NOT NULL,
    phone                  INT                 NOT NULL,
    father_name            INT                 NOT NULL,
    mother_name            INT                 NOT NULL,
    ipv                    TEXT                NOT NULL,
    signature              TEXT                NOT NULL,
    marital_status         user_marital_status NOT NULL,
    occupation             VARCHAR(30)         NOT NULL,
    is_politically_exposed BOOLEAN             NOT NULL DEFAULT FALSE,
    annual_income          user_annual_income  NOT NULL,
    trading_exp            user_trading_exp    NOT NULL,
    account_settlement     user_settlement     NOT NULL,
    is_password_changed    BOOLEAN             NOT NULL DEFAULT FALSE,
    created_at             TIMESTAMP           NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at             TIMESTAMP           NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_User_Id PRIMARY KEY (id),
    CONSTRAINT FK_User_Name FOREIGN KEY (name) REFERENCES user_name (id),
    CONSTRAINT FK_User_Pan FOREIGN KEY (pan_id) REFERENCES pan_detail (id),
    CONSTRAINT FK_User_Aadhaar FOREIGN KEY (aadhaar_id) REFERENCES aadhaar_detail (id),
    CONSTRAINT FK_User_Address FOREIGN KEY (address_id) REFERENCES address (id),
    CONSTRAINT FK_User_Phone_Number FOREIGN KEY (phone) REFERENCES phone_number (id),
    CONSTRAINT FK_User_Father_Name FOREIGN KEY (father_name) REFERENCES user_name (id),
    CONSTRAINT FK_User_Mother_Name FOREIGN KEY (mother_name) REFERENCES user_name (id),
    CONSTRAINT UQ_User_Email UNIQUE (email),
    CONSTRAINT UQ_User_Pan UNIQUE (pan_id),
    CONSTRAINT UQ_User_Aadhaar UNIQUE (aadhaar_id),
    CONSTRAINT UQ_User_Address UNIQUE (address_id),
    CONSTRAINT UQ_Phone_Number UNIQUE (phone),
    CONSTRAINT CHK_Email CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
    CONSTRAINT CHK_DOB CHECK (dob > '1900-01-01' AND dob < CURRENT_DATE)
);

CREATE TABLE bank_to_user
(
    user_id         INT     NOT NULL,
    bank_account_id INT     NOT NULL,
    is_primary      BOOLEAN NOT NULL DEFAULT FALSE,
    CONSTRAINT PK_Bank_User PRIMARY KEY (user_id, bank_account_id),
    CONSTRAINT FK_Bank_User FOREIGN KEY (user_id) REFERENCES "user" (id),
    CONSTRAINT FK_Bank_Account FOREIGN KEY (bank_account_id) REFERENCES bank_account (id)
);

CREATE TABLE nominees
(
    id           SERIAL,
    name         INT         NOT NULL,
    pan_id       INT         NOT NULL,
    aadhaar_id   INT         NOT NULL,
    relationship VARCHAR(10) NOT NULL,
    share        FLOAT4      NOT NULL,
    CONSTRAINT PK_Nominees_Id PRIMARY KEY (id),
    CONSTRAINT FK_Nominees_Name FOREIGN KEY (name) REFERENCES user_name (id),
    CONSTRAINT FK_Nominees_Pan FOREIGN KEY (pan_id) REFERENCES pan_detail (id),
    CONSTRAINT FK_Nominees_Aadhaar FOREIGN KEY (aadhaar_id) REFERENCES aadhaar_detail (id)
);

CREATE TABLE nominees_to_user
(
    user_id     INT NOT NULL,
    nominees_id INT NOT NULL,
    CONSTRAINT PK_Nominees_To_User PRIMARY KEY (user_id, nominees_id),
    CONSTRAINT FK_Nominees_To_User_User_Id FOREIGN KEY (user_id) REFERENCES "user" (id),
    CONSTRAINT FK_Nominees_To_User_Nominees_Id FOREIGN KEY (nominees_id) REFERENCES nominees (id)
);

-- Authentication
CREATE TABLE hashing_algorithm
(
    id   SERIAL      NOT NULL,
    name VARCHAR(10) NOT NULL,
    CONSTRAINT PK_Hashing_Algo_Id PRIMARY KEY (id),
    CONSTRAINT UQ_Hashing_Algo_Name UNIQUE (name)
);

CREATE TABLE user_password_details
(
    user_id       INT          NOT NULL,
    password_hash VARCHAR(250) NOT NULL,
    password_salt VARCHAR(100) NOT NULL,
    hash_algo_id  INT          NOT NULL,
    CONSTRAINT PK_User_Login_Id PRIMARY KEY (user_id),
    CONSTRAINT FK_User_Login_Id FOREIGN KEY (user_id) REFERENCES "user" (id),
    CONSTRAINT FK_Hash_Algo_Id FOREIGN KEY (hash_algo_id) REFERENCES hashing_algorithm (id),
    CONSTRAINT UQ_User_Password_Hash UNIQUE (password_hash),
    CONSTRAINT UQ_User_Password_Salt UNIQUE (password_salt)
);

CREATE TABLE investment_segments_to_user
(
    user_id INT                     NOT NULL,
    segment user_investment_segment NOT NULL,
    CONSTRAINT PK_User_Segment PRIMARY KEY (user_id, segment)
);

-- Checkpoints
CREATE TABLE signup_checkpoints
(
    id                     SERIAL,
    phone_id               INT          NOT NULL,
    email                  VARCHAR(100) NOT NULL,
    payment_id             VARCHAR(22)  NOT NULL,
    name                   INT,
    dob                    DATE,
    pan_id                 INT,
    aadhaar_id             INT,
    address_id             INT,
    marital_status         user_marital_status,
    father_name            INT,
    mother_name            INT,
    ipv                    TEXT,
    signature              TEXT,
    annual_income          user_annual_income,
    trading_exp            user_trading_exp,
    account_settlement     user_settlement,
    occupation             VARCHAR(30),
    is_politically_exposed BOOLEAN,
    created_at             TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at             TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_Checkpoint_Id PRIMARY KEY (id),
    CONSTRAINT FK_Checkpoint_User_Name FOREIGN KEY (name) REFERENCES user_name (id),
    CONSTRAINT FK_Checkpoint_User_Pan FOREIGN KEY (pan_id) REFERENCES pan_detail (id),
    CONSTRAINT FK_Checkpoint_User_Aadhaar FOREIGN KEY (aadhaar_id) REFERENCES aadhaar_detail (id),
    CONSTRAINT FK_Checkpoint_User_Address FOREIGN KEY (address_id) REFERENCES address (id),
    CONSTRAINT FK_Checkpoint_User_Phone_Number FOREIGN KEY (phone_id) REFERENCES phone_number (id),
    CONSTRAINT FK_Checkpoint_User_Payment FOREIGN KEY (payment_id) REFERENCES razorpay_data (order_id),
    CONSTRAINT FK_Checkpoint_User_Father_Name FOREIGN KEY (father_name) REFERENCES user_name (id),
    CONSTRAINT FK_Checkpoint_User_Mother_Name FOREIGN KEY (mother_name) REFERENCES user_name (id)
);

CREATE TABLE nominees_to_checkpoint
(
    checkpoint_id INT NOT NULL,
    nominees_id   INT NOT NULL,
    CONSTRAINT PK_Nominees_To_Checkpoint_Id PRIMARY KEY (checkpoint_id, nominees_id),
    CONSTRAINT FK_Nominees_To_Checkpoint_Checkpoint_Id FOREIGN KEY (checkpoint_id) REFERENCES signup_checkpoints (id),
    CONSTRAINT FK_Nominees_To_Checkpoint_Nominees_Id FOREIGN KEY (nominees_id) REFERENCES nominees (id)
);

CREATE TABLE bank_to_checkpoint
(
    checkpoint_id   INT     NOT NULL,
    bank_account_id INT     NOT NULL,
    is_primary      BOOLEAN NOT NULL DEFAULT FALSE,
    CONSTRAINT PK_Bank_Checkpoint PRIMARY KEY (checkpoint_id, bank_account_id),
    CONSTRAINT FK_Bank_Checkpoint FOREIGN KEY (checkpoint_id) REFERENCES signup_checkpoints (id),
    CONSTRAINT FK_Checkpoint_Bank_Account FOREIGN KEY (bank_account_id) REFERENCES bank_account (id)
);

CREATE TABLE investment_segments_to_checkpoint
(
    checkpoint_id INT                     NOT NULL,
    segment       user_investment_segment NOT NULL,
    CONSTRAINT PK_User_Checkpoint_Segment PRIMARY KEY (checkpoint_id, segment)
);

-- Sessions
CREATE TABLE user_sessions
(
    id            SERIAL,
    user_id       INT       NOT NULL,
    ip_address    INET      NOT NULL,
    user_agent    TEXT,
    device_info   JSONB,
    session_start TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    last_activity TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    session_end   TIMESTAMP,
    is_active     BOOLEAN            DEFAULT TRUE,
    location_data JSONB,
    CONSTRAINT PK_User_Session_Id PRIMARY KEY (id),
    CONSTRAINT FK_User_Session_User FOREIGN KEY (user_id) REFERENCES "user" (id),
    CONSTRAINT CHK_Session_Dates CHECK (
        session_start <= last_activity
            AND (session_end IS NULL OR last_activity <= session_end)
        )
);