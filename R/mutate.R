#' @title Add new variables
#' @description Mimics dplyr::mutate using base R and rlang
#' @param .data data.frame
#' @param ... Name-value pairs of expressions
#' @return data.frame
#' @examples
#' airquality%>%
#' mutate(
#'     lOzone = log(Ozone),
#'     Month  = factor(month.abb[Month]),
#'     cTemp  = round((Temp - 32) * 5/9, 1),
#'     S.cT   = Solar.R / cTemp
#' )%>%
#' head()
#' @seealso
#'  \code{\link[rlang]{quotation}}
#' @rdname mutate
#' @export
#' @author Jonathan Sidi
mutate <- function(.data,...){
  UseMethod("mutate")
}

#' @rdname mutate
#' @export
#' @importFrom rlang quos quo_expr
mutate.default <- function(.data,...){

  FNS <- lapply(rlang::quos(...),rlang::quo_expr)

  EXPRS <- lapply(names(FNS),function(x){
    sprintf('%s <- %s',x,deparse(FNS[[x]]))
  })

  within(.data,eval(parse(text = paste0(unlist(EXPRS),collapse = '\n'))))

}

#' @rdname mutate
#' @export
mutate.split_df <- function(.data,...){

  bindr(split(.data), mutate, .data, ...)

}
