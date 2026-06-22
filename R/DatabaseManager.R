library(R6)
library(DBI)
library(duckdb)

DatabaseManager <- R6Class("DatabaseManager",

  private = list(
    con     = NULL,
    db_path = NULL,

    finalize = function() {
      self$disconnect()
    }
  ),

  public = list(

    initialize = function(db_path) {
      private$db_path <- db_path
      self$connect()
    },

    # ── Connection ─────────────────────────────────────────────────────────────

    connect = function() {
      if (self$is_connected()) return(invisible(self))
      private$con <- dbConnect(duckdb(), dbdir = private$db_path, read_only = TRUE)
      invisible(self)
    },

    disconnect = function() {
      if (!self$is_connected()) return(invisible(self))
      dbDisconnect(private$con, shutdown = TRUE)
      private$con <- NULL
      invisible(self)
    },

    is_connected = function() {
      !is.null(private$con) && dbIsValid(private$con)
    },

    # ── Introspection ──────────────────────────────────────────────────────────

    tables = function() {
      self$connect()
      dbListTables(private$con)
    },

    fields = function(table) {
      self$connect()
      dbListFields(private$con, table)
    },

    metadata = function(table = NULL) {
      self$connect()
      if (!is.null(table)) {
        cols <- dbGetQuery(private$con, sprintf(
          "SELECT column_name, data_type, is_nullable
           FROM information_schema.columns
           WHERE table_name = '%s'
           ORDER BY ordinal_position", table
        ))
        list(table = table, columns = cols, row_count = self$count(table))
      } else {
        tbls <- self$tables()
        lapply(setNames(tbls, tbls), function(t) self$metadata(t))
      }
    },

    count = function(table) {
      self$connect()
      dbGetQuery(private$con, sprintf("SELECT COUNT(*) AS n FROM %s", table))$n
    },

    # ── Querying ───────────────────────────────────────────────────────────────

    query = function(sql) {
      self$connect()
      dbGetQuery(private$con, sql)
    },

    get_table = function(table) {
      self$connect()
      dbReadTable(private$con, table)
    },

    # ── Incidents helpers ──────────────────────────────────────────────────────

    get_incidents = function(borough = NULL, postcode = NULL,
                             type = NULL, date_from = NULL, date_to = NULL) {
      self$connect()

      clauses <- character(0)
      if (!is.null(borough))   clauses <- c(clauses, sprintf("Borough = '%s'",  borough))
      if (!is.null(postcode))  clauses <- c(clauses, sprintf("PostCode = '%s'", postcode))
      if (!is.null(type))      clauses <- c(clauses, sprintf("Type = '%s'",     type))
      if (!is.null(date_from)) clauses <- c(clauses, sprintf("Date >= '%s'",    date_from))
      if (!is.null(date_to))   clauses <- c(clauses, sprintf("Date <= '%s'",    date_to))

      where <- if (length(clauses)) paste("WHERE", paste(clauses, collapse = " AND ")) else ""
      dbGetQuery(private$con,
        sprintf("SELECT * FROM incidents %s ORDER BY Date, Time", where)
      )
    },

    # ── Borough lookup helpers ─────────────────────────────────────────────────

    modern_borough = function(old_borough_name) {
      self$connect()
      dbGetQuery(private$con, sprintf(
        "SELECT DISTINCT borough_name
         FROM metro_to_london
         WHERE old_borough_name = '%s'", old_borough_name
      ))$borough_name
    },

    old_boroughs = function(modern_borough_name) {
      self$connect()
      dbGetQuery(private$con, sprintf(
        "SELECT DISTINCT old_borough_name, old_borough_designation_name
         FROM metro_to_london
         WHERE borough_name = '%s'
         ORDER BY old_borough_name", modern_borough_name
      ))
    }
  )
)
