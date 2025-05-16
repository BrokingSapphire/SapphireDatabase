CREATE TYPE stock_exchange AS ENUM ('NSE', 'BSE', 'MCX', 'NCDEX');

CREATE TABLE user_watchlist_category
(
    id         SERIAL,
    user_id    INT         NOT NULL,
    category   VARCHAR(20) NOT NULL,
    created_at TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_User_Watchlist_Category PRIMARY KEY (id),
    CONSTRAINT FK_User_To_Watchlist_Category FOREIGN KEY (user_id) REFERENCES "user" (id),
    CONSTRAINT UQ_User_Watchlist_Category UNIQUE (user_id, category)
);

CREATE TABLE user_stock_watchlist
(
    user_id        INT            NOT NULL,
    isin           VARCHAR(12)    NOT NULL,
    exchange       stock_exchange NOT NULL,
    position_index INT            NOT NULL,
    category_id    INT,
    created_at     TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at     TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_User_Stock_Watchlist PRIMARY KEY (user_id, isin, exchange),
    CONSTRAINT FK_User_To_Watchlist FOREIGN KEY (user_id) REFERENCES "user" (id),
    CONSTRAINT FK_Watchlist_Category FOREIGN KEY (category_id) REFERENCES user_watchlist_category (id),
    CONSTRAINT UQ_User_Position_Index UNIQUE (user_id, position_index)
);