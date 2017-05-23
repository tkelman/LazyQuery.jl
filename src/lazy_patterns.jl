export with
with(table, with_context::LazyContext.WithContext) = begin
    with_context_copy = copy(with_context)
    merge!(with_context_copy.environment, table)
    LazyContext.evaluate(with_context_copy)
end
"""
    with(w::LazyContext.WithContext, with_context)

Evaluate `with_context` in an environment including `w`.

```jldoctest
julia> using LazyContext

julia> import LazyQuery

julia> @new_environment;

julia> @use_in_environment LazyQuery;

julia> @evaluate begin
           d = Dict(:a => 1, :b => 2)
           @with d a + b
       end
3
```

All other lazy functions in the package are based on `with`.
"""
with(w::LazyContext.WithContext, with_context::LazyContext.WithContext) = with(LazyContext.evaluate!(w), with_context)

evaluate_to_numbers(afunction, table, args) = begin
    args_evaluated = map(args) do arg
        with(numbered_names(table), arg)
    end
    afunction(table, args_evaluated...)
end
evaluate_to_numbers(afunction, w::LazyContext.WithContext, args) =
    evaluate_to_numbers(afunction, LazyContext.evaluate!(w), args)

make_kw(table, with_context) = begin
    MacroTools.@match with_context.expression begin
        ( a_ = b_ ) => (
            a,
            with(table,
                LazyContext.WithContext(b, with_context.environment) )
        )
        a_ => error("Expected an assignment or keyword")
    end
end

evaluate_keywords(afunction, table, args) = begin
    kwargs = map(args) do arg
        make_kw(table, arg)
    end
    afunction(table; kwargs...)
end
evaluate_keywords(afunction, w::LazyContext.WithContext, args) =
    evaluate_keywords(afunction, LazyContext.evaluate!(w), args)
