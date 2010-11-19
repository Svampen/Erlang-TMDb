{application,erltmdb,
             [{description,"Erlang TMDb"},
              {vsn,"0.0.1"},
              {applications,[stdlib,kernel]},
              {mod,{erltmdb_app,[erltmdb_app,erltmdb_sup]}},
              {env,[{host,"http://api.themoviedb.org/2.1/"}]},
              {modules,[erltmdb_app,erltmdb_sup]}]}.
