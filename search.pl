% Ask query and search API
% Source: https://www.cs.ubc.ca/~poole/cs312/2023/prolog/geography_query_string.pl
%         https://www.cs.ubc.ca/~poole/cs312/2023/prolog/cfg_simple.pl
%         https://www.cs.ubc.ca/~poole/cs312/2023/prolog/geography_string.pl


/*

Possible queries:

- Give me the first five results for To Kill a Mockingbird.
- What is an interesting book written by Madeline Miller?
- Who wrote The Catcher in the Rye?
- Who is the author of The Catcher in the Rye?
- I want the description of Anna Karenina.
- What is the genre of The Book Thief?

*/


% noun_phrase(L0,L4) is true if
%  L0 and L4 are list of words, such that
%        L4 is an ending of L0
%        the words in L0 before L4 (written L0-L4) form a noun phrase

% A noun phrase is a determiner followed by adjectives followed
% by a noun followed by an optional prepositional phrase.
noun_phrase(L0,L3) :- 
   det(L0,L1), 
   adjectives(L1,L2),
   noun(L2,L3).


% a verb phrase is a verb followed by a noun phrase and an optional pp
verb_phrase(L0,L2) :- 
    verb(L0,L1), 
    key_words(L1,L2).


verb(["written", "by" | L],L) :-
    search_title(L).
verb(["wrote" | L],L) :-
    search_author(L).
verb(L,L).


noun(["book" | L],L).
% noun(["name", "of" | L] L).
noun(L,L).

% determiners
det(["the" | L],L).
det(["a" | L],L).
det(["an" | L],L).
det(L,L).

% adjectives is a sequence of adjectives
adjectives(L,L). % no adjectives
adjectives(L0,L2) :-
    adj(L0,L1),
    adjectives(L1,L2).


% a sentence is a noun phrase followed by a verb phrase.
sentence(L0,L2) :- 
    noun_phrase(L0,L1), 
    verb_phrase(L1,L2).
   

% DICTIONARY
% adj(L0,L1) is true if L0-L1 is an adjective
adj(["interesting" | L],L).
adj(["cool" | L],L).
adj(["first" | L],L).


key_words(["author", "of" | L],L) :-
    search_author(L).
key_words(["title", "of" | L],L) :-
    search_title(L).
key_words(["genre", "of" | L],L) :-
    search_genre(L).
key_words(["description", "of" | L],L) :-
    search_description(L).
key_words(["five", "results", "for" | L], L) :-
    create_url(L, URL),
    call_api(URL).

search_author(Terms) :-
    create_url(Terms, URL),
    call_api_author(URL).


search_title(Terms) :-
    create_url(Terms, URL),
    call_api_title(URL).

search_genre(Terms) :-
    create_url(Terms, URL),
    call_api_genre(URL).

search_description(Terms) :-
    create_url(Terms, URL),
    call_api_description(URL).


% question(Question,QR) is true if Query provides an answer
question(["What","is" | L0], L1) :-
    sentence(L0,L1).
question(["What" | L0],L1) :-
    sentence(L0,L1).
question(["Who", "is" | L0],L1) :-
    sentence(L0,L1).
question(["Who"  | L0],L1) :-
    sentence(L0,L1).
question(["What", "kind" | L0],L1) :-
    sentence(L0,L1).
question(["Give", "me" | L0],L1) :-
    sentence(L0,L1).
question(["I", "want" | L0],L1) :-
    sentence(L0,L1).

question(_, []). % for when the other list is empty

% ask(Q) calls api to answer question Q
ask(Q) :-
    question(Q, _).



query_api:-
    write("Please ask questions related to book titles, authors, or genres: "), nl, nl,
    read(St), 
    split_string(St, " -", " ,?.!-", Ln), % ignore punctuation
    ask(Ln).



