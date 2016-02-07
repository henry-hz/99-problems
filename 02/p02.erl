% Find the last box of a list
-module(p02).
-compile(export_all).
-include_lib("eunit/include/eunit.hrl").


find1([H,_])   -> H;
find1([H|T]) ->
    find1(T).

% unit tests
find1_test() ->
    ?assertEqual(2,find1([1,2,3,2,4])).

