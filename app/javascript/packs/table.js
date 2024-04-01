// 已选的CheckBox line_item ID列表
var checkList = [];

function selectCheckboxAll(e) {
  if (e.target.checked) {
    // 遍历所有的CheckBox, 显示选中状态，统计这些CheckBox的id列表。显示按钮浮框
    $('.list-checkbox').prop("checked",true);
    $('#close-button-alert-container').addClass("show");
  } else {
    removeChecking();
  }
  updateAlertCheckCount()
}

// 遍历所有的CheckBox，取消选中状态，删除统计这些CheckBox的id列表。隐藏按钮浮框
function removeChecking() {
  $('#listCheckboxAll').prop("checked",false);
  $('.list-checkbox').prop("checked",false);
  $('#close-button-alert-container').removeClass("show");
}

function updateAlertCheckCount() {
  checkList = []
  $('.list-checkbox:checked').each(function(){
    checkList.push($(this).val())
  })
  $('.list-alert-count').html(checkList.length);
}

function actionBtnEvent(e){
  var formData=new FormData();
  formData.append("from", $(".state-container span").html());
  formData.append("target", e.target.dataset.actions);
  formData.append("check_id", checkList);
  // 如果发给工厂，则判断是否修改默认定价
  if(e.target.dataset.actions=='making' && $("#supply-price").css('display')!='none'){
    formData.append("supply_price", $("#supply-price").val());
  }
  // 如果工厂制作完成，则需要添加物流单号
  if(e.target.dataset.actions=='made'){
    if($("#tracking-number").css('display')!='none'){
      formData.append("tracking_number", $("#tracking-number").val());
    }else{
      if(!confirm("确认不填写国内物流单号直接工厂发货吗？")){
        return false;
      }
    }
  }
  if($("#advance-download-switch").is(":checked")){
    // 合并下载事件？
    if($("#downloadPackage").is(":checked")){
      formData.append("download_package", true);
      formData.append("tags", $("#template").val());
    }
    // 按尺寸切分目录？
    if($("#cut-by-size").is(":checked")){
      formData.append("cut_path_by_size_option_in_sku", true);
    }
    // 下载备注，将添加到下载的文件名中
    if($(".download-remark-input").val()!=''){
      formData.append("download-remark-input", $(".download-remark-input").val());
    }
  }
  $.ajax({url: "/line_items/change_state_post_action",
    type: "POST",
    beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
    processData: false,
    contentType : false,
    data: formData,
    success: function(){
      window.location.reload()
    }
  });
}

function exportPackage(e){
  var template = $("#template").val();
  var url = "/orders/export_package?tag="+template+"&check_list="+checkList;
  if($("#cut-by-size").is(":checked")){
    url += "&cut_path_by_size_option_in_sku=true"
  }
  if($(".download-remark-input").val()!=''){
    url += "&download-remark-input="+$(".download-remark-input").val()
  }
  window.location.href = url
}

function exportExcel(e){
  var template = $("#template").val();
  var url = "/orders/export_excel?tag="+template+"&check_list="+checkList;
  if($(".download-remark-input").val()!=''){
    url += "&download-remark-input="+$(".download-remark-input").val()
  }
  window.location.href = url
}

function syncTracking(e) {
  var url = "/orders/sync_tracking?&check_list="+checkList;
  window.location.href = url
}

function sendDesignImageEmail(){
  var url = "/orders/send_design_images_email?check_list="+checkList;
  window.location.href = url
}

function checkTotalFilterLineItems() {
  if($("#advance-download-switch").is(":checked") && $("#check-total-filter-line-item").is(":checked")){
    checkList = $("#total-line-item-ids").val();
  }else{
    updateAlertCheckCount();
  }
}

function hoverLineItem(e){
  image_url = e.currentTarget.dataset.designImage;
  image_size = e.currentTarget.dataset.imageSize;
  image_type = e.currentTarget.dataset.imageType;
  $(".preview-image").attr("src", image_url);
  $("#image-size").html(image_size);
  $("#previewer-container").css('visibility', 'visible');
  if(image_url!=""){
    if(image_type=="png"){
      $(".preview-png").show();
      $(".preview-not-png").hide();
    }else{
      $(".preview-png").hide();
      $(".preview-not-png").show();
    }
  }
}

