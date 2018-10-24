CREATE TABLE access_log
(
    host VARCHAR(55),
    timestamp DATETIME,
    request VARCHAR(335),
    replyBytes INT,
    replyCodeId INT NOT NULL,
    FOREIGN KEY (replyCodeId) REFERENCES status_codes(ID)
);