% Ask query and search API
% Source: https://www.cs.ubc.ca/~poole/cs312/2023/prolog/geography_query_string.pl
%         https://www.cs.ubc.ca/~poole/cs312/2023/prolog/cfg_simple.pl
%         https://www.cs.ubc.ca/~poole/cs312/2023/prolog/geography_string.pl

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
adj(["top",  "result", "of" | L],L).


key_words(["author", "of" | L],L) :-
    search_author(L).
key_words(["title", "of" | L],L) :-
    search_title(L).
key_words(["genre", "of" | L],L) :-
    search_genre(L).

search_author(Terms) :-
    create_url(Terms, URL),
    call_api_author(URL).

search_title(Terms) :-
    create_url(Terms, URL),
    call_api_title(URL).

search_genre(Terms) :-
    create_url(Terms, URL),
    call_api_genre(URL).


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
question(["Give me" | L0],L1) :-
    sentence(L0,L1).

% ask(Q) calls api to answer question Q
ask(Q) :-
% TODO: fix the bug that caused question(Q, []) to returns false
    question(Q, A).


% To get the input from a line:

q(Ans) :-
    write("Please ask questions related to book titles, authors, or genres: "), nl, nl,
    read_line_to_string(user_input, St), 
    split_string(St, " -", " ,?.!-", Ln), % ignore punctuation
    ask(Ln), nl.
q(Ans) :-
    write("No more answers\n"),
    q(Ans).

