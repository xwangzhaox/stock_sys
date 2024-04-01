$(function () {
  $('.swagger-ui-container').each(function() {
    var id = $(this).attr('id')
      , path = id.replace(/-/g, '_')

    var swaggerUi = new SwaggerUi({
      url: "/api_docs/" + path + ".json",
      dom_id: id,
      supportedSubmitMethods: ['get', 'post', 'put', 'delete', 'patch'],
      onComplete: function(swaggerApi, swaggerUi){
        $('pre code').each(function(i, e) {
          hljs.highlightBlock(e)
        });
      },
      onFailure: function(data) {
        log("Unable to Load SwaggerUI");
      },
      docExpansion: "list",
      jsonEditor: false,
      apisSorter: function(a, b) {
        var aPosition = a.xPosition || 0
          , bPosition = b.xPosition || 0
        return (aPosition > bPosition) ? 1 : -1
      },
      operationsSorter: function(a, b) {
        var aPosition = a.operation['x-position'] || 0
          , bPosition = b.operation['x-position'] || 0
        return (aPosition > bPosition) ? 1 : -1
      },
      defaultModelRendering: 'schema',
      showRequestHeaders: false,
      validatorUrl: null
    });

    swaggerUi.load();

    $('#input_userToken').change(function() {
      var key = $('#input_userToken')[0].value;
      if(key && key.trim() != "") {
        swaggerUi.api.clientAuthorizations.add("key", new SwaggerClient.ApiKeyAuthorization("Authorization", "Bearer " + key, "header"));
      }
    })
  })
});
