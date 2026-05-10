
## Create tables and schemas for London Boroughs

#-------------------------------------------------------------------------------
# Designation table
#-------------------------------------------------------------------------------

d_designation <- data.frame(
  id = c(1,2,3,4,5, 6),
  type = c("municipal", "metropolitan", "urban", "county", "inner", "outer"),
  active = c(F, F, F, F, T, T),
  disestablished = c(1965, 1965, 1965, 1965, NA, NA)
)
save(d_designation, file = "db_tables/d_designation.RData")

#-------------------------------------------------------------------------------
# Municipal Boroughs
#-------------------------------------------------------------------------------

municipal_boroughs <- c(
  "Acton", "Barking", "Barnes", "Beckenham",
  "Beddington", "Bexley", "Brentford and Chiswick", "Bromley",
  "Chingford", "Dagenham", "Ealing","Edmonton", "Enfield",
  "Erith", "Finchley", "Harrow","Hendon", "Heston and Isleworth",
  "Hornsey", "Ilford","Kingston upon Thames","Leyton", "Malden and Coombe", "Mitcham",
  "Richmond", "Romford", "Southall", "Southgate", 
  "Surbiton", "Sutton and Cheam", "Tottenham", 
  "Twickenham", "Uxbridge","Walthamstow", "Wanstead and Woodford",
  "Wembley", "Willesden", "Wimbledon", "Wood Green", "West Ham", "East Ham"
)
n_municipal <- length(municipal_boroughs)

d_municipal <- data.frame(
  id = 1:n_municipal,
  borough_name = municipal_boroughs,
  designation_id = 1,
  designation_name = "municipal",
  year_established = c(1865, 1882, 1894, 1878, 1915, 1879, 1927, 1867, 1894, 
                       1926, 1863, 1937, 1955, 1876, 1878, NA, 1932, 1894,
                       1867, 1928, 1835, NA, 1866, 1934, 1890, 1851, 1891, 1881,
                       1855, 1934, 1850, 1868, 1849, 1894, 1934, 1937, 1874,
                       1905, 1888, 1886, 1904
                       ),
  year_disestablished = c(1965, 1965, 1965, 1965, 1965, 1965, 1965, 1965, 1965, 
                          1965, 1965, 1965, 1965, 1965, 1965, 1965, 1965, 1965,
                          1965, 1965, 1965, 1965, 1965, 1965, 1965, 1965, 1965,
                          1965, 1965, 1965, 1965, 1965, 1965, 1965, 1965, 1965,
                          1965, 1965, 1965, 1889, 1915
                          ),
  active = F
  
)
d_municipal$use <- as.integer(d_municipal$year_disestablished == 1965)

save(d_municipal, file = "db_tables/d_municipal.RData")

#-------------------------------------------------------------------------------
# Metropolitan Boroughs
#-------------------------------------------------------------------------------

metropolitan_boroughs <- c(
  "Holborn", "Finsbury", "Shoreditch", "Bethnal Green", "Stepney",
  "Bermondsey", "Southwark","Camberwell", "Deptford", "Lewisham",
  "Woolwich", "Greenwich", "Poplar", "Hackney","Stoke Newington", "Islington",
  "St Pancras", "Hampstead", "St Marylebone",
  "Paddington", "Kensington", "Westminster",
  "Hammersmith",
  "Fulham", "Wandsworth", "Lambeth", "Battersea", "Chelsea"
)
n_metropolitan <- length(metropolitan_boroughs)

d_metropolitan <- data.frame(
  id = (1:n_metropolitan) + 100,
  borough_name = metropolitan_boroughs,
  designation_id = 2,
  designation_name = "metropolitan",
  year_established = c(1900),
  year_disestablished = c(1965),
  active = F
)
d_metropolitan$use <- as.integer(d_metropolitan$year_disestablished == 1965)

save(d_metropolitan, file = "db_tables/d_metropolitan.RData")

#-------------------------------------------------------------------------------
# Urban Districts
#-------------------------------------------------------------------------------

