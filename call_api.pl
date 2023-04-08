% calls and prints the results from the API

%% API %%

% test query: call_api("https://www.googleapis.com/books/v1/volumes?q=the+goldfinch&key=AIzaSyCDCSCwN5M95LfkkLtw5wQ8kkaRA-wBYqM"). 
% call the api, parses the returned JSON file to print out the top 5 results
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
% have it print only top 5 results (URL would have &maxResults=5 added)

%% Building URL %%

% example query: create_url(["harry", "potter"], URL).
% creates a URL for search term
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


    


