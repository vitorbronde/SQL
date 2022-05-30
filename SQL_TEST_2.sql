---- QUESTION 2 - Give me a list of stores (id and name) together with a "bit" field indicating whether the store offers a discount or not.
USE pubs
GO

SELECT  
ss.stor_id AS ID,
ss.stor_name AS stor_id,
CASE WHEN dd.stor_id IS NOT NULL THEN 1
ELSE 0 END AS HAS_DISCOUNT
FROM dbo.stores AS ss
LEFT JOIN dbo.discounts AS dd ON ss.stor_id = dd.stor_id
GROUP BY  ss.stor_id , ss.stor_name  ,ss.stor_id ,dd.stor_id
ORDER BY order by ss.stor_id desc

GO
