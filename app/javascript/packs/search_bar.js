document.addEventListener("turbolinks:load", function() {
  // 展开关闭按钮
  $(() =>$('.search-bar-switch, #filter').on('click', (args) => searchBarSwitch(args)));
  // 显示模式选择CheckBox的点击事件
  // 如果有任意一个被点选，则不点选全部按钮，如果取消了所有点选，则默认选中全部按钮，如果点选了全部按钮，则取消选中其他所有站点按钮
  $(() =>$('.display_model_checkbox').on('click', (args) => displayModelCheckbox(args)));
  // 站点选择CheckBox的点击事件
  // 如果有任意一个被点选，则不点选全部按钮，如果取消了所有点选，则默认选中全部按钮，如果点选了全部按钮，则取消选中其他所有站点按钮
  $(() =>$('.site_checkbox').on('click', (args) => siteCheckbox(args)));
  // 站点选择CheckBox的点击事件
  // 如果有任意一个被点选，则不点选全部按钮，如果取消了所有点选，则默认选中全部按钮，如果点选了全部按钮，则取消选中其他所有站点按钮
  $(() =>$('.supplier_checkbox').on('click', (args) => supplierCheckbox(args)));
  // 状态选择CheckBox的点击事件
  // 如果有任意一个被点选，则不点选全部按钮，如果取消了所有点选，则默认选中全部按钮，如果点选了全部按钮，则取消选中其他所有站点按钮
  $(() =>$('.state_checkbox').on('click', (args) => stateCheckbox(args)));
  // 如果修改了日期范围后日期选择框的值，则更新“范围”选项的value
  $(() =>$('.range-date').on('change', (args) => updateDateRangeValue(args)));
});

function searchBarSwitch(e) {
  if($(".search-bar").css('height')=='0px'){
    $('.search-bar').animate({height:'625px',opacity:'1'},"slow");
  }else{
    $('.search-bar').animate({height:'0px',opacity:'0'},"slow");
  }
}

function siteCheckbox(e) {
  if(e.currentTarget.value=='0'){  // 如果点选了"全部"按钮，则取消选中其他所有站点按钮
    $('.site_checkbox').prop("checked", false);
    $('.all_sites').prop("checked", true);
  }else if($('.site_checkbox:checked').length>1){  //  有任意一个被点选，则不点选全部按钮，如果取消了所有点选
    $('.all_sites').prop("checked", false);
  }else if($('.site_checkbox:checked').length==0){  // 如果取消了所有点选，则默认选中全部按钮
    $('.all_sites').prop("checked", true);
  }
}

function supplierCheckbox(e) {
  if(e.currentTarget.value=='0'){  // 如果点选了"全部"按钮，则取消选中其他所有站点按钮
    $('.supplier_checkbox').prop("checked", false);
    $('.all_suppliers').prop("checked", true);
  }else if($('.supplier_checkbox:checked').length>1){  //  有任意一个被点选，则不点选全部按钮，如果取消了所有点选
    $('.all_suppliers').prop("checked", false);
  }else if($('.supplier_checkbox:checked').length==0){  // 如果取消了所有点选，则默认选中全部按钮
    $('.all_suppliers').prop("checked", true);
  }
}

function displayModelCheckbox(e){ 
  if(e.currentTarget.value=='0'){  // 如果点选了"全部"按钮，则取消选中其他所有站点按钮
    $('.display_model_checkbox').prop("checked", false);
    $('.all_display_model').prop("checked", true);
  }else if($('.display_model_checkbox:checked').length>1){  //  有任意一个被点选，则不点选全部按钮，如果取消了所有点选
    $('.all_display_model').prop("checked", false);
    $('.display_model_checkbox').prop("checked", false);
    $(e.target).prop("checked", true);
  }else if($('.display_model_checkbox:checked').length==0){  // 如果取消了所有点选，则默认选中全部按钮
    $('.all_display_model').prop("checked", true);
  }
}

function stateCheckbox(e) {
  if(e.currentTarget.value=='all'){  // 如果点选了"全部"按钮，则取消选中其他所有站点按钮
    $('.state_checkbox').prop("checked", false);
    $('.all_states').prop("checked", true);
  }else if($('.state_checkbox:checked').length>1){  //  有任意一个被点选，则不点选全部按钮，如果取消了所有点选
    $('.all_states').prop("checked", false);
  }else if($('.state_checkbox:checked').length==0){  // 如果取消了所有点选，则默认选中全部按钮
    $('.all_states').prop("checked", true);
  }
}

function updateDateRangeValue(){
  var rangeBegin = $("#range-begin").val();
  var rangeEnd = $("#range-end").val();
  $("input#range_date_range").val(rangeBegin+">"+rangeEnd);
  $("input#range_date_range").prop("checked", true);
}
