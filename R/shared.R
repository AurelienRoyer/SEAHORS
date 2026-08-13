.sessions <- new.env(parent = emptyenv())

get_shared_session <- function(id) {
  
  if (!exists(id, envir = .sessions, inherits = FALSE)) {
    
    .sessions[[id]] <- new.env(
      parent = emptyenv()
    )
    
  }
  
  .sessions[[id]]
}