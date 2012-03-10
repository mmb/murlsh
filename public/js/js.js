/*global $, document, navigator, window, twttr*/

var Murlsh = function ($, navigator, window, twtter) {
    "use strict";

    var my = {},
        hrefRes = {
            imageshack :
                /^http:\/\/img\d+\.imageshack\.us\/img\d+\/\d+\/\w+\.(?:jpe?g|gif|png)$/i,
            imgur :
                /^http:\/\/(?:i\.)?imgur\.com\/[a-z\d]+\.(?:jpe?g|gif|png)$/i,
            minus :
                /^http:\/\/i\.min\.us\/[a-z]+\.(?:jpe?g|gif|png)$/i,
            twitter :
                /^https?:\/\/twitter\.com\/\w+\/status(?:es)?\/\d+$/i,
            vimeo :
                /^http:\/\/(?:www\.)?vimeo\.com\/(\d+)$/i,
            youtube :
                /^https?:\/\/(?:(?:www|uk)\.)?youtube\.com\/watch\?v=([\w\-]+)(?:&|$)/i
        },
        vimeoEmbedCount = 0,
        // SHA1 and MD5 sums
        sumRe = /(^|\s)([\da-f]{4})(?:[\da-f]{36}|[\da-f]{28})(?=$|\s)/i;

    function setupClickHandler(jQueryObject, dataKey, dataValue, handler) {
        if (!my.isIphone()) {
            jQueryObject.data(dataKey, dataValue).click(handler).addClass(
                'clickable');
        }
    }

    function autoLink(s) {
        // turn urls into links
        var result = s.replace(
            /https?:\/\/(?:[0-9a-z](?:[0-9a-z\-]{0,61}[0-9a-z])?\.)+[a-z]+\/[0-9a-z$_.+!*'(),\/?#\-]*/gi,
            '<a href="$&">$&</a>');

        return result;
    }

    function bindKeyClick(input, key, clickTarget) {
        input.keyup(function (event) {
            if (event.keyCode === key) {
                clickTarget.click();
            }
        });
    }

    function hoverAddClass(jQueryObject, klass) {
        jQueryObject.hover(
            function () {
                $(this).addClass(klass);
            },
            function () {
                $(this).removeClass(klass);
            });
    }

    function makeIframe(src, extraAttrs) {
        var allAttrs = {
            src: src,
            width: 640,
            height: 385,
            frameborder: 0
        };
        $.extend(allAttrs, extraAttrs);

        return $('<iframe />', allAttrs);
    }

    function img(src, text) {
        text = text || '';
        return $('<img />', {
            src : src,
            alt : text,
            title : text
        });
    }

    function makeFit(e, maxWidth, maxHeight) {
        var height = e.height(),
            scale,
            width = e.width();

        // sometimes in Chrome this fires when height and width are still 0
        if (height > 0 && width > 0) {
            if (width > maxWidth || height > maxHeight) {
                scale = Math.min(maxWidth / width, maxHeight / height);
                e.width(Math.round(width * scale));
                e.height(Math.round(height * scale));
            }
        } else {
            setTimeout(function() { makeFit(e, maxWidth, maxHeight) }, 1000);
        }
    }

    function closerAdd(x, header) {
        var html = (typeof x === 'object') ? $('<div />').append(x).html() : x;

        $.jGrowl(html, {
            closeTemplate : 'X',
            glue : 'before',
            header : header,
            sticky : true,
            beforeOpen : function (e) {
                e.find('.jGrowl-message img').load(function () {
                    makeFit($(this), Math.round($(window).width() / 2),
                        Math.round($(window).height() - 100));
                });
            },
            animateOpen : { width : 'show' },
            animateClose : { width : 'hide' }
        });
    }

    function imgClick(event) {
        closerAdd(img($(event.target).data('href')));
    }

    function vimeoClick(event) {
        var iframeId = 'vimeoEmbed' + vimeoEmbedCount++,
            iframe = makeIframe(
                'http://player.vimeo.com/video/' + $(event.target).data('id') +
                '?js_api=1&js_swf=' + iframeId, { id : iframeId });

        closerAdd(iframe);
    }

    function youtubeClick(event) {
        var iframe = makeIframe(
            'http://www.youtube.com/embed/' + $(event.target).data('id'), {
                'class': 'youtube-player',
                type: 'text/html'
            });

        closerAdd(iframe);
    }

    my.addExtra = function () {
        var thisA = $(this),
            href = thisA.attr('href'),
            match = {},
            tweetMatch,
            tweetLink,
            formattedTweet;

        $.each(hrefRes, function (x, re) {
            return !(match[x] = re.exec(href));
        });

        if (match.imageshack || match.imgur || match.minus) {
            setupClickHandler(thisA.siblings('img'), 'href', href, imgClick);
        } else if (match.twitter) {
            thisA.siblings('img').addClass('twitter');
            tweetMatch = /^(@[0-9a-z_]+?): (.+)$/i.exec(thisA.text());
            if (tweetMatch) {
                tweetLink = $('<a />', {
                    href : href,
                    text : tweetMatch[1]
                });

                formattedTweet = $('<span />', { className : 'tweet' }).append(
                    tweetLink).append(': ').append(
                    twttr.txt.autoLink(tweetMatch[2]));

                thisA.replaceWith(formattedTweet);
            }
        } else if (match.vimeo) {
            setupClickHandler(thisA.siblings('img'), 'id', match.vimeo[1],
                vimeoClick);
        } else if (match.youtube) {
            setupClickHandler(thisA.siblings('img'), 'id', match.youtube[1],
                youtubeClick);
        }

        // shorten SHA1 and MD5 sums to their first 4 characters
        thisA.text(thisA.text().replace(sumRe, '$1$2...'));
    };

    my.formatLi = function (d) {
        var iconSize = 32,
            li = $('<li />').append($('<a />', {
                href : d.url,
                text : d.title
            }));

        if (d.name) {
            li.prepend($('<div />', {
                className : 'name',
                text : d.name
            }));
        }

        if (d.email) {
            li.prepend($('<div />', { className : 'icon' }).append(
                img('http://www.gravatar.com/avatar/' + d.email + '?s=' +
                    iconSize, d.name).attr({
                    width : iconSize,
                    height : iconSize
                })));
        }

        return li;
    };

    my.iphoneInit = function () {
        window.onorientationchange = function () {
            var width = 442;
            if (window.orientation === 0 || window.orientation === 180) {
                width = 282;
            }
            $('#urls').width(width);
        };

        window.onorientationchange();

        $('#menu').append(' | ').append($('<a />', {
            href : '#bottom',
            text : 'Bottom'
        }));
    };

    my.isIphone = function () {
        return navigator.userAgent.match(/i(phone|pod)/i);
    };

    my.liClick = function (event) {
        var target = $(event.target),
            // target could be the li or any child of it, find self or parent
            // li with id starting with liu
            li = target.add(target.parents('li')).filter('[id^="liu"]').first(),
            deleteButton;

        if (!li.hasClass('selected')) {
            $('#deleteButton,#deletePassword').remove();
            $('li.selected').removeClass('selected');
            li.addClass('selected');

            deleteButton = $('<span />').attr('id', 'deleteButton').text(
                'Delete');
            hoverAddClass(deleteButton, 'deleteButtonHover');

            deleteButton.click(function (event) {
                deleteButton.unbind('click');
                var deletePassword = $('<input />').attr({
                    id : 'deletePassword',
                    size : 12,
                    type : 'password'
                });
                $(event.target).before(deletePassword).before(' ');
                deletePassword.focus();

                deleteButton.click(function (event) {
                    if (deletePassword.val()) {
                        var urlId = li.attr('id').substring(3);

                        $.ajax('url/' + urlId, {
                            data : { auth : deletePassword.val() },
                            type : 'DELETE',
                            success : function () {
                                li.remove();
                            },
                            error : function (jqXHR, textStatus, errorThrown) {
                                var message = 'Delete failed';
                                if (jqXHR.status === 403) {
                                    message = 'Invalid password'; 
                                }
                                deletePassword.val('');
                                $.jGrowl(message);
                            }
                        });
                    }
                });
                bindKeyClick(deletePassword, 13, deleteButton);
            });

            li.append(' ').append(deleteButton);
        }
    };

    return my;
};

$(function () {
    "use strict";
    var murlsh = new Murlsh($, navigator, window, twttr), urls;

    if (murlsh.isIphone()) {
        murlsh.iphoneInit();
    }

    $('#submit').click(function () {
        $.post('url', {
            url : $('#url').val(),
            title : $('#title').val(),
            via : $('#via').val(),
            auth : $('#auth').val()
        }, function (d) {
            $.each(d, function (i, v) {
                var li = murlsh.formatLi(v);
                $('#urls').prepend(li);
                $(li).children('a:first').each(murlsh.addExtra);
            });
            $('#url,#title,#via').val('');
        }, 'json');
    });

    $('li').click(murlsh.liClick);

    urls = $('a.m');
    urls.each(murlsh.addExtra);
});
