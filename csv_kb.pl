% reads in a csv file and populates a knowledge base of books with the format
% book(ID, category, value).


% libraries 
:- use_module(library(csv)).

% encoding to process the text & accents from csv file properly
% reference: https://swi-prolog.discourse.group/t/pcemacs-strips-some-accents-on-save-solved/1595/11
:- set_prolog_flag(encoding, utf8).

% since our knowledge base will be dynamic
:- dynamic book/3.

% csv file that contains the data for our knowledge base
% https://www.swi-prolog.org/pldoc/doc_for?object=csv_read_file/2
% csv file has been modified to add an ID for our knowledge base

% initialize the process from csv to knowledge base
init:-
    csv_read_file('books.csv', Rows, [arity(24)]),
    maplist(assert, Rows),
    rows_to_predicate(Rows).


% change the rows to predicate
rows_to_predicate([]).
rows_to_predicate([row(ID, Title,_,Author,_, Description,_,_,Genres,_,_,_,_,_, _,_,_,_,_, _,_,_,_,_)|T]):-
    add_book(ID,Title,Author,Description,Genres),
    rows_to_predicate(T).

% adds the books for each row as a predicate 
% base cases for blanks in the csv, returns true
add_book('',_,_,_,_).
add_book(_,'',_,_,_).
add_book(_,_,'',_,_).
add_book(_,_,_,'',_).
add_book(_,_,_,_,'').

add_book(ID,Title,Author,Description,Genres):-
    assert(book(ID, title, Title)),
    assert(book(ID, author, Author)),
    assert(book(ID, description, Description)),
    atomic_list_concat(GenreList, ',', Genres),
    add_genre(ID, GenreList).


% adds the predicate for each genre
add_genre(_,[]).
add_genre(ID, [H|T]):-
    assert(book(ID, genre, H)),
    add_genre(ID, T).