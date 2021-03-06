%%%-------------------------------------------------------------------
%%% @author  <Stefan@STEFAN-PC>
%%% @copyright (C) 2010, 
%%% @doc
%%%
%%% @end
%%% Created : 20 Nov 2010 by  <Stefan@STEFAN-PC>
%%%-------------------------------------------------------------------
-module(erltmdb_lib).

-export([get/1]).

get(Url) ->
    {ok, Host} = application:get_env(erltmdb, host),
    {ok, {_, _, Body}} = httpc:request(lists:concat([Host, Url])),
    Body.
