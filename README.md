# sql-ch-18


18.5.2. Warm-up Queries
Write the following queries to get warmed up.
1.	Return the mystery book titles and their ISBNs.
select * from genre inner join book on genre.genre_id = book.genre_id where genres = "Mystery";
![image](https://user-images.githubusercontent.com/68029807/123864552-82044280-d8f0-11eb-8075-7de54cdba486.png)


SELECT title, isbn
FROM book
WHERE genre_id IN (SELECT genre_id FROM genre WHERE genres like "Mystery");
 
2.	Return all of the titles and author’s first and last names for books written by authors who are currently living.
select title, last_name, first_name from author inner join book on author.author_id = book.author_id where deathday is null;

 
18.5.3. Loan Out a Book
A big function that you need to implement for the library is a script that updates the database when a book is loaned out.
The script needs to perform the following functions:
1.	Change available to FALSE for the appropriate book.


2.	Add a new row to the loan table with today’s date as the date_out and the ids in the row matching the appropriate patron_id and book_id.
INSERT INTO loan(patron_id, date_out, book_id)
VALUE (1,now(),1), (3,curdate(),5),(4,now(),7), (9,curdate(),9);

 
3.	Update the appropriate patron with the loan_id for the new row created in the loan table.
update patron set loan_id = 2 where patron_id = 3;
update patron set loan_id = 1 where patron_id = 1;

or 

UPDATE patron
SET loan_id = (SELECT loan_id
   FROM loan
   WHERE loan.patron_id = patron.patron_id)where first_name = “gds” and last name = “jelk”;

Or 
UPDATE patron
SET loan_id = (SELECT loan_id
   FROM loan
   WHERE 
   loan.patron_id = patron.patron_id) 
   where 
   patron_id = (select patron_id from loan where book_id = (select book_id from book where title = "Beloved"));

 
You can use any patron and book that strikes your fancy to create this script!
18.5.4. Check a Book Back In
Working with the same patron and book, create the new script!
The other key function that we need to implement is checking a book back in. To do so, the script needs to:
1.	Change available to TRUE for the appropriate book.
update book 
set available = true where book_id = 34 ;

 
2.	Update the appropriate row in the loan table with today’s date as the date_in.
select @lid:= (select loan_id from loan where book_id = (select book_id from book where title = "Beloved"));
update loan 
set date_in = curdate() 
where 
loan_id = @lid;

or

select @pid:= (select patron_id from loan where book_id = (select book_id from book where title = "Beloved"));
update loan 
set date_in = curdate() 
where 
loan_id = @pid;

 

3.	Update the appropriate patron changing loan_id back to null.
UPDATE patron
SET loan_id = null 
   where 
   patron_id = (select patron_id from loan where book_id = (select book_id from book where title = "Beloved"));
 


Once you have created these scripts, loan out 5 new books to 5 different patrons.
18.5.5. Wrap-up Query
Select first_name , last_name, genres 
From (select patron.first-name, patron.last_name, loan.book_id
From patron 
Inner join loan 
On loan.patron_id = patron.patron_id
)

Inner join (select * from book
Inner join genre
On book.genre_id = genre.genre_id
) as book_genre
On patron_loan.book_id = book_genre.bookid

Or


SELECT patron_loan.first_name, patron_loan.last_name, genre_book.genres
FROM (
	SELECT patron.first_name, patron.last_name, loan.book_id
    FROM patron
    INNER JOIN loan ON loan.loan_id = patron.loan_id
) AS patron_loan
INNER JOIN (
	SELECT  genre.genre_id, genre.genres, book.book_id
    FROM genre
    INNER JOIN book ON genre.genre_id = book.genre_id) AS genre_book
ON genre_book.book_id = patron_loan.book_id;

18.5.6. Bonus Mission
1.	Return the counts of the books of each genre. Check out the documentation to see how this could be done!
select genre_id , title , count(*) as book_count from book group by genre_id;
 

2 . A reference book cannot leave the library. How would you modify either the reference_book table or the book table to make sure that doesn’t happen? Try to apply your modifications.

select @bid:= (select book_id from reference_books);
   UPDATE book
SET available = true
 WHERE book_id = @bid;

Or 
select @bid:= (select book_id from reference_books);
update book
set available = case 
when genre_id = 25 then true
else
      false
end
    
WHERE book_id = @bid;

 







