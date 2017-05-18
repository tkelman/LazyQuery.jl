conditional_map(e) =
    if ChainRecursive.detected(e, :~)
        unwoven = LazyCall.unweave(e)
        unwoven.args[1] = map
        unwoven
    else
        e
    end

export with
with(table, with_context::WithContext) = begin
    with_context_copy = copy(with_context)
    with_context_copy.expression =
        conditional_map(with_context_copy.expression)
    merge!(with_context_copy.environment, table)
    evaluate(with_context_copy)
end
"""
    with(w::WithContext, with_context)

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

If `~` is detected in the expression, it is mapped using the rules in
`LazyCall`.

```jldoctest
julia> using LazyContext

julia> import LazyQuery

julia> @new_environment;

julia> @use_in_environment LazyQuery;

julia> @evaluate begin
           d = Dict(:a => [1, 2], :b => [2, 3])
           @with d vcat(~a, ~b)
       end
2-element Array{Array{Int64,1},1}:
 [1,2]
 [2,3]
```

All other lazy functions in the package are based on `with`.
"""
with(w::WithContext, with_context::WithContext) = with(evaluate!(w), with_context)

evaluate_to_numbers(afunction, table, args) = begin
    args_evaluated = map(args) do arg
        with(numbered_names(table), arg)
    end
    afunction(table, args_evaluated...)
end
evaluate_to_numbers(afunction, w::WithContext, args) =
    evaluate_to_numbers(afunction, evaluate!(w), args)

make_kw(table, with_context) = begin
    MacroTools.@match with_context.expression begin
        ( a_ = b_ ) => (
            a,
            with(table,
                WithContext(b, with_context.environment) )
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
evaluate_keywords(afunction, w::WithContext, args) =
    evaluate_keywords(afunction, evaluate!(w), args)
