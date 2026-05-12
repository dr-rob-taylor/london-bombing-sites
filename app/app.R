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
      table(
        tr( th("ID"), td(ID) ),
        tr( th("Reference"), td(REF) ),
        tr( th("Area"), td(AREA) ),
        tr( th("Borough"), td(BOROUGH) ),
        tr( th("Post Code"), td(POSTCODE) ),
        tr( th("Date"), td(DATE) ),
        tr( th("Time"), td(TIME) ),
        tr( th("Fatalities"), td(FATALITIES) ),
        tr( th("Position"), td(POS) ),
        tr( th("Notes"), td(NOTES) )
      )
    )
  )
}

ui <- withTags(
  tagList(
    
    tags$head(
      tags$style('
        
        table {
          border-collapse: collapse;
          width: 100%;
          font-size: .9em;
        }
        
        td, th {
          text-align: left;
          padding: .35em;
        }
        
        th {
          vertical-align: top;
        }
        
    ')
    ),
    
    page_navbar(
      
      #theme = bs_theme(bootswatch = "cosmo"),
      navbar_options = navbar_options(
        theme = "dark"
      ),
      
      title = "Flying Bomb Attacks on London",
      footer = footer(
        p("Rob Taylor")
      ),
      
      # ------------------------------------------------------------------------
      # ABOUT
      nav_panel(
        title = "About",
        uiOutput("about")
      ),
      
      # ------------------------------------------------------------------------
      # MAP
      nav_panel(
        title = "Map",
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
        )
      )
    ),
    
    # --------------------------------------------------------------------------
    tags$script(HTML("
      Shiny.addCustomMessageHandler('openOffcanvas', function(Name) {
        var el = document.getElementById(Name);
        var bsOffcanvas = new bootstrap.Offcanvas(el);
        bsOffcanvas.show();
      });
    "))
  )
)

server <- function(session, input, output) {
  # Render the initial map
  
  output$about <- renderUI({
    includeMarkdown("about.Rmd")
  })
  
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
    
    req(click$id)
    
    selected <- get_info(id = click$id)
    output$panel_content <- renderUI( selected )
    
    # Open offcanvas via JS
    session$sendCustomMessage("openOffcanvas", "info_panel")
  })
}

shinyApp(ui, server)