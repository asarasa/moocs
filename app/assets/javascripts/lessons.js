function sendPOST(xmlhttp, url, params) {
  xmlhttp.open("POST",url);

	//Send the proper header information along with the request
	xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
	xmlhttp.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
	
	xmlhttp.send(params);      	 
}

function change_state(element, lesson_id, lecture_id, course_id) {
	var xmlhttp = new XMLHttpRequest();
	var url = "/en/courses/" + course_id + "/lectures/" + lecture_id + "/change_state";
	var params = "id=" + lesson_id;
  
	sendPOST(xmlhttp, url, params);

  xmlhttp.onreadystatechange=function() {
    if (xmlhttp.readyState==4 && xmlhttp.status==200) {
    	$(".alert").innerHTML="OK";
			if (element.id == "lesson_active") {
				element.className = "glyphicon glyphicon-eye-close";
				element.id = "lesson_inactive";
			}
			else {
				element.className = "glyphicon glyphicon-eye-open";
				element.id = "lesson_active";
			}
    } else {
      $(".alert").appendChild="Error";
    }
  };		
}

$("span[data-lesson-id]").click (function( e ) {
  e.preventDefault();

  lesson_id = $(this).data("lesson-id");
  lecture_id = $(this).data("lecture-id");
  course_id = $(this).data("course-id");
  change_state(this, lesson_id, lecture_id, course_id);
});

/* Order */

(function() {
  var id_lessons = 'lessons';
  var cols_lessons = document.querySelectorAll('#' + id_lessons + ' .list-group-item');
  var dragSrcEl_ = null;
  var xmlhttp = new XMLHttpRequest();
  var url = null;

  this.handleDragStart = function(e) {
    e.dataTransfer.effectAllowed = 'move';
    e.dataTransfer.setData('text/html', this.innerHTML);

    var course_id = $(this).data("course-id");
		var lecture_id = $(this).data("lecture-id");

		url = "/en/courses/" + course_id + "/lectures/" + lecture_id + "/change_order";
    dragSrcEl_ = this;

    // this/e.target is the source node.
    this.addClassName('moving');
  };

  this.handleDragOver = function(e) {
    if (e.preventDefault) {
      e.preventDefault(); // Allows us to drop.
    }

    e.dataTransfer.dropEffect = 'move';

    return false;
  };

  this.handleDragEnter = function(e) {
    this.addClassName('over');
  };

  this.handleDragLeave = function(e) {
    // this/e.target is previous target element.
    this.removeClassName('over');
  };

  this.handleDrop = function(e) {
    // this/e.target is current target element.

    if (e.stopPropagation) {
      e.stopPropagation(); // stops the browser from redirecting.
    }

    if (dragSrcEl_ != this) {
    	dragSrcEl_.innerHTML = this.innerHTML;
      this.innerHTML = e.dataTransfer.getData('text/html');
      var params = "id1=" + dragSrcEl_.id + "&id2=" + this.id;
     	var temp = this.id;
     	this.id = dragSrcEl_.id;
     	dragSrcEl_.id = temp;

     	sendPOST(xmlhttp, url, params);
    };

    return false;
  };

  this.handleDragEnd = function(e) {
    // this/e.target is the source node.
    [].forEach.call(cols_lessons, function (col) {
      col.removeClassName('over');
      col.removeClassName('moving');
    });
  };

  xmlhttp.onreadystatechange=function() {
    if (xmlhttp.readyState==4 && xmlhttp.status==200) {
      console.log(xmlhttp.responseText);
      document.getElementById("notice").innerHTML="OK";
    } else {
      document.getElementById("notice").innerHTML="Error";
    }
  };

  [].forEach.call(cols_lessons, function (col) {
    col.setAttribute('draggable', 'true');  // Enable columns to be draggable.
    col.addEventListener('dragstart', this.handleDragStart, false);
    col.addEventListener('dragenter', this.handleDragEnter, false);
    col.addEventListener('dragover', this.handleDragOver, false);
    col.addEventListener('dragleave', this.handleDragLeave, false);
    col.addEventListener('drop', this.handleDrop, false);
    col.addEventListener('dragend', this.handleDragEnd, false);
  });

})();

function changetext(id)
{
  var selected = document.querySelector('#selected_resources');
  var checked = $( "input:checked" );
  var resources = "";
  for (var i = 0; i < checked.length; i++) {
    resources += checked.parent().parent().parent()[i].outerHTML
  }
  resources = resources.replace(new RegExp("input", 'g'), "del");
  console.log(resources);

  selected.innerHTML = resources;
}
