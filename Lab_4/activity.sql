-- 1
INSERT INTO book (ISBN, title, pub_id, date_published)
VALUES ('96-42013-10510', 'Growing your own Weeds', 10000, '2012-06-24');

INSERT INTO located_at (library_name, ISBN, total_copies, free_copies, shelf, floor)
VALUES ('Main', '96-42013-10510', 1, 1, 8, 2);

-- 2
UPDATE located_at
SET total_copies = 8, free_copies = 8
WHERE library_name = 'Main' AND ISBN = '96-42103-10907';

-- 3 ERROR
DELETE FROM author
WHERE first_name = 'Grace' AND last_name = 'Slick';

-- 4
INSERT INTO author (author_id, first_name, last_name)
VALUES (305, 'Commander', 'Adams');

INSERT INTO phone (phone_num, number_type)
VALUES ('970-555-5555', 'off');

INSERT INTO author_phone (author_id, phone_num)
VALUES (305, '970-555-5555');

-- 5 FIRST ERROR
INSERT INTO book (ISBN, title, pub_id, date_published)
VALUES ('96-42013-10510', 'Growing your own Weeds', 10000, '2012-06-24');

INSERT INTO located_at (library_name, ISBN, total_copies, free_copies, shelf, floor)
VALUES ('South Park', '96-42013-10510', 1, 1, 8, 3);

-- 6
DELETE FROM located_at
WHERE library_name = 'Main' AND ISBN = (SELECT ISBN FROM book WHERE title = 'Missing Tomorrow');

-- 7
UPDATE located_at
SET total_copies = total_copies + 2, free_copies = free_copies + 2
WHERE library_name = 'South Park' AND ISBN = (SELECT ISBN FROM book WHERE title = 'Eating in the Fort');

-- 8 BOTH ERROR
INSERT INTO book (ISBN, title, pub_id, date_published)
VALUES ('96-42013-10513', 'Growing your own Weeds', 90000, '2012-06-24');

INSERT INTO located_at (library_name, ISBN, total_copies, free_copies, shelf, floor)
VALUES ('Main', '96-42013-10513', 1, 1, 8, 2);

-- 9
SELECT * FROM audit_log;

