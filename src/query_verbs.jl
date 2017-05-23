export choose_from
"""
    choose_from(w::LazyContext.WithContext, args...)

Evaluate `with_context` in an environment including `w`.

```jldoctest
julia> using LazyContext; @new_environment;

julia> import LazyQuery, DataFrames; @use_in_environment DataFrames LazyQuery;

julia> @evaluate begin
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
julia> using LazyContext; @new_environment;

julia> import LazyQuery; @use_in_environment LazyQuery;

julia> @evaluate begin
           d = Dict(:a => 1, :b => 2);
           @add_to d c = a + b
       end
Dict{Symbol,Int64} with 3 entries:
  :a => 1
  :b => 2
  :c => 3
```
"""
add_to(w::LazyContext.WithContext, args...) =
    evaluate_keywords(add_to, w, args)

export make_from
"""
    make_from(w::LazyContext.WithContext, args...)

Make a new object from `w`, evaluating `args` in context.

```jldoctest
julia> using LazyContext; @new_environment;

julia> import LazyQuery; @use_in_environment LazyQuery;

julia> @evaluate begin
           d = Dict(:a => 1, :b => 2)
           @make_from(d, c = a + b, d = b - a)
       end
Dict{Symbol,Int64} with 2 entries:
  :d => 1
  :c => 3
```
"""
make_from(w::LazyContext.WithContext, args...) =
    evaluate_keywords(make_from, w, args)

export rows_where
"""
    rows_where(w::LazyContext.WithContext, rows)

Get `rows` from `w`, evaluating `rows` in context.

```jldoctest
julia> using LazyContext; @new_environment;

julia> import LazyQuery, DataFrames; @use_in_environment LazyQuery DataFrames;

julia> @evaluate begin
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
