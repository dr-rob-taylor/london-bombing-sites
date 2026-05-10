library(shiny)
library(leaflet)
library(bslib)

load("dat/south_london_incidents.RData")

sl_data <<- south_london_incidents[!is.na(south_london_incidents$fatalities),]


get_info <- function(id){
  selected <- sl_data[sl_data$Name == id, ]
  ID <- selected$Name
  REF <- selected$ref
  POS <- selected$position
  AREA <- selected$area
  BOROUGH <- selected$borough
  POSTCODE <- selected$postcode
  DATE <- selected$date
  TIME <- selected$time
  NOTES <- selected$notes
  FATALITIES <- selected$fatalities
  
  withTags(
    tagList(
      div( class = "info-container",
        div( class = "d-flex flex-row ",
          div(
            label(span( class = "field-name", "ID")),
            p(ID)
          ),
          div( class = "ms-5",
            label(span( class = "field-name", "Reference")),
            p(REF)
          )
        ),
        div( class = "d-flex flex-row",
          div(
            label(span( class = "field-name", "Area")),
            p(AREA)
          ),
          div( class = "ms-5",
            label(span( class = "field-name", "Borough")),
            p(BOROUGH)
          ),
          div( class = "ms-5",
            label(span( class = "field-name", "Post Code")),
            p(POSTCODE)
          )
        ),
        div( class = "d-flex flex-row",
          div(
            label(span( class = "field-name", "Date")),
            p(DATE)
          ),
          div( class = "ms-4",
            label(span( class = "field-name", "Time")),
            p(TIME)
          )
        ),
        div(
          label( span( class = "field-name", "Fatalities")),
          p(FATALITIES)
        ),
        div(
          label( span( class = "field-name", "Position")),
          p(POS)
        ),
        div(
          label( span( class = "field-name", "Notes")),
          p(NOTES)
        )
      )
    )
  )
  
}

ui <- page_fluid(
  
  tags$head(
    tags$style('
        .field-name {
          font-weight: 600;
        }  
        
        .info-container {
          font-size: .9em;
        }
    ')
  ),
  
  theme = bs_theme(version = 5),
  
  title = "Bombs",
  
  titlePanel("Title"),
  
  leafletOutput("map", height = "600px"),
  
  tags$div(
    class = "offcanvas offcanvas-end",
    tabindex = "-1",
    id = "info_panel",
    tags$div(class = "offcanvas-header",
             tags$h4(class="offcanvas-title", "Details"),
             tags$button(type="button", class="btn-close", `data-bs-dismiss`="offcanvas")
    ),
    tags$div(class = "offcanvas-body",
             uiOutput("panel_content")
    )
  ),
  
  tags$script(HTML("
  Shiny.addCustomMessageHandler('openOffcanvas', function(Name) {
    var el = document.getElementById(Name);
    var bsOffcanvas = new bootstrap.Offcanvas(el);
    bsOffcanvas.show();
  });
"))
)

# ui <- fluidPage(
#   titlePanel("Capture Map Clicks for Lat/Lng"),
#   sidebarLayout(
#     sidebarPanel(
#       h4("Latest Click Coordinates:"),
#       textOutput("coords")  # Text output to display lat/lng
#     ),
#     mainPanel(
#       leafletOutput("map", height = "600px"),
#     )
#   ),
#   
#   tags$div(
#     class = "offcanvas offcanvas-end",
#     tabindex = "-1",
#     id = "info_panel",
#     tags$div(class = "offcanvas-header",
#              tags$h5(class = "offcanvas-title" ,"Details"),
#              tags$button(type="button", class="btn-close", `data-bs-dismiss`="offcanvas")
#     ),
#     tags$div(class = "offcanvas-body",
#              uiOutput("panel_content")
#     )
#   ),
#   
# 
# )

server <- function(session, input, output) {
  # Render the initial map
  
  output$map <- renderLeaflet({
    
    leaflet() %>%
      addProviderTiles(
        providers$Stadia.AlidadeSmooth
        #options = providerTileOptions(opacity = 0.5)
      ) |> 
      #addTiles() %>%  # Add base tiles (OpenStreetMap by default)
      setView(lng = -0.12754, lat = 51.50739, zoom = 12)  |>
      addCircleMarkers(
        data = sl_data,
        label = ~ref,
        #lng = ~lng, lat = ~lat,
        popup = ~Name,
        layerId = ~Name
      )
      
  })
  
  observeEvent(input$map_marker_click, {
    click <- input$map_marker_click
    #print(click$id)
    
    req(click$id)
    
    #selected <- sl_data[sl_data$Name == click$id, ]
    selected <- get_info(id = click$id)
    
    output$panel_content <- renderUI({
      selected
      # tagList(
      #   h5(selected$Name),
      #   hr(),
      #   p(selected$Description),
      #   p(click$lng, click$lat)
      # )
    })
    
    # Open offcanvas via JS
    session$sendCustomMessage("openOffcanvas", "info_panel")
  })
  
  # # Print click coordinates to the console
  # observeEvent(input$map_click, {
  #   click <- input$map_click
  #   print(paste("Latitude:", click$lat, "Longitude:", click$lng))
  # })
  # 
  # # Display latest click coordinates as text
  # output$coords <- renderText({
  #   req(input$map_click)  # Wait for a click before rendering
  #   click <- input$map_click
  #   paste0("Latitude: ", round(click$lat, 4), "\nLongitude: ", round(click$lng, 4))
  # })
  
  # # Add a popup at the click location
  # observeEvent(input$map_click, {
  #   click <- input$map_click
  #   leafletProxy("map") %>%  # Update the existing "map"
  #     clearPopups() %>%  # Clear previous popups (optional)
  #     addPopups(
  #       lng = click$lng,
  #       lat = click$lat,
  #       popup = paste0("Lat: ", round(click$lat, 4), "<br>Lng: ", round(click$lng, 4))
  #     )
  # })
}

shinyApp(ui, server)