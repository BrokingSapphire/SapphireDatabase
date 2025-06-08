ALTER TABLE "user"
    ADD COLUMN new_id CHAR(6);

DO $$
DECLARE
    user_record RECORD;
BEGIN
    -- Loop through all users ordered by their CLI number to maintain sequence
    -- Extract numeric part from CLI format (CLI0000001 -> 1, CLI0000002 -> 2, etc.)
    FOR user_record IN
        SELECT id, RIGHT(id, 7)::INTEGER as cli_num
        FROM "user"
        WHERE id LIKE 'CLI%'
        ORDER BY RIGHT(id, 7)::INTEGER
    LOOP
        UPDATE "user"
        SET new_id = generate_next_user_id()
        WHERE id = user_record.id;
    END LOOP;

    -- Handle any users that don't follow CLI format (if any exist)
    FOR user_record IN
        SELECT id FROM "user"
        WHERE id NOT LIKE 'CLI%' AND new_id IS NULL
        ORDER BY id
    LOOP
        UPDATE "user"
        SET new_id = generate_next_user_id()
        WHERE id = user_record.id;
    END LOOP;
END $$;


ALTER TABLE bank_to_user
    DROP CONSTRAINT FK_Bank_User,
    DROP CONSTRAINT PK_Bank_User;

ALTER TABLE nominees_to_user
    DROP CONSTRAINT FK_Nominees_To_User_User_Id,
    DROP CONSTRAINT PK_Nominees_To_User;

ALTER TABLE user_password_details
    DROP CONSTRAINT FK_User_Login_Id,
    DROP CONSTRAINT PK_User_Login_Id;

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

ALTER TABLE investment_segments_to_user
    DROP CONSTRAINT FK_User_Segment_To_User,
    DROP CONSTRAINT PK_User_Segment;

ALTER TABLE profile_pictures
    DROP CONSTRAINT FK_User_To_Profile_Pictures;

ALTER TABLE account_deletions
    DROP CONSTRAINT FK_Account_Deletions_User;

ALTER TABLE user_preferences
    DROP CONSTRAINT FK_User_Preferences_User,
    DROP CONSTRAINT UQ_User_Preferences_User;


ALTER TABLE bank_to_user
    ADD COLUMN new_user_id CHAR(6);

ALTER TABLE nominees_to_user
    ADD COLUMN new_user_id CHAR(6);

ALTER TABLE user_password_details
    ADD COLUMN new_user_id CHAR(6);

ALTER TABLE user_sessions
    ADD COLUMN new_user_id CHAR(6);

ALTER TABLE user_balance
    ADD COLUMN new_user_id CHAR(6);

ALTER TABLE balance_transactions
    ADD COLUMN new_user_id CHAR(6);

ALTER TABLE compliance_processing
    ADD COLUMN new_officer_id CHAR(6);

ALTER TABLE user_watchlist
    ADD COLUMN new_user_id CHAR(6);

ALTER TABLE investment_segments_to_user
    ADD COLUMN new_user_id CHAR(6);

ALTER TABLE profile_pictures
    ADD COLUMN new_user_id CHAR(6);

ALTER TABLE account_deletions
    ADD COLUMN new_user_id CHAR(6);

ALTER TABLE user_preferences
    ADD COLUMN new_user_id CHAR(6);

ALTER TABLE signup_checkpoints
    ADD COLUMN new_client_id CHAR(6);


UPDATE bank_to_user btu
SET new_user_id = u.new_id
FROM "user" u
WHERE btu.user_id = u.id;

UPDATE nominees_to_user ntu
SET new_user_id = u.new_id
FROM "user" u
WHERE ntu.user_id = u.id;

UPDATE user_password_details upd
SET new_user_id = u.new_id
FROM "user" u
WHERE upd.user_id = u.id;

UPDATE user_sessions us
SET new_user_id = u.new_id
FROM "user" u
WHERE us.user_id = u.id;

UPDATE user_balance ub
SET new_user_id = u.new_id
FROM "user" u
WHERE ub.user_id = u.id;

UPDATE balance_transactions bt
SET new_user_id = u.new_id
FROM "user" u
WHERE bt.user_id = u.id;

UPDATE compliance_processing cp
SET new_officer_id = u.new_id
FROM "user" u
WHERE cp.officer_id = u.id;

UPDATE user_watchlist uw
SET new_user_id = u.new_id
FROM "user" u
WHERE uw.user_id = u.id;

UPDATE investment_segments_to_user istu
SET new_user_id = u.new_id
FROM "user" u
WHERE istu.user_id = u.id;

UPDATE profile_pictures pp
SET new_user_id = u.new_id
FROM "user" u
WHERE pp.user_id = u.id;

UPDATE account_deletions ad
SET new_user_id = u.new_id
FROM "user" u
WHERE ad.user_id = u.id;

UPDATE user_preferences up
SET new_user_id = u.new_id
FROM "user" u
WHERE up.user_id = u.id;

UPDATE signup_checkpoints sc
SET new_client_id = u.new_id
FROM "user" u
WHERE sc.new_client_id = u.id;


ALTER TABLE bank_to_user
    ALTER COLUMN new_user_id SET NOT NULL;

ALTER TABLE nominees_to_user
    ALTER COLUMN new_user_id SET NOT NULL;

