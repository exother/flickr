class Flickr extends Service
  constructor: ($q, $http)->
    # TODO: move some variables to specific separate files
    @search = (search_text, page) ->
      $http.get 'https://api.flickr.com/services/rest',
        params:
          method: 'flickr.photos.search'
          api_key: '18043eabcc396c7f2acd056eb85db1ee'
          format: 'json'
          nojsoncallback: 1
          per_page: 9
          text: search_text
          page: page
