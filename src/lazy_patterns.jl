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
julia> import LazyContext, LazyQuery

julia> LazyContext.@new_environment;

julia> LazyContext.@use_in_environment LazyQuery;

julia> LazyContext.@evaluate begin
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


decompose_assignment(e) =
    MacroTools.@match e begin
        ( key_ = value_ ) => (key, value)
        any_ => error("Expected an assignment or keyword")
    end

evaluate_keyword(table, with_context) = begin
    key, value = decompose_assignment(with_context.expression)
    key, with(table, LazyContext.WithContext(value, with_context.environment))
end

evaluate_keywords(afunction, table, args) = begin
    kwargs = map(args) do arg
        evaluate_keyword(table, arg)
    end
    afunction(table; kwargs...)
end

evaluate_keywords(afunction, w::LazyContext.WithContext, args) =
    evaluate_keywords(afunction, LazyContext.evaluate!(w), args)

quote_keyword_to_pair(with_context) = begin
    key, value = decompose_assignment(with_context.expression)
    value => key
end

quote_keywords_to_dict(afunction, table, args) =
    afunction(table, Dict(quote_keyword_to_pair.(args)...) )

quote_keywords_to_dict(afunction, w::LazyContext.WithContext, args) =
    quote_keywords_to_dict(afunction, LazyContext.evaluate!(w), args)