ALTER TABLE user_password_details
    ALTER COLUMN new_user_id SET NOT NULL;

ALTER TABLE user_sessions
    ALTER COLUMN new_user_id SET NOT NULL;

ALTER TABLE user_balance
    ALTER COLUMN new_user_id SET NOT NULL;

ALTER TABLE balance_transactions
    ALTER COLUMN new_user_id SET NOT NULL;

ALTER TABLE compliance_processing
    ALTER COLUMN new_officer_id SET NOT NULL;

ALTER TABLE user_watchlist
    ALTER COLUMN new_user_id SET NOT NULL;

ALTER TABLE investment_segments_to_user
    ALTER COLUMN new_user_id SET NOT NULL;

ALTER TABLE profile_pictures
    ALTER COLUMN new_user_id SET NOT NULL;

ALTER TABLE account_deletions
    ALTER COLUMN new_user_id SET NOT NULL;

ALTER TABLE user_preferences
    ALTER COLUMN new_user_id SET NOT NULL;

ALTER TABLE signup_checkpoints
    ALTER COLUMN new_client_id SET NOT NULL;


ALTER TABLE "user"
    DROP CONSTRAINT PK_User_Id;

ALTER TABLE "user"
    DROP COLUMN id,
    ALTER COLUMN new_id SET NOT NULL;

ALTER TABLE "user"
    RENAME COLUMN new_id TO id;

-- Add primary key constraint
ALTER TABLE "user"
    ADD CONSTRAINT PK_User_Id PRIMARY KEY (id);


ALTER TABLE bank_to_user
    DROP COLUMN user_id;
ALTER TABLE bank_to_user
    RENAME COLUMN new_user_id TO user_id;

ALTER TABLE nominees_to_user
    DROP COLUMN user_id;
ALTER TABLE nominees_to_user
    RENAME COLUMN new_user_id TO user_id;

ALTER TABLE user_password_details
    DROP COLUMN user_id;
ALTER TABLE user_password_details
    RENAME COLUMN new_user_id TO user_id;

ALTER TABLE user_sessions
    DROP COLUMN user_id;
ALTER TABLE user_sessions
    RENAME COLUMN new_user_id TO user_id;

ALTER TABLE user_balance
    DROP COLUMN user_id;
ALTER TABLE user_balance
    RENAME COLUMN new_user_id TO user_id;

ALTER TABLE balance_transactions
    DROP COLUMN user_id;
ALTER TABLE balance_transactions
    RENAME COLUMN new_user_id TO user_id;

ALTER TABLE compliance_processing
    DROP COLUMN officer_id;
ALTER TABLE compliance_processing
    RENAME COLUMN new_officer_id TO officer_id;

ALTER TABLE user_watchlist
    DROP COLUMN user_id;
ALTER TABLE user_watchlist
    RENAME COLUMN new_user_id TO user_id;

ALTER TABLE investment_segments_to_user
    DROP COLUMN user_id;
ALTER TABLE investment_segments_to_user
    RENAME COLUMN new_user_id TO user_id;

ALTER TABLE profile_pictures
    DROP COLUMN user_id;
ALTER TABLE profile_pictures
    RENAME COLUMN new_user_id TO user_id;

ALTER TABLE account_deletions
    DROP COLUMN user_id;
ALTER TABLE account_deletions
    RENAME COLUMN new_user_id TO user_id;

ALTER TABLE user_preferences
    DROP COLUMN user_id;
ALTER TABLE user_preferences
    RENAME COLUMN new_user_id TO user_id;

ALTER TABLE signup_checkpoints
    DROP COLUMN client_id;
ALTER TABLE signup_checkpoints
    RENAME COLUMN new_client_id TO client_id;


ALTER TABLE bank_to_user
    ADD CONSTRAINT PK_Bank_User PRIMARY KEY (user_id, bank_account_id),
    ADD CONSTRAINT FK_Bank_User FOREIGN KEY (user_id) REFERENCES "user" (id);

ALTER TABLE nominees_to_user
    ADD CONSTRAINT PK_Nominees_To_User PRIMARY KEY (user_id, nominees_id),
    ADD CONSTRAINT FK_Nominees_To_User_User_Id FOREIGN KEY (user_id) REFERENCES "user" (id);

ALTER TABLE user_password_details
    ADD CONSTRAINT PK_User_Login_Id PRIMARY KEY (user_id),
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
    ADD CONSTRAINT UQ_User_Watchlist_Position UNIQUE (user_id, position_index) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE investment_segments_to_user
    ADD CONSTRAINT PK_User_Segment PRIMARY KEY (user_id, segment),
    ADD CONSTRAINT FK_User_Segment_To_User FOREIGN KEY (user_id) REFERENCES "user" (id);

ALTER TABLE profile_pictures
    ADD CONSTRAINT FK_User_To_Profile_Pictures FOREIGN KEY (user_id) REFERENCES "user" (id);

ALTER TABLE account_deletions
    ADD CONSTRAINT FK_Account_Deletions_User FOREIGN KEY (user_id) REFERENCES "user" (id);

ALTER TABLE user_preferences
    ADD CONSTRAINT FK_User_Preferences_User FOREIGN KEY (user_id) REFERENCES "user" (id),
    ADD CONSTRAINT UQ_User_Preferences_User UNIQUE (user_id);