class Flickr extends Controller
  constructor:($scope, flickrService, localStorageService)->
    $scope.searchPhrase = ''
    $scope.foundImages = []
    $scope.infiniteLog = ''
    $scope.searchLoading = false
    $scope.favouritesImages = localStorageService.get('favouritesImages') || []
    favouritesIds = {}

    page = 1
    searchedPhrase = ''
    infiniteAvaiable = false

    $scope.fullScreenPicture = null
    $scope.showFullScreenPicture = false

    # searching images

    addFoundImages = (found_images) ->
      for image in found_images
        url_base = 'https://farm' + image.farm + '.staticflickr.com/' + image.server + '/' + image.id + '_' + image.secret
        $scope.foundImages.push({
          image_url: url_base + '.jpg',
          thumb_image_url: url_base + '_m.jpg',
          small_image_url: url_base + '_s.jpg',
          title: image.title,
          id: image.id
        })

    $scope.newSearch = ->
      $scope.foundImages = []
      page = 1
      searchedPhrase = $scope.searchPhrase
      infiniteAvaiable = true
      search()

    search = ->
      $scope.searchLoading = true
      flickrService.search(searchedPhrase, page).then (response) ->
        data = response.data
        if data.stat == 'ok'
          addFoundImages(data.photos.photo)
          $scope.searchLoading = false

    $scope.infiniteSearch = ->
      if infiniteAvaiable
        page += 1
        search()

    # favourites
    fillFavouritesIds = ->
      for favourite_image in $scope.favouritesImages
        favouritesIds[favourite_image.id] = true

    fillFavouritesIds()

    $scope.addToFavourites = (image_object) ->
      $scope.favouritesImages.push(image_object)
      localStorageService.set('favouritesImages', $scope.favouritesImages)
      favouritesIds[image_object.id] = true

    $scope.deleteFromFavourites = (image_object) ->
      index = $scope.favouritesImages.indexOf(image_object)
      $scope.favouritesImages.splice(index, 1) if index > -1
      localStorageService.set('favouritesImages', $scope.favouritesImages)
      favouritesIds[image_object.id] = false

    $scope.isFavouriteImage = (image_id) ->
      return favouritesIds[image_id] || false

    # full screen picture

    $scope.showFullPicture = (image_object) ->
      $scope.fullScreenPicture = image_object.image_url
      $scope.showFullScreenPicture = true

    $scope.hideFullPicture = ->
      $scope.showFullScreenPicture = false
      $scope.fullScreenPicture = null