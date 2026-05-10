
get_counts <- function( data, coords, step_size = 500 ){
  
  get_grid_count <- function(xmin, xmax, ymin, ymax){
    
    pts <- list(rbind(c(xmin,ymin), c(xmin, ymax), c(xmax, ymax), c(xmax, ymin), c(xmin, ymin)))
    box <- sf::st_sfc(sf::st_polygon(pts), crs = 27700)
    in_box <- data |> sf::st_intersects(box) |> lengths()
    
    return(sum(in_box > 0))
  }
  
  xmin <- as.numeric(coords["x_min"])
  xmax <- as.numeric(coords["x_max"])
  ymin <- as.numeric(coords["y_min"])
  ymax <- as.numeric(coords["y_max"])
  
  nrow_x <- (xmax - xmin) / step_size
  ncol_y <- (ymax - ymin) / step_size
  
  total_squares <- (nrow_x * ncol_y)
  count_matrix <- matrix(nrow = nrow_x, ncol = ncol_y)
  
  for( i in 1:nrow_x ) {
    for( j in 1:ncol_y ){
      count_matrix[i,j] <- get_grid_count( xmin = xmin + step_size * (i-1), 
                                           xmax = xmin + step_size * i,
                                           ymin = ymin + step_size * (j-1),
                                           ymax = ymin + step_size * j
      )
    }
  }
  
  lambda_est <- nrow(data) / total_squares
  observed   <- as.numeric(table(count_matrix))
  expected   <- sapply(seq(0, 4), function(x) dpois(x, lambda_est)*total_squares)
  expected[6] <- total_squares - sum(expected)
  
  output <- list(
    total_squares = total_squares,
    count_matrix = count_matrix,
    lambda_est = lambda_est,
    observed = observed,
    expected = expected
  )
  
  return(output)
  
}
