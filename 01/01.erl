% Find the last box of a list
-module(p01).
-compile(export_all).
-include_lib("eunit/include/eunit.hrl").




% https://github.com/rlander/99erlang/blob/master/problems.erl
% the find1 matches first the ([H|T]) argument. Why, because
% at this moment the list has more than one element. The ([H|T]) cuts the 
% list in to lists: [1], the Head, and [2,4], the Tail. As it arrives at 
% the find1(T), only [2,4] are evaluated, and the match is still at
% the ([H|T]) argument. Once again, it cuts in two values, [2] as Head and 
% [4] as Tails. Now, when find1 is called, the firt option ([H]) is matched,
% with the only one element in a list  argument. This last
% element [4] is then returned by the -> H expression.
find1([H])   -> H;
find1([H|T]) ->
    find1(T).


% https://github.com/KuldeepSinh/99Problems/blob/master/1_lists/my_list.erl
% similar to the find1 problems. The only difference is that the compiler does
% not complain about the H variable. And it makes sense, as '_' means 'anything
% else', is like an open door with the unique intention do slice the list in
% Head and Tails. So it's more expressive, once we already know that the Head
% will not be used directly form the function signature.

find2([H]) -> H;
find2([_|T]) ->
    find2(T).


% https://github.com/psholtz/99-Problems/blob/master/p99.erl
% here, the author did not had any economy in thinking about the best solution
% to optimize the memory too. The -spec for type checking will be not
% commented, once it's out of the scope (for a while ?). Take a look at the
% accumulator, so let's go together with a list of [7,3,1] numbers. The first
% match if for the landing function with arity = 1. Arity is the number of
% arguments a function takes. This function has a type guard, and if a no-list
% is sent to the first call, the type is not matched and an exception error is
% raised. Following the rule described in this book
% http://learnyousomeerlang.com/types-or-lack-thereof that we program on the
% expecte behaviour, and an unexpected behaviour should be known as soon as 
% it's possible, it's a cool feature to use in the landing function. The next
% ([H|T],_) function is called, so the Head is cut from the Tail, 
% Head = [7] and Tail = [3,1]. Recursivelly my_last([3,1],[7]) is called, and
% the match is the same ([H|T],_) function. Note, the Head of [3,1] is cut again,
% so the Head = [3], and Tail = [1]. So the match for the my_last([1],[3]) is
% still the same function ([H|T],_), and when we cut the Head, and set it
% Head=[1], the Tail will be an empty list, Tail = []. So now we are going to
% call my_last([], [1]), and the match will be the third option, my_last([],
% Acc), returning the Acc value, that is the last element of that list. 
%

-spec my_last(List) -> T when 
            List :: [T], 
                  T :: term().

my_last(L) when is_list(L) -> my_last(L, []).
my_last([H|T],_) -> my_last(T,H);
my_last([],Acc) -> Acc.



% https://github.com/cosgroveb/99-erlang-problems/blob/master/bbp.erl
% The author made here something slightly different. It seems at the firt
% glance that more complexity is added, compared with the first case. Anyway,
% let's go step by step. The landing method is the last([_,S|T]). Matching a
% list like this [A,B,C]=[1,2,3]. will assign values 1,2,3 to A,B,C, so A=1,
% B=2, and C=3. Something like [A,B,C]=[1,2,3,4]. will raise an error, but
% [A,B|C] = [1,2,3,4]. will do A=1, B=2, C=[3,4], because the '|' operator
% assign the list's tail to it. So, in our case, [4,3,2] (see the test below),
% _=4, S=3, and T=[2,7]. Note that the matching systems is selecting list's
% values for the _ and S variables, but for the tail 'T', the rest of the list
% is returned in the list's type. Now the function last will be called recurssively over
% the second and tail elements, i.e. the value 3, and [2,7] list. So, when calling
% last([S|T]), last([3,[2,7]]) is evaluated. Note, even that the 3 value was
% extracted from the list, because we are building list at the time of
% inserting the arguments into the function with [S|T], 3 becomes a list again,
% and T becomes a list [2,7] inside a list, [3,[2,7]]. So when arriving recurssively to
% last([_,S|T]), '_' helps us to discard the extracted value of 3, and S=2, ant
% T=[7]. Oh, the T variable receives a list type value, while S and _ receives
% number values. Calling last([S|T]) again, recurssively, converts S to be part
% of a list, and T as a list inside a list, forming the [2,[7]] argument, that
% will be matched again to the same last([_,S|T]) call. The reason that the T
% value is still not an empty list. Once the last([_,S|T]) is evaluated, _
% helps us to discard the 2 value, S colects the 7 from the list, so S=7, and
% finally the T value is equal an empty list, resulting T=[]. Now we arrived at
% our grand finale evaluation, matching the last([Last|[])) function, and
% returning the Last value, as 7. The last([]) will be used for the completely
% empty list cases.
%
last([]) -> [];
last([_,S|T]) -> last([S|T]);
last([Last|[]]) -> Last.



% https://github.com/kostyushkin/e-99/blob/master/src/p01.erl
%
last_e([_|T=[_|_]]) ->  last_e(T);
last_e(B = [_|[]])  ->  B.



% unit tests
find1_test() ->
    ?assertEqual(4,find1([1,2,4])).

find2_test() ->
    ?assertEqual(5,find2([3,7,5])).

my_last_test() ->
    ?assertEqual(1,my_last([7,3,1])).

last_test() ->
    ?assertEqual(7,last([4,3,2,7])).

