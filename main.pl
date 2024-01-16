% main file for application

% libraries
:- use_module(library(csv)).
:- use_module(library(http/http_open)).
:- use_module(library(http/json)).
:- use_module(library(lists)).

% constants
apikey(''). 
url_root('https://www.googleapis.com/books/v1/volumes?q=').

% encoding to process the text & accents properly
% reference: https://swi-prolog.discourse.group/t/pcemacs-strips-some-accents-on-save-solved/1595/11
:- set_prolog_flag(encoding, utf8).

% import files
:- [call_api].
:- [csv_kb].
:- [recommend].
:- [search].

% initialize
% initialize knowledge base from csv file
initialize:-
    writeln('Please wait as we load the database...'), nl,
    init_books.

% start
% starts the application by loading the knowledge base and starting the main menu
start:-
    initialize,
    writeln('Welcome to our book recommendation and search system!'), nl,
    main_menu.


% main_menu
% write out the main menu
main_menu:-
    % write options
    writeln('If you would like to receive some recommendations, enter 0.'),
    writeln('If you would like to ask a query, enter 1.'),
    writeln('If you would like to exit, enter 2.'),
    writeln('Please note that your input must end with a period.'), % #justprologthings
    write('Enter your answer here: '),

    % catch syntax error for reading user input
    catch(
        read(Ans),
        error(syntax_error(_), _),
        (writeln('Input not applicable. Please re-enter.'), nl, main_menu)
    ), nl,

    % check which option was selected
    check_ans(Ans).

% check_ans(Option), where option is the user input from main menu of which feature they are using
% checks the user input and directs to appropriate calls, loops back to main menu once completed

% recommendation case
check_ans(0):- 
    start_rec, nl,
    main_menu.

% search API case 
check_ans(1):-
    query_api, nl, nl,
    main_menu. 

% exit application case
check_ans(2):-
    writeln('Thank you for using our system! Bye!'), nl,
    halt.

% invalid input case
check_ans(_):-
    writeln('Input not applicable. Please re-enter.'), nl,
    main_menu.
