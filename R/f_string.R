#' Inline String Interpolation with Environment Variables
#'
#' The `strs_f` function allows for inline variable interpolation in strings, similar to Python's f-strings.
#'
#' @param string A character vector containing the string with placeholders in curly braces `{}`. If the vector contains
#' more than one string, they are concatenated before interpolation.
#' @return A character vector with the placeholders replaced by the evaluated expressions.
#' @details Under the hood, this function uses the `glue::glue_data()` function to perform the interpolation. However,
#' this function doesn't let you change the evaluation context or perform any string trimming. If any interpolated
#' expression is NA, it will be NA in the output. If any interpolated expression is NULL, it will be NULL in the output.
#'
#' @examples
#' name <- "Alice"
#' age <- 30
#' strs_f("My name is {name} and I am {age} years old.")
#' # Output: "My name is Alice and I am 30 years old."
#' age <- NULL
#' strs_f("My name is {name} and I am {age} years old.")
#' # Output: "My name is Alice and I am NULL years old."
#'
#' @export
strs_f <- function(string) {
  .data <- NULL
  .envir <- parent.frame(n = 1)
  if (!length(setdiff(names(.envir), c(".SDall", ".N", ".SD", ".NGRP", ".GRP", ".I")))) {
    # The function is being called within a data.table experession, which requires special handling.
    # See https://github.com/Rdatatable/data.table/issues/4879, https://github.com/tidyverse/glue/issues/211
    .data <- parent.frame(n = 3)$x
  }
  glue::glue_data(
    .x = .data,
    string,
    .sep = "",
    .envir = .envir,
    .open = "{",
    .close = "}",
    .na = "NA",
    .null = "NULL",
    .transformer = transformer,
    .trim = FALSE
  ) |> as.character()
}

#' Python-ish transformer
#'
#' @noRd
transformer <- function(text, envir) {
  parts <- strs_split(text, ":")[[1]]
  expr <- strs_removesuffix(parts[1], "=")
  res <- glue::identity_transformer(expr, envir)
  fmt <- paste0("%", parts[2])

  if (fmt != "%NA") res <- stringi::stri_sprintf(fmt, res)

  if (parts[1] != expr) {
    # if they aren't equal it's because it once ended with an equal sign
    glue::glue(
      "{expr} = {res}",
      .sep = "",
      .open = "{",
      .close = "}",
      .trim = FALSE,
      .na = "NA",
      .null = "NULL"
    )
  } else {
    res
  }
}
