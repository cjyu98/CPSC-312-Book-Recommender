% asks user a series of questions about genre, pages, and rating for book recommendations
:- [csv_kb].


% TODO: handle invalid input
% TODO: some cases return error when not enough search results?


start_rec :- 
    nl, nl,
    write('Welcome to the book recommendation system. Please answer the following questions!'), nl, nl,
    ask_genre, nl,
    read(AnsGenre), nl,
    ask_pages, nl,
    read(AnsPages), nl,
    ask_rating, nl,
    read(AnsRating), nl,
    write('Please wait momentarily while we browse our library...'), nl,
    write('We recommend the following books: '), nl, nl,
    forall(limit(5, distinct(recommend(AnsGenre, AnsPages, AnsRating, B, A))),
    (atomic_list_concat([B, A], ' written by ', F),
    write(F), nl)).


ask_genre :-
    write('What book genre are you interested in?'), nl,
    write('1. Fiction'),nl,
    write('2. Science Fiction'),nl,
    write('3. Romance'),nl,
    write('4. Young Adult'),nl,
    write('5. Fantasy'),nl,
    write('6. Horror'),nl,
    write('7. Thriller'),nl,
    write('8. Mystery'),nl,
    write('9. Adventure'),nl,
    write('0. Classics'),nl.


ask_pages :-
    write('What pages are you looking for?'), nl,
    write('1. Less than 200 pages'),nl,
    write('2. 200 to 400 pages'),nl,
    write('3. More than 400 pages').


ask_rating :-
    write('Do you prefer books with higher ratings?'), nl,
    write('1. Yes (3.5 stars and above)'),nl,
    write('2. No (less than 3.5 stars)').


question_genre(1, ID) :-
    book(ID, genre, 'Fiction').

question_genre(2, ID) :-
    book(ID, genre, 'Science Fiction').

question_genre(3, ID) :-
    book(ID, genre, 'Romance').

question_genre(4, ID) :-
    book(ID, genre, 'Young Adult').

question_genre(5, ID) :-
    book(ID, genre, 'Fantasy').

question_genre(6, ID) :-
    book(ID, genre, 'Horror').

question_genre(7, ID) :-
    book(ID, genre, 'Thiller').

question_genre(8, ID) :-
    book(ID, genre, 'Mystery').

question_genre(9, ID) :-
    book(ID, genre, 'Adventure').

question_genre(0, ID) :-
    book(ID, genre, 'Classics').

% invaid genre case
% invalid_genre(Op):-
  %  nonmember(Op, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]),
    % writeln('Input not applicable. Please re-enter.'), nl,
    % ask_genre.



question_pages(1, ID) :-
    book(ID, pages, P),
    P < 200.

question_pages(2, ID) :-
    book(ID, pages, P),
    P > 200,
    P < 400.

question_pages(3, ID) :-
    book(ID, pages, P),
    P > 400.

% invaid pages case
% question_pages(Op, _):-
 %   nonmember(Op, [1, 2, 3]),
  %  writeln('Input not applicable. Please re-enter.'), nl,
   % ask_pages.


question_rating(1, ID) :-
    book(ID, rating, R),
    R > 3.5.

question_rating(2, ID) :-
    book(ID, rating, R),
    R < 3.5.

% invaid rating case
% question_rating(Op, _):-
  %  nonmember(Op, [1, 2]),
   % writeln('Input not applicable. Please re-enter.'), nl,
    % ask_rating.


recommend(AnsGenre, AnsPages, AnsRating, BookTitle, Author) :-
    init_books,
    book(ID, title, BookTitle),
    book(ID, author, Author),
    question_genre(AnsGenre, ID),
    question_pages(AnsPages, ID),
    question_rating(AnsRating, ID).




