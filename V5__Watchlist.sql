CREATE TYPE stock_exchange AS ENUM ('NSE', 'BSE', 'MCX', 'NCDEX');

CREATE TABLE user_stock_watchlist (
    user_id INT NOT NULL,
    isin VARCHAR(12) NOT NULL,
    exchange stock_exchange NOT NULL,
    position_index INT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_User_Stock_Watchlist PRIMARY KEY (user_id, isin, exchange),
    CONSTRAINT FK_User_To_Watchlist FOREIGN KEY (user_id) REFERENCES "user" (id),
    CONSTRAINT UQ_User_Position_Index UNIQUE (user_id, position_index)
);