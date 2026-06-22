library(duckdb)
library(DBI)

csv_path <- "data/incidents.csv"
db_path  <- "data/incidents.duckdb"

# ── incidents ────────────────────────────────────────────────────────────────
incidents <- read.csv(csv_path, stringsAsFactors = FALSE, na.strings = "")
incidents$Date   <- as.Date(incidents$Date, format = "%d/%m/%Y")
incidents$Time   <- ifelse(is.na(incidents$Time) | incidents$Time == "",
                           NA_character_, incidents$Time)
incidents$Deaths <- as.integer(incidents$Deaths)

con <- dbConnect(duckdb(), dbdir = db_path, read_only = FALSE)

dbExecute(con, "DROP TABLE IF EXISTS incidents")
dbExecute(con, "
  CREATE TABLE incidents (
    Type        VARCHAR,
    PostCode    VARCHAR,
    Borough     VARCHAR,
    Area        VARCHAR,
    Positioning VARCHAR,
    Date        DATE,
    Time        VARCHAR,
    Description VARCHAR,
    Deaths      INTEGER
  )
")
dbAppendTable(con, "incidents", incidents)
cat(sprintf("incidents: %d rows\n", dbGetQuery(con, "SELECT COUNT(*) AS n FROM incidents")$n))

# ── lookup tables ─────────────────────────────────────────────────────────────
load_rdata <- function(path) {
  e <- new.env()
  load(path, envir = e)
  get(ls(e)[1], envir = e)
}

lookup_tables <- list(
  designation   = load_rdata("db_tables/d_designation.RData"),
  borough_municipal    = load_rdata("db_tables/d_municipal.RData"),
  borough_metropolitan = load_rdata("db_tables/d_metropolitan.RData"),
  borough_urban        = load_rdata("db_tables/d_urban.RData"),
  borough_county       = load_rdata("db_tables/d_county.RData"),
  borough_london       = load_rdata("db_tables/d_lon_borough.RData"),
  borough_old          = load_rdata("db_tables/d_old_boroughs.RData"),
  metro_to_london      = load_rdata("db_tables/d_metro_to_london.RData")
)

for (tbl_name in names(lookup_tables)) {
  df <- lookup_tables[[tbl_name]]
  # Normalise column names to lowercase
  names(df) <- tolower(names(df))
  dbExecute(con, sprintf("DROP TABLE IF EXISTS %s", tbl_name))
  dbWriteTable(con, tbl_name, df)
  cat(sprintf("%-25s %d rows\n", paste0(tbl_name, ":"), nrow(df)))
}

# ── summary ───────────────────────────────────────────────────────────────────
cat("\nTables in database:\n")
print(dbListTables(con))

dbDisconnect(con, shutdown = TRUE)
