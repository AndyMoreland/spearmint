# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

(($) ->
    $ ->
        # Resize overflowing stats to fit in panel
        $("span.stat").each () ->
            if $(this).width() > $(this).parent().width()
                factor = $(this).parent().width() / $(this).width()
                $(this).css
                    "font-size": factor * 100 + "%"
) jQuery
