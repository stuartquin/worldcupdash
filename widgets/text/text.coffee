class Dashing.Text extends Dashing.Widget
  @colours =
    "brazil": "#FFDF00"
    "netherlands": "#FF6600"
    "spain": "#E3000B"
    "england": "#FFFFFF"
    "italy": "#0000FF"
    "uruguay": "#4B8CC1"
    "argentina": "#75C5F0"
    "honduras": "#FFFFFF"
    "colombia": "#FFFF00"
    "portugal": "#850B23"
    "germany": "#FFFFFF"

  @inverse = ["brazil", "england", "argentina", "honduras", "germany"]

  onData: (data) ->
    country = data.country.toLowerCase()
    colour = Text.colours[data.country.toLowerCase()]
    if colour
      $(@node).css('background-color', colour)

      if Text.inverse.indexOf(country) > -1
        $(@node).css('color', '#000')
        $(@node).find('h3').css('color', '#000')
        $(@node).find('h1').css('color', '#000')
