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
% function for url building, not tested, just in draft mode

% need special case for first case 
append_search_term([], _).

append_search_term([Term|T], url) :-
    string_concat(url, Term, url1),
    string_concat(url1,"+",url_final),
    append_search_term(T, url_final).

% need special case for last case
% last case needs to attach the api key instead of plus
append_search_term([Last], url) :-
    string_concat(url, Last, url1),
    string_concat(url1, "&key=", url2),
    string_concat(url2, apikey, url_final).
    


