# LazyQuery.jl

This package is currently a proof-of-concept for lazy-evaluation based
table querying. It is built on `LazyContext.jl`. It only supports `DataFrames`
at the moment, but there is no reason the package can't be extended to other
tabular data structures.

```jldoctest
julia>  using LazyContext, ChainRecursive, LazyQuery, DataFrames;

julia>  LazyContext.@new_environment;

julia>  LazyContext.@use_in_environment DataFrames LazyQuery;

julia>  ChainRecursive.@chain LazyContext.@evaluate begin
            DataFrame(
                a = [1, 1, 2, 2, 3, 3],
                be = [1, 3, 2, 4, 3, 5],
                C = [5, 3, 4, 2, 3, 1] )
            @rename it b = be c = C
            @add_to(it,
                d = b .+ c,
                e = b .- a)
            @choose_from it -c
            @rows_where it a .> 1
            @groupby it e
            map(it) do subframe
                @make_from(subframe,
                    f = sum(a),
                    g = mean(b)
                )
            end
            combine(it)
        end
2×3 DataFrames.DataFrame
│ Row │ e │ f │ g   │
├─────┼───┼───┼─────┤
│ 1   │ 0 │ 5 │ 2.5 │
│ 2   │ 2 │ 5 │ 4.5 │
```

```@index
```

```@autodocs
Modules = [LazyQuery]
```
