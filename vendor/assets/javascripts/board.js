$(document)
.ready(function() {

  $(document).find(".is-final").map((i, inputEl) => {
    setInitialAcceptingVisibility(inputEl)
  })

  $(document).bind("change", function(event){
    setAcceptingVisibility(event.target)
  })

})

function setInitialAcceptingVisibility(inputEl) {
  const checked = $(inputEl).find(".is-final-input").is(":checked")
  const hideable = $(inputEl).siblings(".hideable")[0]
  if (checked) {
    $(hideable).css("display", "block")
  } else {
    $(hideable).css("display", "none")
  }
}

function setAcceptingVisibility(inputEl) {
  const checked = $(inputEl).is(":checked")
  const hideable = $(inputEl).closest("li").siblings(".hideable")[0]
  if (checked) {
    $(hideable).css("display", "block")
  } else {
    const hideableCheck = $(hideable).find("label input")[0]
    $(hideableCheck).prop('checked', false)
    $(hideable).css("display", "none")
  }
}
