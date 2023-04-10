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
    write_list(Author),
    write("\n"),

    % writes description
    string_concat('Description: ', Description, Description1),
    write(Description1),
    write("\n\n"),
    
    % recursive call
    write_results(T).

/*
% writes out the authors since it is a list
write_author([]).
write_author([H|T]) :-
    write(H),
    write(","),
    write_author(T).
*/

% writes out the list
write_list([]).
write_list([H|T]) :-
    write(H),
    write(", "),
    write_list(T).   

% call api to print out book arthor
call_api_author(URL) :-
    http_open(URL, Input_stream, []),
 	json_read_dict(Input_stream, Dict),
 	close(Input_stream),
    json_to_book_description(Dict, Books),
    write_author_name(Books).

% writes out the author name
write_author_name([]).
write_author_name([Book|_]) :-
    Author = Book.volumeInfo.authors,
    write('Author(s): '),
    write_list(Author).

% call api to print out book title
call_api_title(URL) :-
    http_open(URL, Input_stream, []),
 	json_read_dict(Input_stream, Dict),
 	close(Input_stream),
    json_to_book_description(Dict, Books),
    write_title(Books).

% writes out the book title
write_title([]).
write_title([Book|_]) :-
    Title = Book.volumeInfo.title,
    write('Title: '),
    write(Title).

% call api to print out book genre
call_api_genre(URL) :-
    http_open(URL, Input_stream, []),
 	json_read_dict(Input_stream, Dict),
 	close(Input_stream),
    json_to_book_description(Dict, Books),
    write_genre(Books).

% writes out the book genre
write_genre([]).
write_genre([Book|_]) :-
    Genre = Book.volumeInfo.categories,
    write('Genre(s): '),
    write_list(Genre).


%% Building URL %%

% Create a URL for search term
% example query: create_url(["harry", "potter"], URL).

create_url(Terms, URL) :-
    url_root(Root),
    append_search_term(Terms, Root, URL).

% base case
append_search_term([], URL, URL).

% append last search term and API key to URL
append_search_term([Last], URL, URL_final) :-
    apikey(Key),
    string_concat(URL, Last, URL1),
    string_concat(URL1, "&maxResults=5&key=", URL2),
    string_concat(URL2, Key, URL_final).

% recursive case: append next search term
append_search_term([Term|T], URL, URL_final) :-
    string_concat(URL, Term, URL1),
    string_concat(URL1,"+",URL2),
    append_search_term(T, URL2, URL_final).


    


