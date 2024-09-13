-- 5.1
SELECT * FROM library ORDER BY library_name;

-- 5.2
SELECT * FROM located_at ORDER BY ISBN;

-- 5.3
SELECT b.title, l.total_copies, l.library_name FROM book b
JOIN located_at l ON b.ISBN = l.ISBN WHERE l.library_name IN (
    SELECT library_name 
    FROM located_at
    GROUP BY ISBN
    HAVING COUNT(DISTINCT library_name) > 1
)
ORDER BY b.title;

-- 5.4
SELECT l.library_name, COUNT(DISTINCT la.ISBN) AS number_of_titles
FROM library l LEFT JOIN located_at la ON l.library_name = la.library_name
GROUP BY l.library_name ORDER BY l.library_name;

-- 6.
DELIMITER |

CREATE TRIGGER after_author_insert AFTER INSERT ON author
FOR EACH ROW BEGIN
    INSERT INTO audit_log (action, action_date)
    VALUES ('Add Author', NOW());
END;
|

CREATE TRIGGER after_book_insert AFTER INSERT ON located_at
FOR EACH ROW
BEGIN
    INSERT INTO audit_log (action, action_date)
    VALUES ('Add Book to Library', NOW());
END;
|

CREATE TRIGGER after_book_delete AFTER DELETE ON located_at
FOR EACH ROW
BEGIN
    INSERT INTO audit_log (action, action_date)
    VALUES ('Delete Book from Library', NOW());
END;
|

CREATE TRIGGER after_copies_update AFTER UPDATE ON located_at
FOR EACH ROW
BEGIN
    IF OLD.total_copies != NEW.total_copies THEN
        INSERT INTO audit_log (action, action_date)
        VALUES ('Update Book Copies', NOW());
    END IF;
END;
|

DELIMITER ;
-- 7.
DROP VIEW IF EXISTS book_authors_libraries;
CREATE SQL SECURITY INVOKER VIEW book_authors_libraries AS
SELECT b.ISBN, b.title AS book_name,
    GROUP_CONCAT(CONCAT(a.first_name, ' ', a.last_name) ORDER BY a.last_name SEPARATOR ', ') AS authors,
    l.library_name
FROM 
    book b
JOIN written_by wb ON b.ISBN = wb.ISBN
JOIN author a ON wb.author_id = a.author_id
JOIN located_at la ON b.ISBN = la.ISBN
JOIN library l ON la.library_name = l.library_name
GROUP BY b.ISBN, b.title, l.library_name;

-- 8.
SELECT 
    bal.book_name, 
    bal.authors, 
    la.shelf, 
    bal.library_name
FROM 
    book_authors_libraries bal
JOIN located_at la ON bal.ISBN = la.ISBN
ORDER BY bal.book_name;

