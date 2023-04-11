% main file for application

% libraries
:- use_module(library(csv)).
:- use_module(library(http/http_open)).
:- use_module(library(http/json)).
:- use_module(library(lists)).

% constants
apikey('AIzaSyCDCSCwN5M95LfkkLtw5wQ8kkaRA-wBYqM'). 
url_root('https://www.googleapis.com/books/v1/volumes?q=').

% encoding to process the text & accents properly
% reference: https://swi-prolog.discourse.group/t/pcemacs-strips-some-accents-on-save-solved/1595/11
:- set_prolog_flag(encoding, utf8).

% import files
:- [call_api].
:- [csv_kb].
:- [recommend].
:- [search].


% initialize knowledge base
initialize:-
    writeln('Please wait as we load the database...'), nl,
    init_books.

% starts the application
start:-
    initialize,
    writeln('Welcome to our book recommendation and search system!'), nl,
    main_menu.


% main menu
main_menu:-
    writeln('If you would like to receive some recommendations, enter 0.'),
    writeln('If you would like to ask a query, enter 1.'),
    writeln('If you would like to exit, enter 2.'),
    writeln('Please note that your input must end with a period.'), % #justprologthings
    write('Enter your answer here: '),
    % read(Ans), nl,
    catch(
        read(Ans),
        error(syntax_error(_), _),
        (writeln('Input not applicable. Please re-enter.'), nl, main_menu)
    ), nl,
    check_ans(Ans).

% checks the user input and directs to appropriate calls

% recommendation case
check_ans(0):- 
    start_rec, nl,
    main_menu.

% search API case 
check_ans(1):-
    query_api, nl, nl,
    main_menu. 

% exit case
check_ans(2):-
    writeln('Thank you for using our system! Bye!'), nl,
    halt.

% wrong input case
check_ans(_):-
    writeln('Input not applicable. Please re-enter.'), nl,
    main_menu.