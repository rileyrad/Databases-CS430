DROP TABLE IF EXISTS borrowed_by,
                     located_at,
                     written_by,
                     author_phone,
                     publisher_phone,
                     book,
                     phone,
                     author,
                     publisher,
                     member,
                     library,
                     audit_log;

CREATE TABLE author (
    author_id   INT          NOT NULL,
    first_name  VARCHAR(30)  NOT NULL,
    last_name   VARCHAR(30)  NOT NULL,
    PRIMARY KEY (author_id)
);

CREATE TABLE publisher (
    pub_id    INT          NOT NULL,
    pub_name  VARCHAR(50)  NOT NULL,
    PRIMARY KEY (pub_id)
);

CREATE TABLE member (
    member_id   INT          NOT NULL,
    first_name  VARCHAR(30)  NOT NULL,
    last_name   VARCHAR(30)  NOT NULL,
    birth_date  VARCHAR(10)  NOT NULL,
    PRIMARY KEY (member_id)
);

CREATE TABLE book (
    ISBN            CHAR(14)      NOT NULL,
    title           VARCHAR(50)   NOT NULL,
    pub_id          INT           NOT NULL,
    date_published  CHAR(10)      NOT NULL,
    FOREIGN KEY (pub_id) REFERENCES publisher (pub_id),
    PRIMARY KEY (ISBN)
);

CREATE TABLE phone (
    phone_num    CHAR(12)  NOT NULL,
    number_type  CHAR(3)   NOT NULL,
    PRIMARY KEY (phone_num)
);

CREATE TABLE library (
    library_name   VARCHAR(15)   NOT NULL,
    street         VARCHAR(25)   NOT NULL,
    city           VARCHAR(15)   NOT NULL,
    state_code     CHAR(2)       NOT NULL,
    PRIMARY KEY (library_name)
);

CREATE TABLE borrowed_by (
    member_id      INT           NOT NULL,
    ISBN           CHAR(14)      NOT NULL,
    checkout_date  VARCHAR(12)   NOT NULL,
    checkin_date   VARCHAR(12),
    FOREIGN KEY (ISBN) REFERENCES book (ISBN),
    FOREIGN KEY (member_id) REFERENCES member (member_id)
);

CREATE TABLE written_by (
    ISBN       CHAR(14)  NOT NULL,
    author_id  INT       NOT NULL,
    FOREIGN KEY (ISBN) REFERENCES book (ISBN),
    FOREIGN KEY (author_id) REFERENCES author (author_id),
    PRIMARY KEY (ISBN, author_id)
);

CREATE TABLE author_phone (
    author_id  INT       NOT NULL,
    phone_num  CHAR(12)  NOT NULL,
    FOREIGN KEY (author_id) REFERENCES author (author_id),
    FOREIGN KEY (phone_num) REFERENCES phone (phone_num)
);

CREATE TABLE publisher_phone (
    pub_id     INT       NOT NULL,
    phone_num  CHAR(12)  NOT NULL,
    FOREIGN KEY (pub_id) REFERENCES publisher (pub_id),
    FOREIGN KEY (phone_num) REFERENCES phone (phone_num)
);

CREATE TABLE located_at (
    library_name    VARCHAR(15)   NOT NULL,
    ISBN            CHAR(14)      NOT NULL,
    total_copies    INT           NOT NULL,
    free_copies     INT           NOT NULL,
    shelf           INT           NOT NULL,
    floor           INT           NOT NULL,
    FOREIGN KEY (library_name) REFERENCES library (library_name),
    FOREIGN KEY (ISBN) REFERENCES book (ISBN)
);

CREATE TABLE audit_log (
    log_id        INT AUTO_INCREMENT,
    action        VARCHAR(100),
    action_date   TIMESTAMP,
    PRIMARY KEY (log_id)
);
