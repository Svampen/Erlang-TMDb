{application,erltmdb,
             [{description,"Erlang TMDb"},
              {vsn,"0.0.1"},
              {applications,[stdlib,kernel]},
              {mod,{erltmdb_app,[]}},
              {env,[{host,"http://api.themoviedb.org/2.1/"}]},
              {modules,[erltmdb_app,erltmdb_lib,erltmdb_movie,erltmdb_sup]}]}.
