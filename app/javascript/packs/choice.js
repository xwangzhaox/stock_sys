import 'packs/choice.js'

const Choices = require('choices.js')
document.addEventListener("turbolinks:load", function() {
  var dropDownSelects = new Choices('#dropdown-choice-select', {removeItemButton: true,shouldSort: false})
})