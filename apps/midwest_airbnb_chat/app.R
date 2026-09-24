# apps/midwest_airbnb_chat/app.R
library(querychat)
library(bslib)
library(shiny)

con = DBI::dbConnect(RSQLite::SQLite(), "data/midwest_airbnb.db")

client = ellmer::chat_openai(
  model  = "gpt-5.6-luna",
  params = ellmer::params(reasoning_effort = "none")
)

qc = querychat::querychat(
  con, "listings",
  client             = client,
  tools              = c("filter", "query", "visualize"),
  greeting           = "Ask me about 14,887 Airbnb listings in Chicago, Columbus, and the Twin Cities.",
  data_description   = "data/data_desc.md",
  extra_instructions = "data/extra_instructions.md"
)
theme = bs_theme(
  version = 5,
  bootswatch = "flatly"
)
ui = page_navbar(
  title = "Midwest Airbnb Explorer",
  theme = theme,
  
  nav_panel(
    "Home",
    layout_sidebar(
      sidebar = qc$sidebar(),
      card(
        card_header("Airbnb Listings"),
        DT::DTOutput("results_table")
      )
    )
  ),
  nav_panel(
    "About",
    h2("About the Data"),
    
    p("This app explores 14,887 Airbnb listings from Chicago, Columbus, and the Twin Cities."),
    
    h4("Data Source"),
    p("The data come from Inside Airbnb's detailed listings files."),
    
    h4("Snapshot Dates"),
    tags$ul(
      tags$li("Chicago: July 20, 2026"),
      tags$li("Columbus: July 23, 2026"),
      tags$li("Twin Cities: July 21, 2026")
    ),
    
    h4("Using the App"),
    p("Use the Home tab to ask questions about prices, neighborhoods, room types, reviews, availability, and other listing information.")
  ))

server = function(input, output, session) {
  
  qc_vals = qc$server()
  
  output$results_table = DT::renderDT({
    qc_vals$df()
  })
  
}
shinyApp(ui, server)
