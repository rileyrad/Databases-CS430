-- a.
SELECT * FROM borrowed_by;

-- b.
SELECT m.last_name, m.first_name, m.member_id, b.title, l.library_name
FROM member m
JOIN borrowed_by bb ON m.member_id = bb.member_id
JOIN book b ON bb.ISBN = b.ISBN
JOIN located_at la ON b.ISBN = la.ISBN
JOIN library l ON la.library_name = l.library_name
WHERE bb.checkin_date IS NULL
ORDER BY m.last_name, m.first_name, b.title;
