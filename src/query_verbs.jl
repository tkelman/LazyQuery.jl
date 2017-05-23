export choose_from
"""
    choose_from(w::LazyContext.WithContext, args...)

Evaluate `with_context` in an environment including `w`.

```jldoctest
julia> import LazyContext, LazyQuery, DataFrames

julia> LazyContext.@new_environment;

julia> LazyContext.@use_in_environment DataFrames LazyQuery;

julia> LazyContext.@evaluate begin
           d = DataFrame(a = 1, b = 2, c = 3, d = 4)
           (@choose_from d a c:d) == (@choose_from d -b)
       end
true
```
"""
choose_from(w::LazyContext.WithContext, args...) =
    evaluate_to_numbers(choose_from, w, args)

export add_to
"""
    add_to(w::LazyContext.WithContext, args...)

Add to `w`, evaluating `args` in context.

```jldoctest
julia> import LazyContext, LazyQuery

julia> LazyContext.@new_environment;

julia> LazyContext.@use_in_environment LazyQuery;

julia> LazyContext.@evaluate begin
           d = Dict(:a => 1, :b => 2);
           @add_to d c = a + b
       end == Dict(:a => 1, :b => 2, :c => 3)
true
```
"""
add_to(w::LazyContext.WithContext, args...) =
    evaluate_keywords(add_to, w, args)

export make_from
"""
    make_from(w::LazyContext.WithContext, args...)

Make a new object from `w`, evaluating `args` in context.

```jldoctest
julia> import LazyContext, LazyQuery

julia> LazyContext.@new_environment;

julia> LazyContext.@use_in_environment LazyQuery;

julia> :azyContext.@evaluate begin
           d = Dict(:a => 1, :b => 2)
           @make_from(d, c = a + b, d = b - a)
       end == Dict(:c => 3, :d => 1)
true
```
"""
make_from(w::LazyContext.WithContext, args...) =
    evaluate_keywords(make_from, w, args)

export rows_where
"""
    rows_where(w::LazyContext.WithContext, rows)

Get `rows` from `w`, evaluating `rows` in context.

```jldoctest
julia> import LazyContext, LazyQuery, DataFrames

julia> LazyContext.@new_environment;

julia> LazyContext.@use_in_environment LazyQuery DataFrames;

julia> LazyContext.@evaluate begin
           d = DataFrame(a = [1, 2, 3], b = [3, 2, 1] )
           @rows_where d a .== b
       end
1×2 DataFrames.DataFrame
│ Row │ a │ b │
├─────┼───┼───┤
│ 1   │ 2 │ 2 │
```
"""
rows_where(w::LazyContext.WithContext, rows) = begin
    table = LazyContext.evaluate!(w)
    rows_where(table, with(table, rows) )
end

DataFrames.groupby(w::LazyContext.WithContext, args...) =
    evaluate_to_numbers(DataFrames.groupby, w, args)

DataFrames.rename(w::LazyContext.WithContext, args...) =
    quote_keywords_to_dict(DataFrames.rename, w, args)
