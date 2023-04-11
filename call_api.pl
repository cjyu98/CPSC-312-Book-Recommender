% calls and prints the results from the Google Books API

%% API %%

% call_api
% call the API, parses the returned JSON file, prints out the top 5 results
call_api(URL) :- 
    write('Calling GoogleBooks API'),
    write("\n\n"),
    http_open(URL, Input_stream, []),
 	json_read_dict(Input_stream, Dict),
 	close(Input_stream),
    json_to_book_description(Dict, Books),
    write_results(Books).

% json_to_book_description
% reads the key-value pairs in the JSON dict
json_to_book_description(Dict, Dict.items). 

% write_results
% prints out the title, author and description of the results from the JSON file returned from the API
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


% write_list
% writes out a list
write_list([]).
write_list([H|T]) :-
    write(H),
    write(", "),
    write_list(T).   

%% Specific categories for API %%

% read_api
% call the API, parses the returned JSON file
read_api(URL, Books) :-
    http_open(URL, Input_stream, []),
 	json_read_dict(Input_stream, Dict),
 	close(Input_stream),
    json_to_book_description(Dict, Books).

% call_api_author
% calls the API to print out the author of the first result
call_api_author(URL) :-
    read_api(URL, Books),
    write_author_name(Books).

% write_author_name
% writes out the author name
write_author_name([]) :-
    write('No more answers'). 
write_author_name([Book|_]) :-
    Author = Book.volumeInfo.authors,
    nl,
    write('Author(s): '),
    write_list(Author).  

% call_api_title
% call APIs to print out book title of the first result
call_api_title(URL) :-
    read_api(URL, Books),
    write_title(Books).

% write_title
% writes out the book title
write_title([]) :- 
    write('No more answers').
write_title([Book|_]) :-
    Title = Book.volumeInfo.title,
    nl,
    write('Title: '),
    write(Title).

% call_api_genre
% call API to print out book genre of the first result
call_api_genre(URL) :-
    read_api(URL, Books),
    write_genre(Books).

% write_genre
% writes out the book genre
write_genre([]) :- 
    write('No more answers').
write_genre([Book|_]) :-
    Genre = Book.volumeInfo.categories,
    nl,
    write('Genre(s): '),
    write_list(Genre).

% call_api_description
% call API to print out book description of the first result
call_api_description(URL) :-
    read_api(URL, Books),
    write_description(Books).

% write_descrption
% writes out the book description of the first result
write_description([]).
write_description([Book|_]) :-
    Description = Book.volumeInfo.description,
    nl,
    write('Description: '),
    write(Description).

%% Building URL %%

% create_url(Terms, URL)
% create a URL from Terms, where Terms is a list of search terms from user input (e.g. ["harry", "potter"])
create_url(Terms, URL) :-
    url_root(Root),
    append_search_term(Terms, Root, URL).

% append_search_term(Terms,URL,URL_final) 
% appends each search term from Terms and API key to URL and returns URL_final to use to call the API

% final case: all terms have been added
append_search_term([],URL,URL_final):-
    apikey(Key),
    %string_concat(URL, Last, URL1),
    string_concat(URL, '&maxResults=5&key=', URL2),
    string_concat(URL2, Key, URL_final).

% recursive case: append next search term
append_search_term([Term|T], URL, URL_final) :-
    string_concat(URL, Term, URL1),
    string_concat(URL1,"+",URL2),
    append_search_term(T, URL2, URL_final).



