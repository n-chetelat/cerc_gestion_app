$(document)
.ready(function() {

  $(document).find(".has-choices").map((i, inputEl) => {
    setChoiceVisibility(inputEl)
  })

  $(document).bind("change", ".has-choice", function(event){
    setChoiceVisibility(event.target)
  })

})

function setChoiceVisibility(inputEl) {
  const need_choices = ["5", "6", "7"]
  const needs_choices = need_choices.some((value) => value === $(inputEl).val())
  const parent_li = $(inputEl).parent("li")[0]
  const hideable = $(parent_li).siblings(".hideable")[0]
  if (needs_choices) {
    $(hideable).css("display", "block")
  } else {
    $(hideable).css("display", "none")
  }
}
