# In order to enable a new banner message:
#
# * change the value of cookieKey below
# * set the correct options for the $.growl call below
# * uncomment the line "// require shared/banner_message" in common.js

$ = jQuery

BannerMessage =
  # NB: This value needs to be changed each time a new banner is added.
  cookieKey: 'os-deprecation-announcement'

  cookieDismissedKey: ->
    @cookieKey + '-dismissed'

  cookieViewedKey: ->
    @cookieKey + '-viewed'

  #
  # Mark the banner as having been viewed.
  markBannerAsViewed: ->
    unless $.cookie( @cookieViewedKey() )
      $.cookie @cookieViewedKey(), Date.now()

  #
  # Calculate the distance in days between two Dates.
  #
  # adapted from http://www.htmlgoodies.com/html5/javascript/calculating-the-difference-between-two-dates-in-javascript.html
  daysBetween: ( date1, date2 ) ->
    # Get 1 day in milliseconds
    oneDay = 1000*60*60*24

    # Convert both dates to milliseconds
    date1Ms = date1.getTime()
    date2Ms = date2.getTime()

    # Calculate the difference in milliseconds
    differenceMs = date2Ms - date1Ms

    # Convert back to days and return
    Math.round( differenceMs/oneDay )

  #
  # Expire the banner 5 days after first displayed.
  bannerExpired: ->
    cookieViewedDate = new Date()
    cookieViewedDate.setTime( $.cookie(@cookieViewedKey()) )

    @daysBetween( cookieViewedDate, new Date() ) > 5

  bind: ->
    # Listen to the close button for this growl message, only.
    $('.banner-message').parent().siblings('.growl-close').on 'click', =>
      $.cookie( @cookieDismissedKey(), '1' )

  #
  # Display the banner message.
  display: ->
    @markBannerAsViewed()

    if WORKSPACE_ID and !( $.cookie( @cookieDismissedKey() ) == '1' ) and !@bannerExpired()
      $.growl
        title:    'End of Support Announcement'
        location: 'br'
        style:    'warning'
        static:   true
        size:     'large'
        message:  """
                  <div class='banner-message'>
                    <p>Metasploit will no longer be supported on Windows Server
                    2003 platforms effective July 2015 due to an upcoming end of
                    vendor support for Windows Server 2003. If you are currently
                    running this platform, we strongly recommend you migrate to
                    a newer version of Windows Server before the end of support
                    date.</p>
                  </div>
                  """

      @bind()

$(document).ready ->
    BannerMessage.display()