urban_boroughs <- c(
  "Barnet", "Carshalton", "Chislehurst and Sidcup",
  "Chigwell", "Coulsdon and Purley", "Crayford", "East Barnet",
  "Feltham", "Friern Barnet", "Hayes and Harlington", "Hornchurch", "Merton",
  "Merton and Morden", "Orpington", "Penge", "Ruislip-Northwood", 
  "Yiewsley and West Drayton", "East Ham"
)
n_urban <- length(urban_boroughs)

d_urban <- data.frame(
  id = (1:n_urban) + 200,
  borough_name = urban_boroughs,
  designation_id = 3,
  designation_name = "urban",
  year_established = c(1894, 1894, 1934, NA, 1915, 1920, 1863, 1904, NA, 
                       1904, 1926, 1907, 1913, 1934, NA, 1904, 1929,1894),
  year_disestablished = c(1965, 1965, 1965, 1965, 1965, 1965, 1965, 1965, 
                          1965, 1965, 1965, 1913, 1965, 1965, 1965, 1965, 1965,
                          1904
                          ),
  active = F
)
d_urban$use <- as.integer(d_urban$year_disestablished == 1965)

save(d_urban, file = "db_tables/d_urban.RData")

#-------------------------------------------------------------------------------
# County Boroughs
#-------------------------------------------------------------------------------

county_boroughs  <- c(
  "Croydon", "East Ham", "West Ham"
)
n_county <- length(county_boroughs)

d_county <- data.frame(
  id = (1:n_county) + 300,
  borough_name = county_boroughs,
  designation_id = 4,
  designation_name = "county",
  year_established = c(1849, 1915, 1889),
  year_disestablished = c(1965, 1965, 1965),
  active = F
)
d_county$use <- as.integer(d_county$year_disestablished == 1965)

save(d_county, file = "db_tables/d_county.RData")


#-------------------------------------------------------------------------------
# London Boroughs
#-------------------------------------------------------------------------------

london_boroughs <- c("Camden", "Greenwich", "Hackney", "Hammersmith",
                     "Islington", "Kensington and Chelsea", "Lambeth",
                     "Lewisham", "Southwark", "Tower Hamlets", "Wandsworth",
                     "Westminster", "Barking", "Barnet", "Bexley", "Brent",
                     "Bromley", "Croydon", "Ealing", "Enfield", "Haringey",
                     "Harrow","Havering", "Hillingdon", "Hounslow",
                     "Kingston upon Thames", "Merton", "Newham", "Redbridge",
                     "Richmond upon Thames", "Sutton", "Waltham Forest"
                     )

d_lon_borough <- data.frame(
  id = (1:length(london_boroughs)) + 400,
  borough_name = london_boroughs,
  designation_id = rep(c(5,6), times = c(12, 20)),
  designation_name = rep(c("inner","outer"), times = c(12, 20)),
  year_established = 1965,
  year_disestablished = NA,
  active = T
)
save(d_lon_borough, file = "db_tables/d_lon_borough.RData")

#-------------------------------------------------------------------------------
# Bridging table between former authorities and London boroughs
#-------------------------------------------------------------------------------

