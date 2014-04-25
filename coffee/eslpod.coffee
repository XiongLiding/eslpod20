sprintf = _.string.sprintf

date = (time) ->
  sprintf('%d.%02d.%02d', time.getFullYear(), time.getMonth() + 1, time.getDate())

samplingRate = (interval) ->
  mark = 0
  ->
    now = Date.now()
    return false if now - mark < interval
    mark = now

download = (uri, fnProgress, fnEnd, fnError) ->
  target = sprintf('cdvfile://localhost/persistent/%s', uri.split('/').pop())
  ft = new FileTransfer
  ft.onprogress = fnProgress
  ft.download uri, target, fnEnd, fnError
  ft.abort

showPlayer = ($podcast) ->
  $($('#player').html()).appendTo($podcast)

showProgress = ($podcast) ->
  $($('#progress').html()).appendTo($podcast)

audio = ($podcast, fileURL) ->
  media = new Media(fileURL)
  $player = showPlayer($podcast)
  $player
    .on 'touchstart', '.play', ->
      $('button', $player).removeClass('active')
      $(this).addClass('active')
      media.play()
    .on 'touchstart', '.pause', ->
      $('button', $player).removeClass('active')
      $(this).addClass('active')
      media.pause()
    .on 'touchstart', '.stop', ->
      $('button', $player).removeClass('active')
      media.stop()
    .on 'touchstart', '.back', ->
      media.getCurrentPosition (current) ->
        to = current - 5
        to = 0 if to < 0
        media.seekTo(to * 1000)

$ ->
  if typeof cordova isnt 'undefined'
    console.log = (v) ->
      $span = $('<span>').text(JSON.stringify(v))
      $('#debug').append($span).append('<br/>')
    console.log 'cordova'
  else
    console.log 'browser'

  list = (podcast) ->
    $s = $(_.template('<div class="podcast"><h1 class="title"><%= title %></h1><p><%= desc %></p><p class="date"><%= date %></p><button class="btn btn-default" data-uri="<%= download %>">下载</button></div>', podcast))
    $('.app').append($s)

  $.get 'http://192.168.1.123/podcast.json', (podcasts) ->
    _.each podcasts, (podcast) ->
      list podcast
  , 'json'

  $('body')
    .on 'touchstart', '.podcast button', ->
      $button = $(this)
      uri = $button.data('uri')
      target = uri.split('/').pop()
      $podcast = $button.closest('.podcast')
      $button.hide()
      $progress = showProgress($podcast)
      $podcast.append($progress)
      uri = 'http://192.168.1.123/star.mp3'
      download uri
      , (e) ->
        percent = sprintf('%d%%', e.loaded / e.total * 100)
        $('.progress-bar', $progress).css(width: percent)
        $('.progress-text', $progress).text(percent)
      , (fileEntry) =>
        $('.progress-bar', $progress).css(width: '100%')
        setTimeout ->
          $button.remove()
          $progress.remove()
          audio($podcast, fileEntry.toURL())
        , 500
      , (error) ->
        console.log error

    $(this).text('cancel')

$(document).on 'backbutton', ->
  $('#debug').toggle()
