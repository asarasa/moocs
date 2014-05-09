$('#datetimepicker_start').datetimepicker({
	format: 'DD/MM/YYYY HH:mm',
});
$('#datetimepicker_end').datetimepicker({
	format: 'DD/MM/YYYY HH:mm',
});
$('#datetimepicker_end').datetimepicker();
$("#datetimepicker_start").on("change.dp",function (e) {
   $('#datetimepicker_end').data("DateTimePicker").setStartDate(e.date);
});
$("#datetimepicker_end").on("change.dp",function (e) {
   $('#datetimepicker_start').data("DateTimePicker").setEndDate(e.date);
});