d_metro_to_london <- data.frame(
  id = 1:91,
  borough_id = NA,
  borough_name = c("Camden", "Camden", "Camden", "Greenwich", "Greenwich", 
                   "Hackney", "Hackney", "Hackney", "Hammersmith", "Hammersmith",
                   "Islington", "Islington", "Kensington and Chelsea",
                   "Kensington and Chelsea", "Lambeth", "Lambeth", "Lewisham",
                   "Lewisham", "Southwark", "Southwark", "Southwark", 
                   "Tower Hamlets", "Tower Hamlets", "Tower Hamlets", 
                   "Wandsworth", "Wandsworth", "Westminster", "Westminster",
                   "Westminster", "Barking", "Barking", "Barnet", "Barnet",
                   "Barnet", "Barnet", "Barnet", "Bexley", "Bexley", "Bexley",
                   "Bexley", "Brent", "Brent", "Bromley", "Bromley", "Bromley",
                   "Bromley", "Bromley", "Croydon", "Croydon", "Ealing", "Ealing",
                   "Ealing", "Enfield", "Enfield", "Enfield", "Haringey", 
                   "Haringey", "Haringey", "Harrow", "Havering", "Havering",
                   "Hillingdon", "Hillingdon", "Hillingdon", "Hillingdon",
                   "Hounslow", "Hounslow", "Hounslow", "Kingston upon Thames",
                   "Kingston upon Thames", "Kingston upon Thames", "Merton",
                   "Merton", "Merton", "Newham", "Newham", "Newham", "Newham",
                   "Redbridge", "Redbridge", "Redbridge", "Redbridge", 
                   "Richmond upon Thames", "Richmond upon Thames",
                   "Richmond upon Thames", "Sutton", "Sutton", "Sutton",
                   "Waltham Forest", "Waltham Forest", "Waltham Forest"
                   ),
  borough_designation_id = NA,
  borough_designation_name = NA,
  old_borough_id = NA,
  old_borough_name = c("Hampstead", "St Pancras", "Holborn", "Greenwich", 
                        "Woolwich", "Hackney", "Shoreditch", "Stoke Newington",
                        "Hammersmith", "Fulham", "Islington", "Finsbury", 
                        "Kensington", "Chelsea", "Lambeth", "Wandsworth", 
                        "Lewisham", "Deptford", "Southwark", "Bermondsey",
                        "Camberwell", "Bethnal Green", "Poplar", "Stepney", 
                        "Battersea", "Wandsworth", "Paddington", "St Marylebone", 
                        "Westminster", "Barking", "Dagenham", "Barnet", 
                        "East Barnet", "Finchley", "Hendon", "Friern Barnet",
                        "Bexley", "Erith", "Crayford", "Chislehurst and Sidcup",
                        "Wembley", "Willesden", "Bromley", "Beckenham", "Orpington",
                        "Penge", "Chislehurst and Sidcup", "Croydon", 
                        "Coulsdon and Purley", "Acton", "Ealing", "Southall",
                        "Edmonton", "Enfield", "Southgate", "Hornsey", 
                        "Tottenham", "Wood Green", "Harrow", "Romford", 
                        "Hornchurch", "Hayes and Harlington", "Ruislip-Northwood",
                        "Uxbridge", "Yiewsley and West Drayton", 
                        "Brentford and Chiswick", "Feltham", "Heston and Isleworth",
                        "Kingston upon Thames", "Malden and Coombe", "Surbiton",
                        "Mitcham", "Merton and Morden", "Wimbledon", "West Ham",
                        "East Ham", "Barking", "Woolwich", "Ilford", 
                        "Wanstead and Woodford", "Dagenham", "Chigwell", "Barnes",
                        "Richmond", "Twickenham", "Beddington", "Carshalton",
                        "Sutton and Cheam", "Chingford", "Leyton", "Walthamstow"
                        ),
  old_borough_designation_id = NA,
  old_borough_designation_name = NA
)

tmp <- merge(
  d_lon_borough[, c("borough_name", "id", "designation_id", "designation_name")],
  d_metro_to_london[, c("borough_name", "id")], 
  by = "borough_name", all = T)

tmp_ordered <- tmp[order(tmp$id.x),]

d_metro_to_london$borough_id <- tmp_ordered$id.x
d_metro_to_london$borough_designation_id <- tmp_ordered$designation_id
d_metro_to_london$borough_designation_name <- tmp_ordered$designation_name

df <- rbind(
  d_municipal,
  d_metropolitan,
  d_urban,
  d_county
)
names(df)[1] <- "borough_id"
df <- subset(df, use == 1)

save(df, file = "db_tables/d_old_boroughs.RData")

tmp_old <- merge(
  d_metro_to_london[, c("old_borough_name", "id")],
  df[,c("borough_name", "borough_id", "designation_id", "designation_name")],
  by.x = "old_borough_name", by.y = "borough_name", all = T
)

tmp_old_ordered <- tmp_old[order(tmp_old$id),]

d_metro_to_london$old_borough_id <- tmp_old_ordered$borough_id
d_metro_to_london$old_borough_designation_id <- tmp_old_ordered$designation_id
d_metro_to_london$old_borough_designation_name <- tmp_old_ordered$designation_name

