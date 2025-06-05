CREATE TABLE id_counter (
    id_type VARCHAR(10) PRIMARY KEY,
    current_id VARCHAR(6) NOT NULL,
    CONSTRAINT check_id_type_length CHECK (LENGTH(TRIM(id_type)) > 0)
);

INSERT INTO id_counter (id_type, current_id)
VALUES ('user_id', 'AA0000');

-- Function to generate next incremental ID
CREATE OR REPLACE FUNCTION generate_next_user_id()
RETURNS CHAR(6)
LANGUAGE plpgsql
AS $$
DECLARE
    current_full_id CHAR(6);
    current_alpha CHAR(2);
    current_num SMALLINT;
    new_alpha CHAR(2);
    new_num SMALLINT;
    first_char SMALLINT;
    second_char SMALLINT;
    next_id CHAR(6);
BEGIN
    -- Get current full ID and lock the row
    SELECT current_id INTO current_full_id
    FROM id_counter
    WHERE id_type = 'user_id'
    FOR UPDATE;

    -- Extract alpha and numeric parts
    current_alpha := LEFT(current_full_id, 2);
    current_num := RIGHT(current_full_id, 4)::SMALLINT;

    -- Increment numeric part first
    new_num := current_num + 1;
    new_alpha := current_alpha;

    -- Check if numeric part overflows (> 9999)
    IF new_num > 9999 THEN
        new_num := 1;

        -- Convert alpha part to numbers (A=1, B=2, ..., Z=26)
        first_char := ASCII(SUBSTRING(current_alpha, 1, 1)) - ASCII('A') + 1;
        second_char := ASCII(SUBSTRING(current_alpha, 2, 1)) - ASCII('A') + 1;

        -- Increment second character first
        second_char := second_char + 1;

        -- Check if second character overflows (> Z)
        IF second_char > 26 THEN
            second_char := 1;  -- Reset to A
            first_char := first_char + 1;

            -- Check if first character overflows (> Z)
            IF first_char > 26 THEN
                -- Reset to AA (could also raise exception)
                first_char := 1;
                second_char := 1;
            END IF;
        END IF;

        -- Convert back to letters
        new_alpha := CHR(first_char + ASCII('A') - 1) || CHR(second_char + ASCII('A') - 1);
    END IF;

    -- Create the new full ID
    next_id := new_alpha || LPAD(new_num::TEXT, 4, '0');

    -- Update the counter atomically
    UPDATE id_counter
    SET current_id = next_id
    WHERE id_type = 'user_id';

    RETURN next_id;
END;
$$;

-- Helper function to check what the next ID would be (without incrementing)
CREATE OR REPLACE FUNCTION peek_next_user_id()
RETURNS CHAR(6)
LANGUAGE plpgsql
AS $$
DECLARE
    current_full_id CHAR(6);
    current_alpha CHAR(2);
    current_num SMALLINT;
    next_alpha CHAR(2);
    next_num SMALLINT;
    first_char SMALLINT;
    second_char SMALLINT;
    next_id CHAR(6);
BEGIN
    SELECT current_id INTO current_full_id
    FROM id_counter
    WHERE id_type = 'user_id';

    current_alpha := LEFT(current_full_id, 2);
    current_num := RIGHT(current_full_id, 4)::SMALLINT;

    next_num := current_num + 1;
    next_alpha := current_alpha;

    IF next_num > 9999 THEN
        next_num := 1;
        first_char := ASCII(SUBSTRING(current_alpha, 1, 1)) - ASCII('A') + 1;
        second_char := ASCII(SUBSTRING(current_alpha, 2, 1)) - ASCII('A') + 1;
        second_char := second_char + 1;

        IF second_char > 26 THEN
            second_char := 1;
            first_char := first_char + 1;
            IF first_char > 26 THEN
                first_char := 1;
                second_char := 1;
            END IF;
        END IF;

        next_alpha := CHR(first_char + ASCII('A') - 1) || CHR(second_char + ASCII('A') - 1);
    END IF;

    next_id := next_alpha || LPAD(next_num::TEXT, 4, '0');
    RETURN next_id;
END;
$$;