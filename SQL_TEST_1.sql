---- QUESTION 1
USE pubs
GO

SELECT
tt.au_id AS ID,
aa.au_fname AS First_name,
aa.au_lname AS Last_name,
COUNT(DISTINCT title_id) AS BOOKS_WRITTEN
FROM dbo.titleauthor as tt
JOIN dbo.authors AS aa ON tt.au_id = aa.au_id
GROUP BY tt.au_id , aa.au_fname ,aa.au_lname
HAVING COUNT(DISTINCT title_id) >=2 
ORDER BY  BOOKS_WRITTEN DESC 

GO
;
