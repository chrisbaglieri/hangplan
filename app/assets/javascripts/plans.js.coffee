# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

hide_tentative = ->
  if ($('#plan_tentative').is(':checked'))
    $('#time_entry').hide()
    $('select[id^="plan_time"]').attr('disabled', 'disabled')
  else
    $('#time_entry').show()
    $('select[id^="plan_time"]').removeAttr('disabled')

$(document).ready ->
  hide_tentative()
  $('#plan_tentative').click(hide_tentative)

