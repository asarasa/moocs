/* Drag and drop from: http://www.html5rocks.com/es/tutorials/dnd/basics/ */

//Using this polyfill for safety.
Element.prototype.hasClassName = function(name) {
  return new RegExp("(?:^|\\s+)" + name + "(?:\\s+|$)").test(this.className);
};

Element.prototype.addClassName = function(name) {
  if (!this.hasClassName(name)) {
    this.className = this.className ? [this.className, name].join(' ') : name;
  }
};

Element.prototype.removeClassName = function(name) {
  if (this.hasClassName(name)) {
    var c = this.className;
    this.className = c.replace(new RegExp("(?:^|\\s+)" + name + "(?:\\s+|$)", "g"), "");
  }
};

// // Full example
// (function() {
//   var id_active = 'inactive';
//   var id_inactive = 'active';
//   var cols_active = document.querySelectorAll('#' + id_active + ' .list-group-item');
//   var cols_inactive = document.querySelectorAll('#' + id_inactive + ' .list-group-item');
//   var drop_active = document.querySelector('#drop-active');
//   var drop_inactive = document.querySelector('#drop-inactive');
//   var dragSrcEl_ = null;
//   var xmlhttp = new XMLHttpRequest();
//   var url = null;

//   this.handleDragStart = function(e) {
//     e.dataTransfer.effectAllowed = 'move';
//     e.dataTransfer.setData('text/html', this.innerHTML);

//     dragSrcEl_ = this;

//     // this/e.target is the source node.
//     this.addClassName('moving');
//   };

//   this.handleDragOver = function(e) {
//     if (e.preventDefault) {
//       e.preventDefault(); // Allows us to drop.
//     }

//     e.dataTransfer.dropEffect = 'move';

//     return false;
//   };

//   this.handleDragEnter = function(e) {
//     this.addClassName('over');
//   };

//   this.handleDragLeave = function(e) {
//     // this/e.target is previous target element.
//     this.removeClassName('over');
//   };

//   this.handleDrop = function(e) {
//     // this/e.target is current target element.

//     if (e.stopPropagation) {
//       e.stopPropagation(); // stops the browser from redirecting.
//     }

//     if (this.id == "drop-active") {
//       var url = this.innerHTML.substr(20, 108);
//       url = url.replace("view_resource","use_resource");    
//       console.log("drop-active");
//       console.log(url);
//       xmlhttp.open("GET",url);
//       xmlhttp.send();
//     } else {
//       var url = this.innerHTML.substr(20, 108);
//       url = url.replace("view_resource","delete_resource");    
//       console.log("drop-inactive");
//       console.log(url);
//       xmlhttp.open("GET",url);
//       xmlhttp.send();
//     }

//     // Don't do anything if we're dropping on the same column we're dragging.
//     if (dragSrcEl_ != this) {
//       dragSrcEl_.innerHTML = this.innerHTML;
//       this.innerHTML = e.dataTransfer.getData('text/html');
//     }

//     return false;
//   };

//   this.handleDragEnd = function(e) {
//     // this/e.target is the source node.
//     [].forEach.call(cols_active, function (col) {
//       col.removeClassName('over');
//       col.removeClassName('moving');
//     });

//     [].forEach.call(cols_inactive, function (col) {
//       col.removeClassName('over');
//       col.removeClassName('moving');
//     });    
//   };

//   xmlhttp.onreadystatechange=function() {
//     if (xmlhttp.readyState==4 && xmlhttp.status==200) {
//       console.log(xmlhttp.responseText);
//       document.getElementById("notice").innerHTML="OK";
//     } else {
//       document.getElementById("notice").innerHTML="Error";
//     }
//   }

//   drop_active.addEventListener('drop', this.handleDrop, false);
//   drop_active.addEventListener('dragend', this.handleDragEnd, false);
//   drop_active.addEventListener('dragover', this.handleDragOver, false);

//   drop_inactive.addEventListener('drop', this.handleDrop, false);
//   drop_inactive.addEventListener('dragend', this.handleDragEnd, false);
//   drop_inactive.addEventListener('dragover', this.handleDragOver, false);


//   [].forEach.call(cols_active, function (col) {
//     col.setAttribute('draggable', 'true');  // Enable columns to be draggable.
//     col.addEventListener('dragstart', this.handleDragStart, false);
//     col.addEventListener('dragenter', this.handleDragEnter, false);
//     col.addEventListener('dragover', this.handleDragOver, false);
//     col.addEventListener('dragleave', this.handleDragLeave, false);
//     col.addEventListener('drop', this.handleDrop, false);
//     col.addEventListener('dragend', this.handleDragEnd, false);
//   });

//   [].forEach.call(cols_inactive, function (col) {
//     col.setAttribute('draggable', 'true');  // Enable columns to be draggable.
//     col.addEventListener('dragstart', this.handleDragStart, false);
//     col.addEventListener('dragenter', this.handleDragEnter, false);
//     col.addEventListener('dragover', this.handleDragOver, false);
//     col.addEventListener('dragleave', this.handleDragLeave, false);
//     col.addEventListener('drop', this.handleDrop, false);
//     col.addEventListener('dragend', this.handleDragEnd, false);
//   });  
// })();