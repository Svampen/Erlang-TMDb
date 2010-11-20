%%%-------------------------------------------------------------------
%%% @author  Stefan Hagdahl <>
%%% @copyright (C) 2010,  Stefan Hagdahl
%%% @doc
%%%
%%% @end
%%% Created : 19 Nov 2010 by  Stefan Hagdahl <>
%%%-------------------------------------------------------------------
-module(erltmdb_movie).

-include_lib("xmerl/include/xmerl.hrl").

-export([search/3]).

-record(image, {
	  type,
	  url
	 }).

-record(movie, {
	  key = 0,
	  score,
	  name,
	  id,
	  imdb_id,
	  url,
	  images :: [#image{}],
	  version
	  }).

search(Language, APIKey, Movie) 
  when is_list(Language), is_list(APIKey), is_list(Movie) ->
    Url = lists:concat(["Movie.search/", Language,
			"/xml/", APIKey, "/", Movie]),
    XmlString = erltmdb_lib:get(Url),
    EtsRef = ets:new(movies, [set, {keypos, #movie.key}]),
    Fun = fun(Entity, GlobalState) ->		  
		  parse_search(Entity, GlobalState)
	  end,
    xmerl_scan:string(XmlString, [{hook_fun, Fun}, {user_state, {EtsRef, 0}}]),
    ets:tab2list(EtsRef).


parse_search(#xmlElement{name=movie, expanded_name=movie}=Entity,
	     GlobalState) ->
    {EtsRef, Key} = xmerl_scan:user_state(GlobalState),
    NewGlobalState = xmerl_scan:user_state({EtsRef, Key+1}, GlobalState),
    {Entity, NewGlobalState};

parse_search(#xmlText{parents=[{score, _}|_Rest],
		      value=Value}=Entity, GlobalState) ->
    {EtsRef, Key} = xmerl_scan:user_state(GlobalState),
    Movie = #movie{key=Key, score=Value},
    ets:insert(EtsRef, Movie),
    NewGlobalState = xmerl_scan:user_state({EtsRef, Key}, GlobalState),
    {Entity, NewGlobalState};

parse_search(#xmlText{parents=[{name, _}|_Rest],
		      value=Value}=Entity, GlobalState) ->
    {EtsRef, Key} = xmerl_scan:user_state(GlobalState),
    ets:update_element(EtsRef, Key, {#movie.name, Value}),
    NewGlobalState = xmerl_scan:user_state({EtsRef, Key}, GlobalState),
    {Entity, NewGlobalState};

parse_search(#xmlText{parents=[{id, _}|_Rest],
		      value=Value}=Entity, GlobalState) ->
    {EtsRef, Key} = xmerl_scan:user_state(GlobalState),
    ets:update_element(EtsRef, Key, {#movie.id, Value}),
    NewGlobalState = xmerl_scan:user_state({EtsRef, Key}, GlobalState),
    io:format("Id ~p~n", [Value]),
    {Entity, NewGlobalState};

parse_search(#xmlText{parents=[{imdb_id, _}|_Rest],
		      value=Value}=Entity, GlobalState) ->
    {EtsRef, Key} = xmerl_scan:user_state(GlobalState),
    ets:update_element(EtsRef, Key, {#movie.imdb_id, Value}),
    NewGlobalState = xmerl_scan:user_state({EtsRef, Key}, GlobalState),
    {Entity, NewGlobalState};

parse_search(#xmlText{parents=[{url, _}|_Rest],
		      value=Value}=Entity, GlobalState) ->
    {EtsRef, Key} = xmerl_scan:user_state(GlobalState),
    ets:update_element(EtsRef, Key, {#movie.url, Value}),
    NewGlobalState = xmerl_scan:user_state({EtsRef, Key}, GlobalState),
    {Entity, NewGlobalState};

%% parse_search(#xmlText{parents=[{image, _}|_Rest],
%% 		      value=Value}=Entity, GlobalState) ->
%%     io:format("Images ~p~n", [Value]),
%%     {Entity, GlobalState};

parse_search(#xmlText{parents=[{version, _}|_Rest],
		      value=Value}=Entity, GlobalState) ->
    {EtsRef, Key} = xmerl_scan:user_state(GlobalState),
    ets:update_element(EtsRef, Key, {#movie.version, Value}),
    NewGlobalState = xmerl_scan:user_state({EtsRef, Key}, GlobalState),
    {Entity, NewGlobalState};

parse_search(Entity, GlobalState) ->
    {Entity, GlobalState}.
