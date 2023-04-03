% library 
:- use_module(library(csv)).

% encoding to process the text & accents from csv file properly
% reference: https://swi-prolog.discourse.group/t/pcemacs-strips-some-accents-on-save-solved/1595/11
:- set_prolog_flag(encoding, utf8).


% read in the csv file into a list
% reference: https://www.swi-prolog.org/pldoc/doc_for?object=csv_read_file/2
import(Data):-
    csv_read_file('books.csv', Data).


% reformats the imported list to only contain the fields we are interested in
% column names in csv: title, series, author, rating, description, language, isbn, genres, characters, bookFormat, edition, pages, publisher, publishDate, firstPublishDate, awards, numRatings, ratingsByStars, likedPercent, setting, bbeScore, bbeVotes, price
% will skip fields that are not of interest (15 blanks after Genres for reference)
% note that Genre itself is a list
reformat_data([],[]).
reformat_data([row(Title,_,Author,_, Description,_,_,Genres,_,_,_,_,_, _,_,_,_,_, _,_,_,_,_)|T], 
    [(Title,Author,Description,Genres)|L]):-
        reformat_data(T,L).


% TESTING FUNCTIONS
% function to test we were formatting correctly, prints all the titles in the csv file
% will give singleton variable warning, can ignore for now
write_test([]).
write_test([(Title,Author,Description,Genres)|L]):-
    string_concat(Title, "\n", Title1),
    write(Title1),
    write_test(L).


% main testing function
print_data:-
    import(Data),
    reformat_data(Data, NewList),
    write_test(NewList).


% TODO:

% filter list by the genre, likely need to +1 index to skip the first row of titles?
% need to throw exception/write a warning if it is a genre not included


% function to find number of rows/books in the csv file (will need to update based on filtered list)
total_rows(52478). % total in the csv file currently
% length of list function is length(L, total)

% currently working randomizer function for 5 random indexs we can grab from the list of books
% test case: random_indexs(X).
% reference: https://www.swi-prolog.org/pldoc/man?section=random
random_indexs(Indexs):-
    total_rows(Rows),
    randset(5,6,Indexs).


% fetch the books from filtered list with the random indexs
% likely use nth0(3, [a, b, c, d, e], Elem), Elem = d
