% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/format.R
\name{strs_format}
\alias{strs_format}
\title{String Interpolation with Data Support}
\usage{
strs_format(string, ..., .data = NULL)
}
\arguments{
\item{string}{A character vector containing the string with placeholders in curly braces \code{{}}. If the vector contains
more than one string, they are concatenated before interpolation.}

\item{...}{Named arguments that will be made available during \code{string} interpolation. Note that these will take
precedence over values in \code{.data}.}

\item{.data}{List-like (e.g., data.frame, list, environment, etc.) object that will be used for lookups during
\code{string} interpolation.}
}
\value{
A character vector with the placeholders replaced by the evaluated expressions.
}
\description{
The \code{strs_format} function provides string interpolation using values from a data argument, similar to Python's
\code{str.format} method. For more information, see the details.
}
\details{
Under the hood, this function uses the \code{glue::glue_data()} function to perform the interpolation. By
default, this function will only use the variables provided in \code{...} and \code{.data}. It will NOT use the immediate
environment to perform the interpolations. If any interpolated expression is NA, it will be NA in the output. If any
interpolated expression is NULL, it will be NULL in the output.
}
\examples{
# Using a named list for substitutions
data_list <- list(name = "Alice", age = 30)
strs_format("My name is {name} and I am {age} years old.", .data = data_list)
# Output: "My name is Alice and I am 30 years old."

# Using additional arguments
strs_format("My name is {name} and I am {age} years old.", name = "Bob", age = 25)
# Output: "My name is Bob and I am 25 years old."

}