function outLineItem(e){
  $("#preview-image").attr("src", "#");
  $("#image-size").html();
  $(".preview-png").hide();
  $(".preview-not-png").hide();
  $("#previewer-container").css('visibility', 'hidden');
}

function clickLineItem(e) {
  // 排除备注按钮的点击事件
  if (e.target.className.indexOf("btn-add-comment")>1 || e.target.className.indexOf("item-order")>1 || e.target.className.indexOf("btn-expedited")>1) {return}
  item_id = e.currentTarget.dataset.itemId;
  // 一共分四种情况
  // 1. 点选了CheckBox，并且点之前已经选中了，则改成不选中并更新
  // 2. 点选了CheckBox，并且点之前还未选中，则改成选中并更新
  // 3. 未点选CheckBox，并且点之前已经选中了，则改成不选中并更新
  // 4. 未点选CheckBox，并且点之前还未选中，则改成选中并更新
  if((e.target.className.indexOf("checkbox-"+item_id)>1 && !$(".checkbox-"+item_id).is(":checked"))){
    $(".checkbox-"+item_id).prop('checked', false);
    $('#listCheckboxAll').prop("checked",false);
    updateAlertCheckCount()
    if(checkList.length == 0){
      $('#close-button-alert-container').removeClass("show");
    }
  }else if(e.target.className.indexOf("checkbox-"+item_id)>1 && $(".checkbox-"+item_id).is(":checked")){
    $(".checkbox-"+item_id).prop('checked', true);
    updateAlertCheckCount();
    $('#close-button-alert-container').addClass("show");
  }else if ($(".checkbox-"+item_id).is(":checked")) {
    $(".checkbox-"+item_id).prop('checked', false);
    $('#listCheckboxAll').prop("checked",false);
    updateAlertCheckCount()
    if(checkList.length == 0){
      $('#close-button-alert-container').removeClass("show");
    }
  }else{
    $(".checkbox-"+item_id).prop('checked', true);
    updateAlertCheckCount();
    $('#close-button-alert-container').addClass("show");
  }
}

function switchBtnChecked(e) {
  if($(e.target).is(":checked")){
    $(e.target).next().css('color', 'white');
  }else{
    $(e.target).next().css('color', 'gray');
  }
}

function advanceDownloadSwitch(e) {
  if ($("#advance-download-switch").is(":checked")) {
    $('.advance-download-container').animate({height:'150px',opacity:'1'},"slow");
  }else{
    $('.advance-download-container').animate({height:'0px',opacity:'0'},"slow");
    $('.download-remark-input').val("");
    $('.flipswitch').prop("checked",false);
  }
  checkTotalFilterLineItems();
}

function verifyDesignImage() {
  if ($("nav").css("display")=="none") {
    $("nav").css("display","block");
    $(".main-content").removeClass("col-md-8");
    $(".verify-design-image").addClass("btn-primary");
    $(".verify-design-image").removeClass("btn-white");
  } else {
    $("nav").css("display","none");
    $(".main-content").addClass("col-md-8");
    $(".verify-design-image").removeClass("btn-primary");
    $(".verify-design-image").addClass("btn-white");
  }
}

function displayNewCommentForm(e) {
  $("#myModal").css("display","block");
  var item_id = e.target.dataset.itemId;
  var order_name = e.target.dataset.orderName;
  $(".modal-order-name-tag").html(order_name);
  $("#new-comment").attr("action","/line_items/"+item_id+"/add_comment");
  $("#comment_content").focus();
}

function hideNewCommentForm(e) {
  if (e.target.className=='modal' || e.target.className.indexOf("cancel-modal")>1) {
    $("#myModal").css("display","none");
  }
}

