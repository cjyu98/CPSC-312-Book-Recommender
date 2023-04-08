% reads in a csv file and populates a knowledge base of books with the format
% book(ID, category, value).

% since our knowledge base will be dynamic
:- dynamic book/3.

% csv file from Kaggle that contains the data for our knowledge base
% https://www.kaggle.com/datasets/arnabchaki/goodreads-best-books-ever 
% csv file has been modified to add an ID for our knowledge base
% column names in csv: ID, title, series, author, rating, description, language, isbn, genres, characters, bookFormat, edition, pages, publisher, publishDate, firstPublishDate, awards, numRatings, ratingsByStars, likedPercent, setting, bbeScore, bbeVotes, price

% initialize the process from csv to knowledge base
init_books:-
    csv_read_file('books.csv', Rows, [arity(24)]),
    maplist(assert, Rows),
    rows_to_predicate(Rows).


% change the rows to predicate
rows_to_predicate([]).
rows_to_predicate([row(ID, Title,_,Author,Rating, Description,_,_,Genres,_,_,_,Pages,_, _,_,_,_,_, _,_,_,_,_)|T]):-
    add_book(ID,Title,Author,Rating, Description,Genres, Pages),
    rows_to_predicate(T).

% adds the books for each row as a predicate 
% base cases for blanks in the csv, returns true
add_book('',_,_,_,_,_,_).
add_book(_,'',_,_,_,_,_).
add_book(_,_,'',_,_,_,_).
add_book(_,_,_,'',_,_,_).
add_book(_,_,_,_,'',_,_).
add_book(_,_,_,_,_,'',_).
add_book(_,_,_,_,_,_,'').

add_book(ID,Title,Author,Rating, Description,Genres, Pages):-
    assert(book(ID, title, Title)),
    assert(book(ID, author, Author)),
    assert(book(ID, rating, Rating)),
    assert(book(ID, description, Description)),
    assert(book(ID, pages, Pages)),
    atomic_list_concat(GenreList, ',', Genres),
    add_genre(ID, GenreList).


% adds the predicate for each genre
add_genre(_,[]).
add_genre(ID, [H|T]):-
    assert(book(ID, genre, H)),
    add_genre(ID, T).


