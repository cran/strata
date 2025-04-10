#' Send a standardized log message to stdout or stderr
#'
#' `log_message()` does _not_ stop the execution of the script, regardless of
#' the level of the message, and whether or not it prints to STDOUT or STDERR.
#'
#' @param message A string containing a message to log.
#' @param level The level of the message (e.g. INFO, WARNING, ERROR), defaults
#'   to "INFO" but will accept any string.
#' @param out_or_err Send log output to stdout or stderr, choices are `"OUT"`
#'   or `"ERR"` and the defaults is `"OUT"`.
#'
#' @family log
#'
#' @return A message printed to stdout or stderr and an invisible character
#'   string copy of the entire log message.
#' @export
#'
#' @examples
#' log_message("This is an info message", "INFO", "OUT")
#' log_message("This is an error message", "ERROR", "ERR")
#' log_message("This is a warning message", "WARNING", "OUT")
log_message <- function(message, level = "INFO", out_or_err = "OUT") {
  # Validate output channel
  checkmate::assert_choice(out_or_err, c("OUT", "ERR"))

  # Format timestamp consistently
  timestamp <- format_timestamp(Sys.time())

  # Construct log message
  log_message <- sprintf("[%s] %s: %s", timestamp, level, message)

  # Output to appropriate channel
  if (out_or_err == "OUT") {
    cat(log_message, "\n")
  } else {
    message(log_message)
  }

  invisible(log_message)
}

#' Format timestamp for log messages
#'
#' @param time A POSIXct time object
#' @return A formatted timestamp string
#' @keywords internal
format_timestamp <- function(time) {
  time |>
    as.character() |>
    stringr::str_trunc(width = 24, ellipsis = "") |>
    stringr::str_pad(width = 24, side = "right", pad = "0")
}

#' Wrapper around log_message for ERROR messages in the log
#'
#' `log_error()` does _not_ stop the execution of the script, but it does print
#' the message to stderr.
#'
#' @inheritParams log_message
#' @family log
#'
#' @return A message printed to stderr and an invisible character string copy of
#'   the entire log error message.
#' @export
#'
#' @examples
#' log_error("This is an error message")
log_error <- function(message) {
  log_message(message, level = "ERROR", out_or_err = "ERR") |>
    invisible()
}

#' Print time difference in a standard message for logging purposes
#'
#' @param begin A data-time object, signifying the beginning or a process
#' @param end A data-time object, signifying the end of a process
#'
#' @family log
#'
#' @return A numeric value of the time difference in seconds
#' @export
#'
#' @examples
#' begin <- Sys.time()
#' # do something
#' end <- Sys.time() + 999
#' log_total_time(begin, end)
log_total_time <- function(begin, end) {
  checkmate::assert_posixct(c(begin, end))

  difftime(end, begin, units = "secs") |>
    as.numeric() |>
    round(digits = 4)
}
