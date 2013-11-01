function searchRevisions(url){
	var generateData = {'send_email': false};
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
			myNotification ="Something horrible happened, like an exception!";
		}
		else {
			mySubject = data[1] + " Revions Found";
			if (data[0]){
				myNotification = "New data was found";
			}
			else {
				myNotification = "No new data was found";
			}
		}
		var notification = window.webkitNotifications.createNotification('http://www.patientkeeper.com/images/patientkeeper.gif',mySubject,myNotification);
		notification.show();
		setTimeout(function(){
			notification.cancel();
		}, 4000);
	}
}

function createHeatGraph(heat_data){
	$(function () {
    $('#commits_by_time_of_day_chart').highcharts({

	    chart: {
	        type: 'bubble',
	        zoomType: 'xy'
	    },
	    plotOptions : {
            bubble : {
                tooltip : {
                    headerFormat: '<b>{series.name}</b><br>',
                    pointFormat : '{point.z} commits during the {point.category} hour'
                    
                }
            }
        },
	    title: {
	    	text: 'Heat Graph'
	    },	    
	    xAxis: {
	    	categories: ['12am','1am','2am','3am','4am','5am','6am','7am','8am','9am','10am','11am','12pm','1pm','2pm','3pm','4pm','5pm','6pm','7pm','8pm','9pm','10pm','11pm'],
	    	title: {
	    		text: 'Hour of the Day'	
	    	}
	    },	    
	    yAxis: {
	    	categories: ['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'],
	    	title: {
	    		text: 'Day of the Week'	
	    	}
	    },	    
	    series: [
	        {
	        	data: heat_data[0],
	        	name: "Sunday"
	        },
	        {
	        	data: heat_data[1],
	        	name: "Monday"
	        },
	        {
	        	data: heat_data[2],
	        	name: "Tuesday"
	        },
	        {
	        	data: heat_data[3],
	        	name: "Wednesday"
	        },
	        {
	        	data: heat_data[4],
	        	name: "Thursday"
	        },
	        {
	        	data: heat_data[5],
	        	name: "Friday"
	        },
	        {
	        	data: heat_data[6],
	        	name: "Saturday"
	    	}]
	
	});
    
});
}
