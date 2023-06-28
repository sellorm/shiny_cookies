library(shiny)
library(shinydashboard)

ui <- fluidPage(
  tags$head(tags$script(src = "cookies.js")),
  fluidRow(
    box(
      title = "Current cookies in your browser for this site:",
      p(paste(
        "This is a complete list of all cookies set in your browser",
        "for the current site (probably http://localhost)."
      )),
      verbatimTextOutput("full_cookie_list"),
      actionButton("refresh", "Refresh")
    ),
    # javascript code to send data to shiny server
    tags$script('
        // react to button press
        document.getElementById("refresh").onclick = function() {
          // get all the cookies
          var my_cookies = document.cookie;
          // pass back to shiny
          Shiny.onInputChange("all_cookies", my_cookies);
        };
        ')
  ),
  fluidRow(
    box(
      title = "set a custom cookie called 'my_cookie'",
      p(paste(
        "Here we set the value for a  custom cookie called 'my_cookie',",
        "Setting it more than once will update the value of the cookie."
      )),
      verbatimTextOutput(outputId = "custom_cookie"),
      textInput("my_cookie_value", "Cookie contents:"),
      actionButton("set_cookie", "Set cookie", style = "simple", size = "sm", color = "warning"),
    ),
    tags$script('
        // react to button press
        document.getElementById("set_cookie").onclick = function() {
          // get the user input from the text box
          var input_value = document.getElementById("my_cookie_value").value ;
          // set the required cookie (name, value, expiry in days)
          setCookie("my_cookie", input_value, 7);
          // get the contents of the new cookie
          var my_cookie = getCookie("my_cookie");
          // pass back to shiny
          Shiny.onInputChange("my_cookie", my_cookie);
          // erase the contents of the input box
          document.getElementById("my_cookie_value").value = "";
          // refresh the full cookie list at the top of the page
          freshCookies()
        };
        ')
  ),
  fluidRow(
    box(
      title = "Is my_cookie set?",
      p("Checks if 'my_cookie' is set and returns what it's set to."),
      verbatimTextOutput(outputId = "cookie_set"),
      actionButton("check_cookie", "Check for cookie", style = "simple", size = "sm", color = "warning"),
    ),
    tags$script('
        // react to button press
        document.getElementById("check_cookie").onclick = function() {
          // get cookie value
          var my_cookie = getCookie("my_cookie");
          // pass back to shiny
          Shiny.onInputChange("checked_cookie", my_cookie);
        };
        ')
  ),
  fluidRow(
    box(
      title = "Set arbitrary cookies",
      p(paste(
        "This allows us to set arbitrary cookies.",
        "Set your own cookie name and value",
        "You should see your new cookie appear in the list at the top."
      )),
      textInput("arb_cookie_name", "Name"),
      textInput("arb_cookie_value", "Value"),
      actionButton("arb_cookie_set", "Set cookie", style = "simple", size = "sm", color = "warning"),
    ),
    tags$script('
        // react to button press
        document.getElementById("arb_cookie_set").onclick = function() {
          // get the contents of the cookie name input box
          var cookie_name = document.getElementById("arb_cookie_name").value ;
          // get the contents of the cookie value input box
          var cookie_value = document.getElementById("arb_cookie_value").value ;
          // set the cookie (name, value, expiry in days)
          setCookie(cookie_name, cookie_value, 7);
          // read the cookie value back in
          var my_cookie = getCookie(cookie_name);
          // pass back to shiny
          Shiny.onInputChange("checked_arb_cookie", my_cookie);
          // Refresh the list of cookies at the top of the page
          freshCookies();
          // Erase the contents of the cookie name and value boxes.
          document.getElementById("arb_cookie_name").value = "";
          document.getElementById("arb_cookie_value").value = "";
        };
        ')
  ),
  fluidRow(
    box(
      title = "Delete cookies",
      p(paste(
        "Use this control to delete a cookie.",
        "Enter the cookie name you'd like to delete and check that it's",
        "gone from the list at the top.",
        "Remember that cookie names are case sensitive."
      )),
      textInput("cookie_to_delete", "Name of cookie to delete:"),
      actionButton("delete_cookie", "Delete cookie", style = "simple", size = "sm", color = "warning"),
    ),
    tags$script('
        // react to button press
        document.getElementById("delete_cookie").onclick = function() {
          // Get cookie name from the input box
          var cookie_name = document.getElementById("cookie_to_delete").value ;
          // delete the cookie
          deleteCookie(cookie_name);
          // erase the contents of the input box
          document.getElementById("cookie_to_delete").value = "";
          // refresh the full list of cookies a the top of the page
          freshCookies();
        };
        ')
  ),
  tags$script('
        // function to refresh the full list of cookies at the top of the page
        function freshCookies(){
          // Read in al the cookies
          var my_cookies = document.cookie;
          // pass back to shiny
          Shiny.onInputChange("all_cookies", my_cookies);
        };

        // waiting for 1 second allows the Shiny js library to load before
        // running the cookie refresh function
        setTimeout(freshCookies, 1000)
        ')
)

server <- shinyServer(function(input, output, session) {
  output$full_cookie_list <- renderPrint({
    input$all_cookies
  })

  output$custom_cookie <- renderPrint({
    input$my_cookie
  })

  output$cookie_set <- renderPrint({
    input$checked_cookie
  })

  output$arb_cookie_set <- renderPrint({
    input$checked_arb_cookie
  })
})

shinyApp(ui = ui, server = server)
