// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require fronted/jquery.min.js
//= require twitter/bootstrap
//= require turbolinks
//= require jquery.ui.autocomplete
//= require jquery.infinitescroll
//= require socket.io
//= require wice_grid
//= require jquery.ui.datepicker
//= require_tree .

//$(document).ready(function(){
//    var obtn=$("#btn-top");
//    var clientheight = document.documentElement.clientHeight;
//    var isTop = true;
//    var timer;
//
//    window.onscroll = function() {
//        var osTop=document.documentElement.scrollTop || document.body.scrollTop;
//        if(osTop >= clientheight) {
//            obtn.css("display","block");
//        }else
//        {
//            obtn.css("display","none");}
//        if(!isTop) {
//            clearInterval(timer);
//        }
//        isTop = false;
//    }
//
//
//    obtn.click(function(){
//        timer=setInterval(function() {
//                var osTop=document.documentElement.scrollTop || document.body.scrollTop;
//                isTop = true;
//                var ispeed = Math.floor(osTop / 6);
//                document.documentElement.scrollTop = document.body.scrollTop = osTop - ispeed;
//                if(osTop == 0)
//                { clearInterval(timer);
//                }
//            },
//            30
//        );
//    });
//});

//(function () {
//    var obtn=document.getElementById('btn-top');
//    var clientheight = document.documentElement.clientHeight;
//    var isTop = true;
//    var timer;
//
//    window.onscroll = function() {
//        var osTop=document.documentElement.scrollTop || document.body.scrollTop;
//        if(osTop >= clientheight) {
//            obtn.style.display = 'block';
//        }else
//        {
//            obtn.style.display = 'none';}
//        if(!isTop) {
//            clearInterval(timer);
//        }
//        isTop = false;
//    }
//
//    obtn.onclick = function() {
//        timer=setInterval(function() {
//                var osTop=document.documentElement.scrollTop || document.body.scrollTop;
//                isTop = true;
//                var ispeed = Math.floor(osTop / 6);
//                document.documentElement.scrollTop = document.body.scrollTop = osTop - ispeed;
//                if(osTop == 0)
//                { clearInterval(timer);
//                }
//            },
//            30
//        );
//    }
//}).call(this);