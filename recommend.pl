% asks user a series of questions about genre, pages, and rating for book recommendations
:- [csv_kb].


% TODO: handle invalid input
% TODO: some cases return error when not enough search results?


start_rec :- 
    nl, nl,
    write('Welcome to the book recommendation system. We will recommend 5 books from a collection of best books from Goodreads. Please answer the following questions by entering the corresponding number followed by a period!'), nl, nl,
    ask_genre(AnsGenre), nl,
    ask_pages(AnsPages), nl,
    ask_rating(AnsRating), nl,
    write('Please wait momentarily while we browse our library...'), nl,
    write('We recommend the following books: '), nl, nl,
    find_books(AnsGenre, AnsPages, AnsRating).

    /*
    forall(limit(5, distinct(recommend(AnsGenre, AnsPages, AnsRating, B, A))),
    (atomic_list_concat([B, A], ' written by ', F),
    write(F), nl)).
    */

%% GENRE %%

% asks the genre options
ask_genre(AnsGenre) :-
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
    write('0. Classics'),nl,
    read(Ans), nl,
    (check_ans_genre(Ans)
        -> AnsGenre is Ans
        ; writeln('Invalid input! Please try again.'),nl,
          ask_genre(AnsGenre)
    ).

% checks input for the genre
check_ans_genre(Ans) :- 
    member(Ans, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]).

%% PAGES %%

% asks the pages options
ask_pages(AnsPages) :-
    write('What pages are you looking for?'), nl,
    write('1. Less than 200 pages'),nl,
    write('2. 200 to 400 pages'),nl,
    write('3. More than 400 pages'),nl,
    read(Ans), nl,
    (check_ans_pages(Ans)
        -> AnsPages is Ans
        ; writeln('Invalid input! Please try again.'),nl,
          ask_pages(AnsPages)
    ).

%checks input for the number of pages
check_ans_pages(Ans) :- 
    member(Ans, [1, 2, 3]).


%% RATING %%

% asks the rating options
ask_rating(AnsRating) :-
    write('Do you prefer books with higher ratings?'), nl,
    write('1. Yes (4 stars and above)'),nl,
    write('2. No  (less than 4 stars)'), nl,
    read(Ans), nl,
    (check_ans_rating(Ans)
        -> AnsRating is Ans
        ; writeln('Invalid input! Please try again.'),nl,
          ask_rating(AnsRating)
    ).

% checks input for the rating
check_ans_rating(Ans) :- 
    member(Ans, [1, 2]).


%% Finding Predicates %%

% genre
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


% pages

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

% rating

question_rating(1, ID) :-
    book(ID, rating, R),
    R > 4.

question_rating(2, ID) :-
    book(ID, rating, R),
    R < 4.


% recommend based on answers
recommend(AnsGenre, AnsPages, AnsRating, BookTitle, Author) :-
    %init_books, % remove as we integrate into main
    book(ID, title, BookTitle),
    book(ID, author, Author),
    question_genre(AnsGenre, ID),
    question_pages(AnsPages, ID),
    question_rating(AnsRating, ID).


% finds all predicates and selects a random 5
find_books(AnsGenre, AnsPages, AnsRating):-
    findall([Title,Author], recommend(AnsGenre, AnsPages, AnsRating, Title, Author), Results),
    length(Results, Total),
    randset(5, Total, [A,B,C,D,E]),
    nth1(A, Results, [Title1, Author1]),
    nth1(B, Results, [Title2, Author2]),
    nth1(C, Results, [Title3, Author3]),
    nth1(D, Results, [Title4, Author4]),
    nth1(E, Results, [Title5, Author5]),
    print_results([Title1, Title2, Title3, Title4, Title5], [Author1, Author2, Author3, Author4, Author5]).

% prints the results
print_results([],[]).
print_results([B|T1], [A|T2]):-
    atomic_list_concat([B, A], ' written by ', F),
    write(F), nl,
    print_results(T1, T2).
