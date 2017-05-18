LazyContext.immutable_merge(d, a::DataFrames.AbstractDataFrame) = begin
    for name in names(a)
        d = Base.ImmutableDict(d, name => a[name])
    end
    d
end
