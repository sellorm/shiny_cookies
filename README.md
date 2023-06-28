# Handling cookies in Shiny apps

This repo contains a small demo app that illustrates one way to work with
cookies withing a Shiny app.

All the real work is offloaded to javascript with information being passed
back into the app through Shiny's javascript interface, specifically,
`Shiny.onInputChange()`.

This aproach is very lightweight, but other approaches also exist such as the
[cookies](https://cran.r-project.org/package=cookies) package, which you may
prefer.

Run the `app.R` file (Mac and Linux users can also start the app with the
`app.sh` script) to see an interactive demo of the cookie handling.

Besides the `app.R` file, the only other requirement is the `www/cookies.js`
javascript file. This contains some helper functions for use in the embedded
javascript that's inline in `app.R`.

