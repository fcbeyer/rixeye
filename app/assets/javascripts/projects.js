function searchRevisions(url){
	var generateData = {'send_email': false}
	$.ajax({
	 url: url,
	 data: generateData,
	 success: searchRevisionsComplete
    });
}

function searchRevisionsComplete(data){
	//send html5 notifications
	//haveNewSuiteData, directoryDoesNotExist, display_name
	if (window.webkitNotifications.checkPermission() == 0) {
		var myNotification;
		var mySubject;
		if (data[2]){
			//directory or JSON files were missing
			mySubject = data[1] + " DATA ALERT";
			myNotification ="Something horrible happened, like an exception!"
		}
		else {
			mySubject = data[1] + " Revions Found";
			if (data[0]){
				myNotification = "New data was found"
			}
			else {
				myNotification = "No new data was found"
			}
		}
		var notification = window.webkitNotifications.createNotification('http://www.patientkeeper.com/images/patientkeeper.gif',mySubject,myNotification);
		notification.show();
		setTimeout(function(){
			notification.cancel();
		}, 5000);
	}
}
