---
---

$ ->
  $(window).on 'click', 'a.gotop-button', (event) ->
    event.preventDefault()
    $('body').animate(scrollTop: 0)

  $(window).scroll ->
    if $(window).scrollTop() > 50 and $(document).height() > $(window).height()
      $('.gotop-button').show()
    else
      $('.gotop-button').hide()

