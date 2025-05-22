ALTER TABLE "user"
    ADD COLUMN new_id VARCHAR(10);

UPDATE "user"
SET new_id = 'CLI' || LPAD(id::TEXT, 7, '0');

ALTER TABLE bank_to_user
    DROP CONSTRAINT FK_Bank_User;

ALTER TABLE nominees_to_user
    DROP CONSTRAINT FK_Nominees_To_User_User_Id;

ALTER TABLE user_password_details
    DROP CONSTRAINT FK_User_Login_Id;

ALTER TABLE user_sessions
    DROP CONSTRAINT FK_User_Session_User;

ALTER TABLE user_balance
    DROP CONSTRAINT FK_User_Balance;

ALTER TABLE balance_transactions
    DROP CONSTRAINT FK_Balance_Transaction_User;

ALTER TABLE compliance_processing
    DROP CONSTRAINT FK_Officer_Compliance_Id;

ALTER TABLE user_watchlist
    DROP CONSTRAINT FK_User_Watchlist_User,
    DROP CONSTRAINT UQ_User_Watchlist,
    DROP CONSTRAINT UQ_User_Watchlist_Position;

ALTER TABLE bank_to_user
    ADD COLUMN new_user_id_varchar VARCHAR(10);

ALTER TABLE nominees_to_user
    ADD COLUMN new_user_id_varchar VARCHAR(10);

ALTER TABLE user_password_details
    ADD COLUMN new_user_id_varchar VARCHAR(10);

ALTER TABLE user_sessions
    ADD COLUMN new_user_id_varchar VARCHAR(10);

ALTER TABLE user_balance
    ADD COLUMN new_user_id_varchar VARCHAR(10);

ALTER TABLE balance_transactions
    ADD COLUMN new_user_id_varchar VARCHAR(10);

ALTER TABLE compliance_processing
    ADD COLUMN new_user_id_varchar VARCHAR(10);

ALTER TABLE user_watchlist
    ADD COLUMN new_user_id_varchar VARCHAR(10);

UPDATE bank_to_user btu
SET new_user_id_varchar = u.new_id
FROM "user" u
WHERE btu.user_id = u.id;

UPDATE nominees_to_user ntu
SET new_user_id_varchar = u.new_id
FROM "user" u
WHERE ntu.user_id = u.id;

UPDATE user_password_details upd
SET new_user_id_varchar = u.new_id
FROM "user" u
WHERE upd.user_id = u.id;

UPDATE user_sessions us
SET new_user_id_varchar = u.new_id
FROM "user" u
WHERE us.user_id = u.id;

UPDATE user_balance ub
SET new_user_id_varchar = u.new_id
FROM "user" u
WHERE ub.user_id = u.id;

UPDATE balance_transactions bt
SET new_user_id_varchar = u.new_id
FROM "user" u
WHERE bt.user_id = u.id;

UPDATE compliance_processing cp
SET new_user_id_varchar = u.new_id
FROM "user" u
WHERE cp.officer_id = u.id;

UPDATE user_watchlist usw
SET new_user_id_varchar = u.new_id
FROM "user" u
WHERE usw.user_id = u.id;

ALTER TABLE "user"
    DROP CONSTRAINT PK_User_Id;

ALTER TABLE "user"
    DROP COLUMN id;

ALTER TABLE "user"
    RENAME COLUMN new_id TO id;

ALTER TABLE "user"
    ADD PRIMARY KEY (id);

ALTER TABLE bank_to_user
    DROP COLUMN user_id;

ALTER TABLE nominees_to_user
    DROP COLUMN user_id;

ALTER TABLE user_password_details
    DROP COLUMN user_id;

ALTER TABLE user_sessions
    DROP COLUMN user_id;

ALTER TABLE user_balance
    DROP COLUMN user_id;

ALTER TABLE balance_transactions
    DROP COLUMN user_id;

ALTER TABLE compliance_processing
    DROP COLUMN officer_id;

ALTER TABLE user_watchlist
    DROP COLUMN user_id;

ALTER TABLE bank_to_user
    RENAME COLUMN new_user_id_varchar TO user_id;

ALTER TABLE nominees_to_user
    RENAME COLUMN new_user_id_varchar TO user_id;

ALTER TABLE user_password_details
    RENAME COLUMN new_user_id_varchar TO user_id;

ALTER TABLE user_sessions
    RENAME COLUMN new_user_id_varchar TO user_id;

ALTER TABLE user_balance
    RENAME COLUMN new_user_id_varchar TO user_id;

ALTER TABLE balance_transactions
    RENAME COLUMN new_user_id_varchar TO user_id;

ALTER TABLE compliance_processing
    RENAME COLUMN new_user_id_varchar TO officer_id;

ALTER TABLE user_watchlist
    RENAME COLUMN new_user_id_varchar TO user_id;

ALTER TABLE bank_to_user
    ADD CONSTRAINT FK_Bank_User FOREIGN KEY (user_id) REFERENCES "user" (id);

ALTER TABLE nominees_to_user
    ADD CONSTRAINT FK_Nominees_To_User_User_Id FOREIGN KEY (user_id) REFERENCES "user" (id);

ALTER TABLE user_password_details
    ADD CONSTRAINT FK_User_Login_Id FOREIGN KEY (user_id) REFERENCES "user" (id);

ALTER TABLE user_sessions
    ADD CONSTRAINT FK_User_Session_User FOREIGN KEY (user_id) REFERENCES "user" (id);

ALTER TABLE user_balance
    ADD CONSTRAINT FK_User_Balance FOREIGN KEY (user_id) REFERENCES "user" (id);

ALTER TABLE balance_transactions
    ADD CONSTRAINT FK_Balance_Transaction_User FOREIGN KEY (user_id) REFERENCES "user" (id);

ALTER TABLE compliance_processing
    ADD CONSTRAINT FK_Officer_Compliance_Id FOREIGN KEY (officer_id) REFERENCES "user" (id);

ALTER TABLE user_watchlist
    ADD CONSTRAINT FK_User_Watchlist_User FOREIGN KEY (user_id) REFERENCES "user" (id),
    ADD CONSTRAINT UQ_User_Watchlist UNIQUE (user_id, watchlist_id),
    ADD CONSTRAINT UQ_User_Watchlist_Position UNIQUE (user_id, position_index);
