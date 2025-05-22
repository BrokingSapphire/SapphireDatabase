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

CREATE TABLE user_stock_watchlist
(
    id             SERIAL,
    user_id        INT       NOT NULL,
    watchlist_id   INT,
    category_id    INT,
    position_index INT       NOT NULL,
    created_at     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_User_Stock_Watchlist PRIMARY KEY (id),
    CONSTRAINT FK_User_To_Watchlist FOREIGN KEY (user_id) REFERENCES "user" (id),
    CONSTRAINT FK_Watchlist_To_User FOREIGN KEY (watchlist_id) REFERENCES watchlist (id),
    CONSTRAINT FK_Category_To_Watchlist FOREIGN KEY (category_id) REFERENCES watchlist_category (id),
    CONSTRAINT UQ_User_Stock_Watchlist UNIQUE (user_id, watchlist_id, category_id),
    CONSTRAINT UQ_User_Category_Position_Index UNIQUE (user_id, watchlist_id, position_index)
);

CREATE TABLE user_watchlist_entry
(
    user_watchlist_id INT            NOT NULL,
    isin              VARCHAR(12)    NOT NULL,
    exchange          stock_exchange NOT NULL,
    position_index    INT            NOT NULL,
    created_at        TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at        TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_User_Watchlist_Entry PRIMARY KEY (user_watchlist_id, isin, exchange),
    CONSTRAINT FK_Watchlist_Entry FOREIGN KEY (user_watchlist_id) REFERENCES user_stock_watchlist (id),
    CONSTRAINT UQ_Watchlist_Entry_Position_Index UNIQUE (user_watchlist_id, position_index)
);