#!/usr/bin/env bash
R -e 'shiny::runApp("app.R", host="0.0.0.0", port=8888)'
