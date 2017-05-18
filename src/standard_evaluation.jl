numbered_names(table) = zip(names(table), 1:length(table) )

is_negative(x) = x < zero(x)

choose_from(table, args...) = begin
    numbers = vcat(args...)
    select_numbers = if all(is_negative, numbers)
        setdiff(1:length(table), -numbers)
    elseif any(is_negative, numbers)
        error("Cannot mix positive and negative indices")
    else
        numbers
    end
    table[select_numbers]
end

add_to(table; kwargs...) = begin
    table_copy = copy(table)
    for (key, value) in kwargs
        table_copy[key] = value
    end
    table_copy
end

make_from(table; kwargs...) = begin
    new_table = typeof(table)()
    for (key, value) in kwargs
        new_table[key] = value
    end
    new_table
end

make_from(table::DataFrames.SubDataFrame;  kwargs...) = begin
    new_table = DataFrames.DataFrame()
    for (key, value) in kwargs
        new_table[key] = value
    end
    new_table
end

rows_where(table, rows) = table[rows, :]
