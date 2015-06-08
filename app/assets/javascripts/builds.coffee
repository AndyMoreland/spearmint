# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@toggleIssueDedupe = (element) ->
  dedupe = element.checked
  window.location = window.location.pathname + (if dedupe then '?dedupe=1' else '')