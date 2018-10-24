CREATE TABLE status_codes
(
    Id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    Description VARCHAR(35),
    Reference VARCHAR(50),
    Code INT NOT NULL,
    UNIQUE INDEX (Code)
);