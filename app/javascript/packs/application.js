// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import "jquery"

import "js/bootstrap/dist/js/bootstrap.bundle.min"
import 'js/@shopify/draggable/lib/es5/draggable.bundle.legacy'
import 'js/autosize/dist/autosize.min'
import 'js/flatpickr/dist/flatpickr.min'
import 'js/highlightjs/styles/highlight.pack.min'
import 'js/jquery-mask-plugin/dist/jquery.mask.min'
import 'js/list.js/dist/list.min'
import 'js/quill/dist/quill.min'
import 'js/select2/dist/js/select2.full.min'
import 'js/chart.js/dist/f2'
import 'js/dashkit.min'
import 'js/theme.min.js'

import 'styles/application.css'
import 'styles/feather.css'
import 'styles/order_list.css'
import 'js/flatpickr/dist/flatpickr.min.css'
import 'js/quill/dist/quill.core.css'
import 'js/highlightjs/styles/vs2015.css'
import 'packs/upload.js'
// import 'packs/table.js'
import 'packs/choice.js'


Rails.start()
Turbolinks.start()
ActiveStorage.start()
window.$ = jQuery;