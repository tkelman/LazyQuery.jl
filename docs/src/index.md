# LazyQuery.jl

This package is currently a proof-of-concept for lazy-evaluation based
table querying. It is built on `LazyContext.jl`. It only supports `DataFrames`
at the moment, but there is no reason the package can't be extended to other
tabular data structures.

```jldoctest
julia>  using LazyContext, ChainRecursive; @new_environment;

julia>  import LazyQuery, DataFrames; @use_in_environment DataFrames LazyQuery;

julia>  @chain @evaluate begin
            DataFrame(
                a = [1, 1, 2, 2, 3, 3],
                b = [1, 3, 2, 4, 3, 5],
                c = [5, 3, 4, 2, 3, 1] )
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
