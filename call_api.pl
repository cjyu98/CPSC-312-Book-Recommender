% testing file for api call, to be adjusted as we go on

% library - will likely need to move into main file
:- use_module(library(http/http_open)).
:- use_module(library(http/json)).

% Constants
apikey("AIzaSyCDCSCwN5M95LfkkLtw5wQ8kkaRA-wBYqM"). % linked to Carmen's Google account
url_root("https://www.googleapis.com/books/v1/volumes?q=").


% current test case: 
    % calling the api for searching the book "The Goldfinch"
    % for now, just printing out descriptions of top results as we test
    % will generalize later
    % testing URL: https://www.googleapis.com/books/v1/volumes?q=the+goldfinch&key=AIzaSyCDCSCwN5M95LfkkLtw5wQ8kkaRA-wBYqM
    % click URL to see how the JSON file returns
    % query: call_api("https://www.googleapis.com/books/v1/volumes?q=the+goldfinch&key=AIzaSyCDCSCwN5M95LfkkLtw5wQ8kkaRA-wBYqM").
    % every search term we parse must append a +

% call the api, printing out the book descriptions
call_api(URL) :- 
    write("calling api\n"),
    http_open(URL, Input_stream, []),
 	json_read_dict(Input_stream, Dict),
 	close(Input_stream),
    json_to_book_description(Dict, Books),
    write_description(Books).


json_to_book_description(Dict, Dict.items). % reads the key-value pairs in the JSON dict

% prints out the description of the books
write_description([]).
write_description([Book|T]) :-
    Description = Book.volumeInfo.description,
    string_concat(Description, "\n\n", Description1),
    write(Description1),
    write_description(T).


% TODO:
% clean up the API function
% have it print only top 5 results (URL would have & maxResults=5 added)
% have it print title, author and description

 

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


    


