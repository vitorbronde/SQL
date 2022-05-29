----- QUESTION 3
USE pubs
go

select 
aa.au_id AS ID,
aa.au_fname AS First_name,
aa.au_lname AS Last_name,
st.state AS State,
SUM(qty) as SOLD_BOOK
FROM dbo.authors AS aa
LEFT JOIN dbo.titleauthor as tt on tt.au_id = aa.au_id
LEFT JOIN dbo.sales as ss on ss.title_id = tt.title_id
LEFT JOIN dbo.stores as st on st.stor_id =ss.stor_id
group by aa.au_id , aa.au_fname,aa.au_lname ,st.state
order by ID desc
GO
;