function flickr_thumb(d) {
  var zoom = 'http://farm' + d.photo.farm + '.static.flickr.com/' +
      d.photo.server + '/' + d.photo.id + '_';
  if (d.photo.originalsecret) {
    zoom += d.photo.originalsecret + '_o.' + d.photo.originalformat;
  } else {
      zoom += d.photo.secret + '_m.jpg';
  }

  return $('<img />').addClass('thumb flickr').attr({
    alt : d.photo.title._content,
    src : 'http://farm' + d.photo.farm + '.static.flickr.com/' +
      d.photo.server + '/' + d.photo.id + '_' + d.photo.secret + '_s.jpg',
    title : d.photo.title._content
  }).data('zoom', zoom);
}

function flickr_click() {
  closer_add($('<img />').attr({
    src : $(this).data('zoom')
  }));
}

function vimeo_thumb(d) {
  return $('<img />').addClass('thumb vimeo').attr({
    alt : d.title,
    src : d.thumbnail_url,
    height : d.thumbnail_height,
    width : d.thumbnail_width,
    title : d.title
  });
}

function vimeo_click() {
  closer_add($(this).data('embed_html'));
}

function youtube_thumb(id) {
  return $('<img />').addClass('thumb youtube').attr({
    src :'http://img.youtube.com/vi/' + id + '/1.jpg',
    title : 'click to watch'
  }).data('id', id);
}

function youtube_click() {
  var movie = 'http://www.youtube.com/v/' + $(this).data('id') +
    '&amp;hl=en&amp;fs=1&amp;showsearch=0';
  closer_add(object_tag(movie, 344, 425, [
    { name : 'movie', value : movie }
  ]));
}

function imageshack_click() {
  closer_add($('<img />').attr({ src : $(this).data('href') }));
}

function add_extra() {
  var flickr_match;
  var imageshack_match;
  var mp3_match;
  var vimeo_match;
  var youtube_match;
  var this_a = $(this);
  if (youtube_match = /http:\/\/(?:(?:www|uk)\.)?youtube\.com\/watch\?v=(.+?)(?:&|$)/.exec(
    $(this).attr('href'))) {
    var img = youtube_thumb(youtube_match[1]);
    if (is_iphone()) {
      $(this).prepend(img);
    } else {
      $(this).before(img.click(youtube_click));
    }
  } else if (flickr_match = /http:\/\/(?:www\.)?flickr\.com\/photos\/[^\/]+?\/([0-9]+)/.exec(
    $(this).attr('href'))) {
    function flickr_thumb_insert(d) {
      var img = flickr_thumb(d);
      if (is_iphone()) {
        this_a.prepend(img);
      } else {
        this_a.before(img.click(flickr_click));
      }
    }
    $.getJSON('http://api.flickr.com/services/rest/?api_key=d04e574aaf11bf2e1c03cba4ee7e5725&method=flickr.photos.getinfo&format=json&photo_id=' +
      flickr_match[1] + '&jsoncallback=?', flickr_thumb_insert);
  } else if (vimeo_match = /^http:\/\/(?:www\.)?vimeo\.com\/([0-9]+)$/.exec(
    $(this).attr('href'))) {
    function vimeo_thumb_insert(d) {
      var img = vimeo_thumb(d);
      if (is_iphone()) {
        this_a.prepend(img);
      } else {
	  this_a.before(img.data('embed_html', d.html).click(vimeo_click));
      }
    }
    $.getJSON('http://vimeo.com/api/oembed.json?url=http%3A//vimeo.com/' +
      vimeo_match[1] + '&callback=?', vimeo_thumb_insert);
  } else if (mp3_match = /.*\.mp3$/.exec($(this).attr('href'))) {
    var swf = 'swf/player_mp3_mini.swf';
    $(this).before(object_tag(swf, 20, 200, [
      { name : 'bgcolor', value : '#000000' },
      { name : 'FlashVars', value : 'mp3=' + mp3_match[0] },
      { name : 'movie', value : swf }
    ]));
  } else if (imageshack_match =
    /^(http:\/\/img\d+\.imageshack\.us\/img\d+\/\d+\/\w+\.)(jpg|gif|png)$/i.exec(
    $(this).attr('href'))) {
    var thumb = $('<img />').attr('src', imageshack_match[1] + 'th.' +
      imageshack_match[2]);
    if (is_iphone()) {
      this_a.html(thumb);
    } else {
      this_a.replaceWith(thumb.data('href', imageshack_match[0]).click(
        imageshack_click));
    }
  }
}

function format_li(d) {
  var li = $('<li />').append($('<a />').attr('href', d['url']).text(
    d['title']));

  if (d['name']) {
    li.prepend($('<div />').addClass('name').text(d['name']));
  }

  var icon_size = 32;

  if (d['email']) {
    li.prepend($('<div />').addClass('icon').append(
      $('<img />').attr({
        src :  'http://www.gravatar.com/avatar/' + d['email'] + '?s=' +
          icon_size,
        title : d['name'],
        alt : d['name'],
        width : icon_size,
        height : icon_size
      })));
  }

  return li;
}

function object_tag(data, height, width, params) {
  var result = '<object data="' + data + '" height="' + height +
    '" type="application/x-shockwave-flash" width="' + width + '">';
  jQuery.each(params, function(i, v) {
    result += '<param name="' + v.name + '" value="' + v.value + '" />';
  });
  result += '</object>';
  return result;
}

function close() {
  $(this).parent().remove();
}

function closer_add(x) {
  var body_width = $('body').width();
  if (x.css) {
      x.css('max-width', body_width - 45);
  }
  var div = $('<div />').addClass('closer_embed').css('max-width', body_width);
  $('#closer').prepend(div.append(x).append($('<input />').addClass(
    'close').attr({
    type : 'button',
    value : 'X'
  }).click(close)));
  div.corner('round tl').corner('round bl');
}

function orientation_changed() {
  if (window.orientation == 0 || window.orientation == 180) {
    $('#urls').width(290);
  } else {
    $('#urls').width(450);
  }
}

window.onorientationchange = orientation_changed;

function is_iphone() {
  return navigator.userAgent.match(/i(phone|pod)/i);
}

$(document).ready(function() {
  orientation_changed();
  $('a').map(add_extra);
  $('#urls li:even').addClass('even');

  $('#submit').click(function() {
    $.post('ajax.cgi', {
      url : $('#url').val(),
      auth : $('#auth').val()
      }, function(d) {
        $.each(d, function(i, v) {
          var li = format_li(v);
          $('#urls > li:first').after(li);
          $(li).children('a:first').map(add_extra);
        });
        $('#url').val('');
      }, 'json');
  });

  if ($.cookie('auth')) {
    $('#auth').val($.cookie('auth'));
  }
});
