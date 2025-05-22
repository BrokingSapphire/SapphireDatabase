CREATE TYPE stock_exchange AS ENUM ('NSE', 'BSE', 'MCX', 'NCDEX');

CREATE TABLE watchlist
(
    id   SERIAL,
    name VARCHAR(20) NOT NULL,
    CONSTRAINT PK_Watchlist PRIMARY KEY (id),
    CONSTRAINT UQ_Watchlist UNIQUE (name)
);

CREATE TABLE watchlist_category
(
    id       SERIAL,
    category VARCHAR(20) NOT NULL,
    CONSTRAINT PK_Watchlist_Category PRIMARY KEY (id),
    CONSTRAINT UQ_Watchlist_Category UNIQUE (category)
);

CREATE TABLE user_watchlist
(
    id             SERIAL,
    user_id        INT       NOT NULL,
    watchlist_id   INT,
    position_index INT       NOT NULL,
    created_at     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_User_Watchlist PRIMARY KEY (id),
    CONSTRAINT FK_User_Watchlist_User FOREIGN KEY (user_id) REFERENCES "user" (id),
    CONSTRAINT FK_User_Watchlist_Watchlist FOREIGN KEY (watchlist_id) REFERENCES watchlist (id),
    CONSTRAINT UQ_User_Watchlist UNIQUE (user_id, watchlist_id),
    CONSTRAINT UQ_User_Watchlist_Position UNIQUE (user_id, position_index) DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE watchlist_category_map
(
    id                SERIAL,
    user_watchlist_id INT       NOT NULL,
    category_id       INT,
    position_index    INT       NOT NULL,
    created_at        TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at        TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_Watchlist_Category_Map PRIMARY KEY (id),
    CONSTRAINT FK_Watchlist_Category_Map_User_Watchlist FOREIGN KEY (user_watchlist_id) REFERENCES user_watchlist (id),
    CONSTRAINT FK_Watchlist_Category_Map_Category FOREIGN KEY (category_id) REFERENCES watchlist_category (id),
    CONSTRAINT UQ_Watchlist_Category_Map UNIQUE (user_watchlist_id, category_id),
    CONSTRAINT UQ_Watchlist_Category_Position UNIQUE (user_watchlist_id, position_index) DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE user_watchlist_entry
(
    category_map_id INT            NOT NULL,
    isin            VARCHAR(12)    NOT NULL,
    exchange        stock_exchange NOT NULL,
    position_index  INT            NOT NULL,
    created_at      TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_User_Watchlist_Entry PRIMARY KEY (category_map_id, isin, exchange),
    CONSTRAINT FK_Watchlist_Entry_Category_Map FOREIGN KEY (category_map_id) REFERENCES watchlist_category_map (id),
    CONSTRAINT UQ_Watchlist_Entry_Position_Index UNIQUE (category_map_id, position_index) DEFERRABLE INITIALLY DEFERRED
);