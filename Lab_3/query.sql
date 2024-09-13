-- 5.
SELECT * FROM book ORDER BY ISBN;
SELECT * FROM member ORDER BY last_name, first_name;
SELECT * FROM author ORDER BY last_name, first_name;
SELECT * FROM publisher ORDER BY pub_name;
SELECT * FROM phone ORDER BY phone_num;

-- 6.
SELECT * FROM borrowed_by;
SELECT * FROM written_by;
SELECT * FROM publisher_phone;
SELECT * FROM author_phone;

-- 7.
SELECT first_name, last_name FROM member WHERE last_name LIKE 'B%';

-- 8.
SELECT b.* FROM book b JOIN publisher p ON b.pub_id = p.pub_id
WHERE p.pub_name = 'Coyote Publishing' ORDER BY b.title;

-- 9.
SELECT m.first_name, m.last_name, m.member_id, b.title FROM member m
JOIN borrowed_by bb ON m.member_id = bb.member_id
JOIN book b ON bb.ISBN = b.ISBN
WHERE bb.checkin_date IS NULL;

-- 10.
SELECT a.first_name, a.last_name, a.author_id, b.title FROM author a
JOIN written_by wb ON a.author_id = wb.author_id
JOIN book b ON wb.ISBN = b.ISBN
ORDER BY a.author_id, b.title;

-- 11.
SELECT a1.first_name, a1.last_name, ap1.phone_num FROM author a1
JOIN author_phone ap1 ON a1.author_id = ap1.author_id
JOIN author_phone ap2 ON ap1.phone_num = ap2.phone_num
JOIN author a2 ON ap2.author_id = a2.author_id
WHERE a1.author_id <> a2.author_id ORDER BY ap1.phone_num, a1.last_name, a1.first_name;