% calls and prints the results from calling the API

% library - will likely need to move into main file
:- use_module(library(http/http_open)).
:- use_module(library(http/json)).
:- use_module(library(lists)).

% encoding to process the text & accents from csv file properly
% reference: https://swi-prolog.discourse.group/t/pcemacs-strips-some-accents-on-save-solved/1595/11
:- set_prolog_flag(encoding, utf8).


% Constants
apikey("AIzaSyCDCSCwN5M95LfkkLtw5wQ8kkaRA-wBYqM"). % linked to Carmen's Google account
url_root("https://www.googleapis.com/books/v1/volumes?q=").


% current test case: 
    % calling the api for searching the book "The Goldfinch"
    % testing URL: https://www.googleapis.com/books/v1/volumes?q=the+goldfinch&key=AIzaSyCDCSCwN5M95LfkkLtw5wQ8kkaRA-wBYqM
    % click URL to see how the JSON file returns
    % query: call_api("https://www.googleapis.com/books/v1/volumes?q=the+goldfinch&key=AIzaSyCDCSCwN5M95LfkkLtw5wQ8kkaRA-wBYqM").
    % every search term we parse must append a +

% call the api to print out the top 5 results
call_api(URL) :- 
    write('Calling GoogleBooks API'),
    write("\n\n"),
    http_open(URL, Input_stream, []),
 	json_read_dict(Input_stream, Dict),
 	close(Input_stream),
    json_to_book_description(Dict, Books),
    write_results(Books).

% reads the key-value pairs in the JSON dict
json_to_book_description(Dict, Dict.items). 

% prints out the title, author and description of the results from API search
write_results([]). % base case
write_results([Book|T]) :-

    % assign the values
    Title = Book.volumeInfo.title,
    Author = Book.volumeInfo.authors,
    Description = Book.volumeInfo.description,

    % writes title
    string_concat('Title: ', Title, Title1),
    writeln(Title1),

    % writes author
    write('Author(s): '),
    write_author(Author),
    write("\n"),

    % writes description
    string_concat('Description: ', Description, Description1),
    write(Description1),
    write("\n\n"),

    % recursive call
    write_results(T).

% writes out the authors since it is a list
write_author([]).
write_author([H|T]) :-
    write(H),
    write(","),
    write_author(T).

% TODO:
% have it print only top 5 results (URL would have & maxResults=5 added)


 

% TODO:
% example query: create_url(["harry", "potter"], URL).
% Create a URL for search term

create_url(Terms, URL) :-
    url_root(Root),
    append_search_term(Terms, Root, URL).

% base case
append_search_term([], URL, URL).

% append last search term and API key to URL
append_search_term([Last], URL, URL_final) :-
    apikey(Key),
    string_concat(URL, Last, URL1),
    string_concat(URL1, "&key=", URL2),
    string_concat(URL2, Key, URL_final).

% recursive case: append next search term
append_search_term([Term|T], URL, URL_final) :-
    string_concat(URL, Term, URL1),
    string_concat(URL1,"+",URL2),
    append_search_term(T, URL2, URL_final).


    


