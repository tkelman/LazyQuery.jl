module LazyQuery

import LazyContext
import DataFrames
import MacroTools

include("utilities.jl")
include("standard_evaluation.jl")
include("lazy_patterns.jl")
include("query_verbs.jl")

end
