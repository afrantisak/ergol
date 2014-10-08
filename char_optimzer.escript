#!/usr/bin/env escript

-record(function_definition, {name, args, body}).

main(_)->
    Function_definition = #function_definition{name = "a", args = ["L"], body = "length(L)"},
    print_compare(2, Function_definition).

print_compare(Invocations, Function_definition) ->
    Named_total = named_function_char_usage(Invocations, Function_definition),
    Named_definition = named_function_definition_str(Function_definition),
    Named_invocation = named_function_invocation_str(Function_definition),
    io:format("Named: ~p chars~n", [Named_total]),
    io:format("~p: ~w~n", [length(Named_definition), Named_definition]),
    io:format("~p(x~p): ~s~n", [length(Named_invocation), Invocations, Named_invocation]),
    io:format("~n"),
    Inline_total = inline_function_char_usage(Invocations, Function_definition),
    Inline_invocation = inline_function_invocation_str(Function_definition),
    io:format("Inline: ~p chars~n", [Inline_total]),
    io:format("~p(~p): ~s~n", [length(Inline_invocation), Invocations, Inline_invocation]),
    io:format("~n"),
    Anony_total = anony_function_char_usage(Invocations, Function_definition),
    Anony_invocation = anony_function_invocation_str(Function_definition),
    io:format("Anony: ~p chars~n", [Anony_total]),
    io:format("~p(~p): ~s~n", [length(Anony_invocation), Invocations, Anony_invocation]).

args_str(Args) ->
    string:join(Args, ",").

named_function_char_usage(Invocations, Function_definition) ->
    Definition_length = length(named_function_definition_str(Function_definition)),
    Invocation_length = length(named_function_invocation_str(Function_definition)),
    Definition_length + (Invocations * Invocation_length).

named_function_definition_str(#function_definition{name = Name, args = Args, body = Body}) ->
    Str = io_lib:format("~s(~s)->~s.", [Name, args_str(Args), Body]),
    lists:flatten(Str).

named_function_invocation_str(#function_definition{name = Name, args = Args}) ->
    io_lib:format("~s(~s)", [Name, args_str(Args)]).

inline_function_char_usage(Invocations, Function_definition) ->
    Invocation_length = length(inline_function_invocation_str(Function_definition)),
    Invocations * Invocation_length.

inline_function_invocation_str(#function_definition{body = Body}) ->
    Body.

anony_function_char_usage(Invocations, Function_definition) ->
    Invocation_length = length(anony_function_invocation_str(Function_definition)),
    Invocations * Invocation_length.

anony_function_invocation_str(#function_definition{args = Args, body = Body}) ->
    Needs_space = is_alpha(lists:last(Body)),
    End_of_body_space = case Needs_space of
                            true -> " ";
                            _ -> ""
                        end,
    Str = io_lib:format("fun(~s)->~s~send.", [args_str(Args), Body, End_of_body_space]),
    lists:flatten(Str).

%% Decide if string is composed of alphanumeric characters.
is_alpha([Char | Rest]) when Char >= $a, Char =< $z ->
    is_alpha(Rest);
is_alpha([Char | Rest]) when Char >= $A, Char =< $Z ->
    is_alpha(Rest);
is_alpha([Char | Rest]) when Char >= $0, Char =< $9 ->
    is_alpha(Rest);
is_alpha([]) ->
    true;
is_alpha(_) ->
    false.
