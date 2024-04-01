function uploadProgress(arg) {
  var formData=new FormData(); //通过FormData对象可以组装一组用 [XMLHttpRequest]发送请求的键/值对,它可以更灵活方便的发送表单数据。
  var Upload=document.getElementById("upload");

  var fileList=Upload.files;
  for(let i=0;i<fileList.length;i++)
  {  
    var file=fileList[i];
    //比如在这里可以检查文件类型是不是图片
    if(!/.+\.(jpg|jpeg|gif|bmp|png)$/.test(file.name))
    {
      alert("请上传图片文件！");
      return ;
    }
    formData.append("files[]", file);
  }
  // 展示进度条
  $('.progress').removeClass("hide");
  // 隐藏上传按钮
  $('label').css('display','none');
  $.ajax({url: "/orders/upload_design_images_action",
    type: "POST",
    processData: false,
    contentType : false,
    data: formData,
    xhr: function() {
      var xhr = new XMLHttpRequest();
      //使用XMLHttpRequest.upload监听上传过程，注册progress事件，打印回调函数中的event事件
      xhr.upload.addEventListener('progress', function (e) {
        //loaded代表上传了多少
        //total代表总数为多少
        var progressRate = (e.loaded / e.total) * 100 + '%';
        //通过设置进度条的宽度达到效果
        $('.progress-bar').css('width', progressRate);
      })
      return xhr;
    }
  });
}

document.addEventListener("turbolinks:load", function() {
  $(() =>$('#upload').on('change', (args) => uploadProgress(args)));
});