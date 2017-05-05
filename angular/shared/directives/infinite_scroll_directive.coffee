class InfiniteScroll extends Directive
  constructor: ($timeout) ->
    infinite_scroll =
      restrict: "A"
      scope:
        infiniteScroll: '&'
      replace: true
      link: (scope, el, attrs)->
        # TODO: implement scroll distance, stub for future use
        scrollDistance = 0
        scrollEnabled = true
        handler = ->
          windowBottom = $(window).height() + $(window).scrollTop()
          elementBottom = $(el).offset().top + $(el).height()
          remaining = elementBottom - windowBottom
          shouldScroll = remaining <= $(window).height() * scrollDistance

          if shouldScroll && scrollEnabled
            scrollEnabled = false
            scope.infiniteScroll()

            $timeout (->
              scrollEnabled = true
            ), 500



        $(window).on 'scroll', handler

    return infinite_scroll