
function change_visibility(element, testinlecture_id, lecture_id, course_id) {
	var xmlhttp = new XMLHttpRequest();
	var url = "/en/courses/" + course_id + "/lectures/" + lecture_id + "/change_visibility/";
	var params = "id=" + testinlecture_id;

  
	sendPOST(xmlhttp, url, params);

  xmlhttp.onreadystatechange=function() {
    if (xmlhttp.readyState==4 && xmlhttp.status==200) {
    	$(".alert").innerHTML="OK";
			if (element.id == "testinlecture_active") {
				element.className = "glyphicon glyphicon-eye-close";
				element.id = "testinlecture_inactive";
			}
			else {
				element.className = "glyphicon glyphicon-eye-open";
				element.id = "testinlecture_active";
			}
    } else {
      $(".alert").appendChild="Error";
    }
  };		
}

$("span[data-testinlecture-id]").click (function( e ) {
  e.preventDefault();
  testinlecture_id = $(this).data("testinlecture-id");
  lecture_id = $(this).data("lecture-id");
  course_id = $(this).data("course-id");
  change_visibility(this, testinlecture_id, lecture_id, course_id);
});