save(d_metro_to_london, file = "db_tables/d_metro_to_london.RData")



df <- data.frame(
  id = 1:sum(n_municipal, n_metropolitan, n_urban, n_county),
  borough = c(municipal_boroughs, metropolitan_boroughs, urban_boroughs, county_boroughs),
  type = rep(c("Municipal", "Metropolitan", "Urban", "County"), c(n_municipal,n_metropolitan,n_urban,n_county)),
  london_borough = NA,
  borough_designation = NA
)

df[df$borough == "East Ham",]$london_borough <- "Newham"
df[df$borough == "West Ham",]$london_borough <- "Newham"
df[df$borough == "Croydon",]$london_borough <- "Croydon"

df[df$borough == "Acton",]$london_borough <- "Ealing"
df[df$borough == "Barking",]$london_borough <- "Barking, Barking and Dagenham"
df[df$borough == "Barnes",]$london_borough <- "Richmond Upon Thames"
df[df$borough == "Beckenham",]$london_borough <- "Bromley"
df[df$borough == "Beddington and Wallington",]$london_borough <- "Sutton"
df[df$borough == "Bexley",]$london_borough <- "Bexley"
df[df$borough == "Brentford and Chiswick",]$london_borough <- "Hounslow"
df[df$borough == "Bromley",]$london_borough <- "Bromley"
df[df$borough == "Chingford",]$london_borough <- "Waltham Forest"
df[df$borough == "Dagenham",]$london_borough <- "Barking, Barking and Dagenham"
df[df$borough == "Ealing",]$london_borough <- "Ealing"
df[df$borough == "Edmonton",]$london_borough <- "Enfield"
df[df$borough == "Enfield",]$london_borough <- "Enfield"
df[df$borough == "Erith",]$london_borough <- "Bexley"
df[df$borough == "Finchley",]$london_borough <- "Barnet"
df[df$borough == "Harrow",]$london_borough <- "Harrow"
df[df$borough == "Hendon",]$london_borough <- "Barnet"
df[df$borough == "Heston and Isleworth",]$london_borough <- "Hounslow"
df[df$borough == "Hornsey",]$london_borough <- "Haringey"
df[df$borough == "Ilford",]$london_borough <- "Redbridge"
df[df$borough == "Kingston upon Thames",]$london_borough <- "Kingston upon Thames"
df[df$borough == "Leyton",]$london_borough <- "Waltham Forest"
df[df$borough == "Malden and Coombe",]$london_borough <- "Kingston upon Thames"
df[df$borough == "Mitcham",]$london_borough <- "Merton"
df[df$borough == "Richmond",]$london_borough <- "Richmond upon Thames"
df[df$borough == "Romford",]$london_borough <- "Havering"
df[df$borough == "Southall",]$london_borough <- "Ealing"
df[df$borough == "Southgate",]$london_borough <- "Enfield"
df[df$borough == "Surbiton",]$london_borough <- "Kingston upon Thames"
df[df$borough == "Sutton and Cheam",]$london_borough <- "Sutton"
df[df$borough == "Tottenham",]$london_borough <- "Haringey"
df[df$borough == "Twickenham",]$london_borough <- "Richmond upon Thames"
df[df$borough == "Uxbridge",]$london_borough <- "Hillingdon"
df[df$borough == "Walthamstow",]$london_borough <- "Waltham Forest"
df[df$borough == "Wanstead and Woodford",]$london_borough <- "Redbridge"
df[df$borough == "Wembley",]$london_borough <- "Brent"
df[df$borough == "Willesden",]$london_borough <- "Brent"
df[df$borough == "Wimbledon",]$london_borough <- "Merton"
df[df$borough == "Wood Green",]$london_borough <- "Haringey"