function bindAtType(e) {
  if ($('#comment_content').val().slice(-1) == "@") {
    $('.type-at-container').animate({height:'80px',padding:'1.25rem',opacity:'1'},"slow");
    $('.type-at-container').css('border-top', '1px solid #e3ebf6');
  }else if($(".type-at-container").css("height")=='0px') {
    return true
  }else{
    $('.type-at-container').animate({height:'0px',padding:'0',opacity:'0'},"slow");
    $('.type-at-container').css('border-top', 'none');
  }
}

function selectAtUser(e) {
  if($(e.target).prop("tagName")=="IMG"){
    var username = $(e.target).parents(".user-block").text().replace(/ |\n/g, '');
  }else{
    var username = $(e.target).text().replace(/ |\n/g, '');
  }
  var content = $('#comment_content').val();
  $('#comment_content').val(content+username+" ");
  $('#comment_content').focus();
  bindAtType(e)
}

function setExpedited(e) {
  var item_id = e.target.dataset.itemId;
  $.ajax({url: "/line_items/"+item_id+"/expedited",
    type: "GET",
    contentType : false,
    success: function(data){
      if(data.expedited==0){
        $(e.target).html("设加急");
        $(".item-order-"+item_id+">span.order-name").css('background', 'white');
        $(".item-order-"+item_id+">span.order-name").css('color', '#2c7be5');
        $(".item-order-"+item_id+">span.tag").remove();
      }else{
        $(e.target).html("取消加急");
        $(".item-order-"+item_id+">span.order-name").css('background', 'red');
        $(".item-order-"+item_id+">span.order-name").css('color', 'white');
        $(".item-order-"+item_id).append('<span class="tag" style="font-size:12px;">(加急单)</span>');
      }
    }
  })
}

document.addEventListener("turbolinks:load", function() {
  // 全选按钮
  $(() =>$('#listCheckboxAll:checkbox').on('change', (args) => selectCheckboxAll(args)));
  // 删除列表选中状态，清空已选CheckBox id列表，隐藏事件浮框
  $(() =>$('#closeButtonAlert').on('click', () => removeChecking()));
  $(() =>$('.action-btn').on('click', (args) => actionBtnEvent(args)));
  $(() =>$('#export-package').on('click', (args) => exportPackage(args)));
  $(() =>$('#export-excel').on('click', (args) => exportExcel(args)));
  $(() =>$('#sync-tracking').on('click', (args) => syncTracking(args)));
  // 发送设计图给客户
  $(() =>$('#send-design-image-email').on('click', (args) => sendDesignImageEmail()));
  // 列表项的事件绑定
  $(() =>$('.line-items').on('click', (args) => clickLineItem(args)));
  $(() =>$('.line-items').on('mouseover', (args) => hoverLineItem(args)));
  $(() =>$('.line-items').on('mouseleave', (args) => outLineItem(args)));
  // 合并打包下载按钮
  $(() =>$('.flipswitch').on('change', (args) => switchBtnChecked(args)));
  // 全选当前筛选条件下的所有订单
  $(() =>$('#check-total-filter-line-item').on('click', () => checkTotalFilterLineItems()));
  // 高级选项滑块打开按钮
  $(() =>$('#advance-download-switch').on('change', (args) => advanceDownloadSwitch(args)));
  // 审图按钮
  $(() =>$('.verify-design-image').on('click', (args) => verifyDesignImage()));
  // 设加急功能
  $(() =>$('.btn-expedited').on('click', (args) => setExpedited(args)));
  // 添加备注模态框开启、关闭
  $(() =>$('.btn-add-comment').on('click', (args) => displayNewCommentForm(args)));
  $(() =>$('#myModal, .cancel-modal').on('click', (args) => hideNewCommentForm(args)));
  // @功能
  $(() =>$('#comment_content').on('input', (args) => bindAtType(args)));
  $(() =>$('.user-block').on('click', (args) => selectAtUser(args)));
  // 加载结束2秒后隐藏掉notice
  $(() =>setTimeout(function(){$('.notice').animate({height:'0px',opacity:'0', padding:'0px', 'margin-bottom': '0px'},"slow")},2000));
});

