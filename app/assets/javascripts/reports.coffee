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

        # Sometimes sortable tables plugin doesn't activate by itself...
        Sortable.init()

        $(".stat-panel").on "click", (ev) ->
          $el = $(ev.currentTarget)

          showReport = (data) ->
            x = 0
            for stat in data
              stat.date = new Date(stat.date)
              stat.value = x
              x += 1

            console.log(data)
            $graph = $el.find(".graph")
            $graph.empty();

            height = 168
            width = 340

            x = d3.time.scale()
              .range([0, width])

            y = d3.scale.linear()
              .range([height, 0])

            line = d3.svg.line()
              .x (d) -> x(d.date)
              .y (d) -> y(d.value)

            x.domain(d3.extent(data, (d) -> d.date))
            y.domain(d3.extent(data, (d) -> d.value))
            
            d3.select($graph.get(0)).append("svg")
              .attr 'width', width
              .attr 'height', height
              .append("path")
                .datum(data)
                .attr("class", "line")
                .attr("d", line)

          unless $el.hasClass('expanded')
            $.get "/projects/" + $el.data('project-id') + "/trends/" + $el.data('statistic') + ".json", { report_source: $el.data('source') }, showReport

          $el.toggleClass('expanded')
          $el.find(".panel-body").toggle()
          $el.find(".panel-heading").toggle()
          $el.find(".graph").toggle()
          
) jQuery