df[df$borough == "Battersea",]$london_borough <- "Wandsworth"
df[df$borough == "Bermondsey",]$london_borough <- "Southwark"
df[df$borough == "Bethnal Green",]$london_borough <- "Tower Hamlets"
df[df$borough == "Camberwell",]$london_borough <- "Southwark"
df[df$borough == "Chelsea",]$london_borough <- "Kensington and Chelsea"
df[df$borough == "Deptford",]$london_borough <- "Lewisham"
df[df$borough == "Finsbury",]$london_borough <- "Islington"
df[df$borough == "Fulham",]$london_borough <- "Hammersmith, Hammersmith & Fulham"
df[df$borough == "Greenwich",]$london_borough <- "Greenwich"
df[df$borough == "Hackney",]$london_borough <- "Hackney"
df[df$borough == "Hammersmith",]$london_borough <- "Hammersmith, Hammersmith & Fulham"
df[df$borough == "Hampstead",]$london_borough <- "Camden"
df[df$borough == "Holborn",]$london_borough <- "Camden"
df[df$borough == "Islington",]$london_borough <- "Islington"
df[df$borough == "Kensington",]$london_borough <- "Kensington and Chelsea"
df[df$borough == "Lambeth",]$london_borough <- "Lambeth"
df[df$borough == "Lewisham",]$london_borough <- "Lewisham"
df[df$borough == "Paddington",]$london_borough <- "Westminster"
df[df$borough == "Poplar",]$london_borough <- "Tower Hamlets"
df[df$borough == "Shoreditch",]$london_borough <- "Hackney"
df[df$borough == "Southwark",]$london_borough <- "Southwark"
df[df$borough == "St Marylebone",]$london_borough <- "Westminster"
df[df$borough == "St Pancras",]$london_borough <- "Camden"
df[df$borough == "Stepney",]$london_borough <- "Tower Hamlets"
df[df$borough == "Stoke Newington",]$london_borough <- "Hackney"
df[df$borough == "Wandsworth",]$london_borough <- "Wandsworth, Lambeth"
df[df$borough == "Westminster (city)",]$london_borough <- "Westminster"
df[df$borough == "Woolwich",]$london_borough <- "Greenwich, Newham"


df[df$borough == "Barnet",]$london_borough <- "Barnet"
df[df$borough == "Brentford",]$london_borough <- "Hounslow"
df[df$borough == "Carshalton",]$london_borough <- "Sutton"
df[df$borough == "Chislehurst and Sidcup",]$london_borough <- "Bexley, Bromley"
df[df$borough == "Coulsdon and Purley",]$london_borough <- "Croydon"
df[df$borough == "Crayford",]$london_borough <- "Bexley"
df[df$borough == "East Barnet",]$london_borough <- "Barnet"
df[df$borough == "Feltham",]$london_borough <- "Hounslow"
df[df$borough == "Friern Barnet",]$london_borough <- "Barnet"
df[df$borough == "Hayes and Harlington",]$london_borough <- "Hillingdon"
df[df$borough == "Hornchurch",]$london_borough <- "Havering"
df[df$borough == "Merton and Morden",]$london_borough <- "Merton"
df[df$borough == "Orpington",]$london_borough <- "Bromley"
df[df$borough == "Penge",]$london_borough <- "Bromley"
df[df$borough == "Ruislip-Northwood",]$london_borough <- "Hillingdon"
df[df$borough == "Yiewsley and West Drayton",]$london_borough <- "Hillingdon"
df[df$borough == "Chigwell",]$london_borough <- "Redbridge"


inner_borough <- c("Camden", "Greenwich", "Hackney", 
                   "Hammersmith, Hammersmith & Fulham", "Islington",
                   "Kensington and Chelsea", "Lambeth", "Lewisham",
                   "Southwark", "Tower Hamlets", "Wandsworth", "Westminster",
                   "Wandsworth, Lambeth"
                   )
df$borough_designation <- ifelse(df$london_borough %in% inner_borough, "Inner", "Outer")


old_boroughs <- unique(df$borough)
old_boroughs <- old_boroughs[order(old_boroughs)]

df_hits <- data.frame(
  borough = old_boroughs,
  v1_hit = NA,
  v2_hit = NA,
  total_hit = NA
)

