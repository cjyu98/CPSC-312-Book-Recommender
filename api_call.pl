% testing file for api call, to be adjusted as we go on

% library - will likely need to move into main file
:- use_module(library(http/http_open)).
:- use_module(library(http/json)).

% Constants
apikey("AIzaSyCDCSCwN5M95LfkkLtw5wQ8kkaRA-wBYqM"). % linked to Carmen's Google account


% current test case: 
    % calling the api for searching the book "The Goldfinch"
    % for now, just printing out descriptions of top results as we test
    % will generalize later
    % testing URL: https://www.googleapis.com/books/v1/volumes?q=the+goldfinch&key=AIzaSyCDCSCwN5M95LfkkLtw5wQ8kkaRA-wBYqM
    % click URL to see how the JSON file returns


% call the api, printing out the book descriptions
call_api(URL) :- 
    write("calling api\n"),
    http_open(URL, Input_stream, []),
 	json_read_dict(Input_stream, Dict),
 	close(Input_stream),
    json_to_book_description(Dict, Books),
    write_description(Books).


json_to_book_description(Dict, Dict.items). % reads the key-value pairs in the JSON dict

write_description([]).
write_description([Book|T]) :-
    Description = Book.volumeInfo.description,
    string_concat(Description, "\n\n", Description1),
    write(Description1),
    write_description(T).










