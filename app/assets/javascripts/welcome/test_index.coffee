# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#$(document).ready ->
#  alert "page has loaded!"

#  $(document).on "page:change", ->
#  alert "page has loaded!"



paintIt = (element, link) ->
#  element.style.backgroundColor = backgroundColor
#  if textColor?
#    element.style.color = textColor

#  if link?
  element.href = link


$ ->
  $("a[data-background-color]").click (e) ->
    e.preventDefault()

    create_db_path_link = $(this).data("create_db_path")
    show_cam_path_link = $(this).data("show_cam_path")
    show_soc_path_link = $(this).data("show_soc_path")
    new_and_update_path_link = $(this).data("new_and_update_path")
    export_csv_path_link = $(this).data("export_csv_path")

    #
    create_db_path_target = document.getElementById("create_db_path_id")
    show_cam_path_target = document.getElementById("show_cam_path_id")
    show_soc_path_target = document.getElementById("show_soc_path_id")
    new_and_update_path_target = document.getElementById("new_and_update_path_id")
    export_csv_path_target = document.getElementById("export_csv_path_id")


    paintIt(create_db_path_target, create_db_path_link)
    paintIt(show_cam_path_target, show_cam_path_link)
    paintIt(show_soc_path_target, show_soc_path_link)
    paintIt(new_and_update_path_target, new_and_update_path_link)
    paintIt(export_csv_path_target, export_csv_path_link)




#paintIt = (element, backgroundColor, textColor, link) ->
#  element.style.backgroundColor = backgroundColor
#  if textColor?
#    element.style.color = textColor
#
#  if link?
#    element.href = link
#
#
#
#
#
#$ ->
#  $("a[data-background-color]").click (e) ->
#    e.preventDefault()
#
#    backgroundColor = $(this).data("background-color")
#    textColor = $(this).data("text-color")
#    link = $(this).data("target-link")
#
#
#    console.log(backgroundColor + "backgroundColor !!!!!!!!!!!!!!!!")
#    console.log(textColor + "textColor!!!!!!!!!!!!!!!!")
#
##
#    target_ele = document.getElementById("XD")
#
#
#
#    paintIt(target_ele, backgroundColor, textColor, link)