# Banstead -> Reigate and Banstead, Surrey
# Esher -> Elmbridge, Surrey
# Epsom -> Epsom and Ewell, Surrey
# Waltham Cross -> Broxbourne, Hertfordshire
# City of London 
# Cheshunt -> Broxbourne, Hertfordshire
# Staines-upon-Thames -> Spelthorne, Surrey
# Sunbury-on-Thames -> Spelthorne, Surrey
# Elstree -> Hertsmere, Hertfordshire
# Potters Bar -> Hertsmere, Hertfordshire
# Bushey -> Hertsmere, Hertfordshire

df_hits[df_hits$borough == "Croydon",2:4] <- c(141, 4, 145)
df_hits[df_hits$borough == "Wandsworth",2:4] <- c(122, 6, 128)
df_hits[df_hits$borough == "Lewisham",2:4] <- c(114, 12, 126)
df_hits[df_hits$borough == "Greenwich",2:4] <- c(73, 22, 95)
df_hits[df_hits$borough == "Woolwich",2:4] <- c(77, 33, 110)
df_hits[df_hits$borough == "West Ham",2:4] <- c(58, 27, 85)
df_hits[df_hits$borough == "Orpington",2:4] <- c(63, 14, 77)
df_hits[df_hits$borough == "Beckenham",2:4] <- c(70, 5, 75)
df_hits[df_hits$borough == "Lambeth",2:4] <- c(71, 3, 74)
df_hits[df_hits$borough == "Ilford",2:4] <- c(34, 35, 69)
df_hits[df_hits$borough == "Chislehurst and Sidcup",2:4] <- c(45, 17, 62)
df_hits[df_hits$borough == "Barking",2:4] <- c(37, 21, 58)
df_hits[df_hits$borough == "Coulsdon and Purley",2:4] <- c(54, 1, 55)
df_hits[df_hits$borough == "East Ham",2:4] <- c(36, 14, 50)
df_hits[df_hits$borough == "Poplar",2:4] <- c(39, 9, 48)
df_hits[df_hits$borough == "Dagenham",2:4] <- c(28, 19, 47)
df_hits[df_hits$borough == "Hackney",2:4] <- c(35, 10, 45)
df_hits[df_hits$borough == "Mitcham",2:4] <- c(43, 0, 43)
df_hits[df_hits$borough == "Bromley",2:4] <- c(37, 6, 43)
df_hits[df_hits$borough == "Deptford",2:4] <- c(30, 9, 39)
df_hits[df_hits$borough == "Stepney",2:4] <- c(30, 8, 38)
df_hits[df_hits$borough == "Bermondsey",2:4] <- c(30, 7, 37)
df_hits[df_hits$borough == "Bexley",2:4] <- c(25, 12, 37)
df_hits[df_hits$borough == "Beddington and Wallington",2:4] <- c(36, 0, 36)
df_hits[df_hits$borough == "Battersea",2:4] <- c(34, 2, 36)
df_hits[df_hits$borough == "Leyton",2:4] <- c(24, 12, 36)
df_hits[df_hits$borough == "Merton and Morden",2:4] <- c(35, 0, 35)
df_hits[df_hits$borough == "Walthamstow",2:4] <- c(17, 18, 35)
df_hits[df_hits$borough == "Sutton and Cheam",2:4] <- c(34, 0, 34)
df_hits[df_hits$borough == "Wimbledon",2:4] <- c(33, 0, 33)
df_hits[df_hits$borough == "Chigwell",2:4] <- c(20, 13, 33)
df_hits[df_hits$borough == "Westminster (city)",2:4] <- c(29, 2, 31)
df_hits[df_hits$borough == "Enfield",2:4] <- c(20, 9, 29)
df_hits[df_hits$borough == "Erith",2:4] <- c(12, 17, 29)
df_hits[df_hits$borough == "Twickenham",2:4] <- c(27, 1, 28)
df_hits[df_hits$borough == "Carshalton",2:4] <- c(27, 0, 27)
df_hits[df_hits$borough == "Islington",2:4] <- c(15, 8, 23)
df_hits[df_hits$borough == "Malden and Coombe",2:4] <- c(21, 0, 21)
df_hits[df_hits$borough == "Kensington",2:4] <- c(20, 1, 21)
df_hits[df_hits$borough == "St Pancras",2:4] <- c(19, 2, 21)
df_hits[df_hits$borough == "Surbiton",2:4] <- c(20, 0, 20)
df_hits[df_hits$borough == "Hornsey",2:4] <- c(15, 4, 19)
df_hits[df_hits$borough == "Willesden",2:4] <- c(15, 4, 19)
df_hits[df_hits$borough == "Penge",2:4] <- c(17, 0, 17)
df_hits[df_hits$borough == "Southwark",2:4] <- c(14, 3, 17)
df_hits[df_hits$borough == "Crayford",2:4] <- c(11, 5, 16)
df_hits[df_hits$borough == "Edmonton",2:4] <- c(7, 9, 16)
df_hits[df_hits$borough == "Fulham",2:4] <- c(15, 0, 15)
df_hits[df_hits$borough == "Wembley",2:4] <- c(14, 1, 15)
df_hits[df_hits$borough == "Hammersmith",2:4] <- c(14, 1, 15)
df_hits[df_hits$borough == "Hendon",2:4] <- c(13, 2, 15)
df_hits[df_hits$borough == "Harrow",2:4] <- c(11, 4, 15)
df_hits[df_hits$borough == "St Marylebone",2:4] <- c(12, 1, 13)
df_hits[df_hits$borough == "Ealing",2:4] <- c(11, 1, 12)
df_hits[df_hits$borough == "Chingford",2:4] <- c(0, 11, 11)
df_hits[df_hits$borough == "Bethnal Green",2:4] <- c(9, 2, 11)
df_hits[df_hits$borough == "Hampstead",2:4] <- c(8, 3, 11)
df_hits[df_hits$borough == "Richmond",2:4] <- c(8, 2, 10)
df_hits[df_hits$borough == "Southgate",2:4] <- c(6, 4, 10)
df_hits[df_hits$borough == "Kingston upon Thames",2:4] <- c(8, 1, 9)
df_hits[df_hits$borough == "Shoreditch",2:4] <- c(7, 2, 9)
df_hits[df_hits$borough == "Stoke Newington",2:4] <- c(7, 2, 9)
df_hits[df_hits$borough == "Hayes and Harlington",2:4] <- c(6, 2, 8)
df_hits[df_hits$borough == "Finsbury",2:4] <- c(5, 3, 8)
df_hits[df_hits$borough == "Acton",2:4] <- c(7, 0, 7)
df_hits[df_hits$borough == "Southall",2:4] <- c(7, 0, 7)
df_hits[df_hits$borough == "East Barnet",2:4] <- c(6, 1, 7)
df_hits[df_hits$borough == "Finchley",2:4] <- c(6, 1, 7)
df_hits[df_hits$borough == "Wood Green",2:4] <- c(5, 2, 7)
df_hits[df_hits$borough == "Tottenham",2:4] <- c(4, 3, 7)
df_hits[df_hits$borough == "Ruislip-Northwood",2:4] <- c(4, 2, 6)
df_hits[df_hits$borough == "Uxbridge",2:4] <- c(5, 0, 5)
df_hits[df_hits$borough == "Paddington",2:4] <- c(5, 0, 5)
df_hits[df_hits$borough == "Feltham",2:4] <- c(5, 0, 5)
df_hits[df_hits$borough == "Barnet",2:4] <- c(4, 1, 5)
df_hits[df_hits$borough == "Holborn",2:4] <- c(4, 1, 5)
df_hits[df_hits$borough == "Yiewsley and West Drayton",2:4] <- c(3, 1, 4)
df_hits[df_hits$borough == "Chelsea",2:4] <- c(3, 1, 4)
df_hits[df_hits$borough == "Friern Barnet",2:4] <- c(1, 1, 2)
df_hits[df_hits$borough == "Camberwell",2:4] <- c(80, 9, 89)
df_hits[df_hits$borough == "Wanstead and Woodford",2:4] <- c(23, 14, 37)
df_hits[df_hits$borough == "Heston and Isleworth",2:4] <- c(15, 2, 17)









