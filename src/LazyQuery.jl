module LazyQuery

using LazyContext

import DataFrames
import LazyCall
import ChainRecursive
import MacroTools

include("utilities.jl")
include("standard_evaluation.jl")
include("lazy_patterns.jl")
include("query_verbs.jl")

end
