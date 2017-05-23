var documenterSearchIndex = {"docs": [

{
    "location": "index.html#",
    "page": "Home",
    "title": "Home",
    "category": "page",
    "text": ""
},

{
    "location": "index.html#LazyQuery.add_to-Tuple{LazyContext.WithContext,Vararg{Any,N} where N}",
    "page": "Home",
    "title": "LazyQuery.add_to",
    "category": "Method",
    "text": "add_to(w::LazyContext.WithContext, args...)\n\nAdd to w, evaluating args in context.\n\njulia> import LazyContext, LazyQuery\n\njulia> LazyContext.@new_environment;\n\njulia> LazyContext.@use_in_environment LazyQuery;\n\njulia> LazyContext.@evaluate begin\n           d = Dict(:a => 1, :b => 2);\n           @add_to d c = a + b\n       end == Dict(:a => 1, :b => 2, :c => 3)\ntrue\n\n\n\n"
},

{
    "location": "index.html#LazyQuery.choose_from-Tuple{LazyContext.WithContext,Vararg{Any,N} where N}",
    "page": "Home",
    "title": "LazyQuery.choose_from",
    "category": "Method",
    "text": "choose_from(w::LazyContext.WithContext, args...)\n\nEvaluate with_context in an environment including w.\n\njulia> import LazyContext, LazyQuery, DataFrames\n\njulia> LazyContext.@new_environment;\n\njulia> LazyContext.@use_in_environment DataFrames LazyQuery;\n\njulia> LazyContext.@evaluate begin\n           d = DataFrame(a = 1, b = 2, c = 3, d = 4)\n           (@choose_from d a c:d) == (@choose_from d -b)\n       end\ntrue\n\n\n\n"
},

{
    "location": "index.html#LazyQuery.make_from-Tuple{LazyContext.WithContext,Vararg{Any,N} where N}",
    "page": "Home",
    "title": "LazyQuery.make_from",
    "category": "Method",
    "text": "make_from(w::LazyContext.WithContext, args...)\n\nMake a new object from w, evaluating args in context.\n\njulia> import LazyContext, LazyQuery\n\njulia> LazyContext.@new_environment;\n\njulia> LazyContext.@use_in_environment LazyQuery;\n\njulia> LazyContext.@evaluate begin\n           d = Dict(:a => 1, :b => 2)\n           @make_from(d, c = a + b, d = b - a)\n       end == Dict(:c => 3, :d => 1)\ntrue\n\n\n\n"
},

{
    "location": "index.html#LazyQuery.rows_where-Tuple{LazyContext.WithContext,Any}",
    "page": "Home",
    "title": "LazyQuery.rows_where",
    "category": "Method",
    "text": "rows_where(w::LazyContext.WithContext, rows)\n\nGet rows from w, evaluating rows in context.\n\njulia> import LazyContext, LazyQuery, DataFrames\n\njulia> LazyContext.@new_environment;\n\njulia> LazyContext.@use_in_environment LazyQuery DataFrames;\n\njulia> LazyContext.@evaluate begin\n           d = DataFrame(a = [1, 2, 3], b = [3, 2, 1] )\n           @rows_where d a .== b\n       end\n1×2 DataFrames.DataFrame\n│ Row │ a │ b │\n├─────┼───┼───┤\n│ 1   │ 2 │ 2 │\n\n\n\n"
},

{
    "location": "index.html#LazyQuery.with-Tuple{LazyContext.WithContext,LazyContext.WithContext}",
    "page": "Home",
    "title": "LazyQuery.with",
    "category": "Method",
    "text": "with(w::LazyContext.WithContext, with_context)\n\nEvaluate with_context in an environment including w.\n\njulia> import LazyContext, LazyQuery\n\njulia> LazyContext.@new_environment;\n\njulia> LazyContext.@use_in_environment LazyQuery;\n\njulia> LazyContext.@evaluate begin\n           d = Dict(:a => 1, :b => 2)\n           @with d a + b\n       end\n3\n\nAll other lazy functions in the package are based on with.\n\n\n\n"
},

{
    "location": "index.html#LazyQuery.jl-1",
    "page": "Home",
    "title": "LazyQuery.jl",
    "category": "section",
    "text": "This package is currently a proof-of-concept for lazy-evaluation based table querying. It is built on LazyContext.jl. It only supports DataFrames at the moment, but there is no reason the package can't be extended to other tabular data structures.julia>  import LazyContext, ChainRecursive, LazyQuery, DataFrames;\n\njulia>  LazyContext.@new_environment;\n\njulia>  LazyContext.@use_in_environment DataFrames LazyQuery;\n\njulia>  ChainRecursive.@chain LazyContext.@evaluate begin\n            DataFrame(\n                a = [1, 1, 2, 2, 3, 3],\n                be = [1, 3, 2, 4, 3, 5],\n                C = [5, 3, 4, 2, 3, 1] )\n            @rename it b = be c = C\n            @add_to(it,\n                d = b .+ c,\n                e = b .- a)\n            @choose_from it -c\n            @rows_where it a .> 1\n            @groupby it e\n            map(it) do subframe\n                @make_from(subframe,\n                    f = sum(a),\n                    g = mean(b)\n                )\n            end\n            combine(it)\n        end\n2×3 DataFrames.DataFrame\n│ Row │ e │ f │ g   │\n├─────┼───┼───┼─────┤\n│ 1   │ 0 │ 5 │ 2.5 │\n│ 2   │ 2 │ 5 │ 4.5 │Note that the anonymous do block above is slow; a new environment is set up containing the contents of a subframe is set up each time it is called. In fact, given a bit more work, @make_from could be called directly on a GroupedDataFrame. At the moment, this package is in the proof-of-concept stage.Modules = [LazyQuery]"
},

]}
