//= require active_admin/base
//= require active_admin/active_admin_globalize.js
//= require select2
//= require activeadmin-orderable
//= require tinymce

$(document)
.ready(function() {
  $(".filter_form_field.filter_select select").each(function() {
    $(this).select2({
      width: '100%',
    });
  });

  $("select.select2").each(function() {
    init_select2($(this));
  });

  tinymce.init({
    selector: 'textarea.tinymce',
    width: 'auto',
    menubar: false,
    plugins: [
      'advlist autolink link image lists charmap hr anchor pagebreak spellchecker',
      'searchreplace wordcount visualblocks visualchars code insertdatetime nonbreaking',
      'save table directionality emoticons template paste textcolor'
    ],
    toolbar: 'undo redo | styleselect | bold italic removeformat | alignleft aligncenter alignright | bullist numlist outdent indent | link image | code',
    entity_encoding: "raw",
  });

  // $(".colorpicker").each(function() {
  //   $(this).minicolors()
  // });

})

.on('has_many_add:after', '.has_many_container', function(e, fieldset, parent) {
  fieldset.find("select.select2").each(function() {
    init_select2($(this));
  });
})

.on('modal_dialog:after_open', 'body', function(e, form) {
  form.find("select").each(function() {
    $(this).select2({
      width: '100%',
    });
  });
});

function init_select2(element) {
  var options = {
    language: 'en',
    allowClear: true,
    placeholder: "",
    width: '50%',
  };
  if (url = element.data("ajax--url")) {
    options['minimumInputLength'] = 2;
    options['ajax'] = {};
    options['ajax']['delay'] = 250;
    options['ajax']['url'] = url;
    options['ajax']['processResults'] = function(data, page) { return {results: data}; };
  }
  element.select2(options);
}
