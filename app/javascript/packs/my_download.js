function realTimeGetMyDownloadState() {
  var arr = []
  for(var item of $("input[name='download-record']:checked")){
    arr.push(item.dataset.id)
  }
  if(arr.length<=0){
    return true
  }
  $.get("/my_downloads/get_last_state", {"my_download_ids":arr},function(data){
    for(var item of data){
      var id = item[0];
      $(".state-line-"+id).html(item[1]);
      $(".download-progress-bar-"+id).css('width',item[2]+"%");
      $(".download-progress-bar-tag-"+id).html(item[2]+"%");
      if (item[1]=='prepareing') {
        $(".download-action-"+id).html("<a target='_blank' class='btn btn-sm btn-white' href='/my_downloads/"+id+"/download'>下载</a>");
      }
    }
  });
}

document.addEventListener("turbolinks:load", function() {
  $(() => setInterval(realTimeGetMyDownloadState, 3000));
});