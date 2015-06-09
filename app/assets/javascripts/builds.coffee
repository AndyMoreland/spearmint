# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@toggleIssueDedupe = (element) ->
  dedupe = element.checked
  window.location = window.location.pathname + (if dedupe then '?dedupe=1' else '')

@startPollingForFinishedBuild = (project_id, build_id, callback) ->
  timerCallback = () ->
    $.get "/projects/#{project_id}/builds/#{build_id}.json", (data) ->
      if data? && data.status != "queued" && data.status != "waiting"
        callback(data)
    
  window.setInterval timerCallback, 1000
  
@reloadPage = () ->
  window.location = window.location.pathname
