library(httr)
library(jsonlite)


#' Authorize
#'
#' Sets and stores the environment variables for the data transfer api
#' @param app.id the app id
#' @param app.key the app key
#'
#' @return Nothing
#' @export
#'
#' @examples
#' \dontrun{ Authorize('yourappid', 'yourappkey') }

Authorize <- function(app.id, app.key) {
  Sys.setenv("SKYWISE_DATAXfer_APP_ID" = app.id)
  Sys.setenv("SKYWISE_DATAXfer_APP_KEY" = app.key)
}

#' GetProducts
#'
#' Makes a call to the data transfer api to retrieve the products available for download
#' @return an R object resulting from the fromJSON call applied to the output from the api
#' @export
#'
#' @examples
#' \dontrun{products <- GetProducts()}

GetProducts <- function() {
  .call.api('products')
}


#' DataTransfer
#'
#' Given a product, downloads the datasets available for that product.
#' @param product the product to download
#' @param startDate the start date of the product to download
#' @param endDate the end date of the product to download
#' @param directory the directory you wish to download the datasets to. will only download new files
#'
#' @return a list of the file names downloaded
#' @export
#'
#' @examples
#' \dontrun{files <- DataTransfer('skywise-conus-surface-analysis', directory = 'data')}

DataTransfer <-
  function (product,
            startDate = NULL,
            endDate = NULL,
            directory = NULL) {
    if (missing(startDate)) {
      startDate <- Sys.Date()
    }

    if (missing(endDate)) {
      endDate <- Sys.Date()
    }

    start <- as.Date(startDate, format = "%Y-%m-%d")
    end   <- as.Date(endDate, format = "%Y-%m-%d")
    dates <- format(seq(start, end, by = 1), "%Y-%m-%d")

    url <- paste('products', product, 'datasets', sep = '/')

    content <- mapply(.call.api, url, dates, SIMPLIFY = TRUE)
    urls <- sapply(content, '[', 'downloadUrl')
    names <- sapply(content, '[', 'name')
    names <- paste(directory, names, sep = '/')
    results <- mapply(.download.dataset, urls, names, mode = "wb")

    names
  }

.download.dataset <- function(url, name, mode) {
  if (!file.exists(name)) {
    utils::download.file(url, name, mode = mode)
  }
}

.call.api <- function(endpoint, date = NULL) {
  app.id = Sys.getenv("SKYWISE_DATAXfer_APP_ID")
  app.key = Sys.getenv("SKYWISE_DATAXfer_APP_KEY")

  url = paste ("https://data-transfer.api.wdtinc.com",
               endpoint,
               sep = "/")

  query = list()

  if (!missing(date)) {
    query$date = date
  }

  response <- httr::GET(
    url = url,
    httr::authenticate(app.id, app.key, type = "basic"),
    httr::add_headers(Accept = "application/vnd.wdt+json; version=1"),
    query = query
  )

  httr::stop_for_status(response)

  content = jsonlite::fromJSON(httr::content(response, "text", encoding = 'UTF-8'),
                     simplifyVector = FALSE)
  if (length(content) == 0) {
    stop("no files available for that product / date")
  }
  content
}
