<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html">
<html>
<head>
	<meta charset="utf-8">
	<title>Twitter Map</title>
	<script src="javascript/jquery-1.9.1.js"></script>
	<script src="javascript/d3.js"></script>
	<script src="javascript/d3.layout.clouds.js"></script>
	<script type="text/javascript"
     src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDKrR0xXhe195HxqHjxaYdtKeg4dEB1-LI&v=3.exp&sensor=false&libraries=visualization">
     </script>
	 <link rel="stylesheet" href="./css/styles.css">
	 <link rel="stylesheet" href="./css/div_splitter.css">
	 
	<style type="text/css">
     html, body, #map-canvas { height: 100%; width=80%; margin: 0; padding: 0;}
   </style>
	<link rel="stylesheet" href="css/basic.css" type="text/css" media="screen" />
</head>
<body>
<div id='cssmenu'> 
<ul>

   <li class='active'><a href='#' onclick="start()"><span>(1) Display Live Tweets</span></a></li>
   <li><!-- <a href='#'> -->
 <span>
    <form id="updateUsername" name="updateUsername" method="POST" action="Tweet">
   (2) Display from DB : Keyword=
 <select id="keyword" name="filterByKeyword" >
				<option value="All" selected>No Filter</option>
				<option value="obama">Obama</option>
				<option value="hate">Hate</option>
				<option value="love">Love</option>
				<option value="ebola">Ebola</option>
				<option value="boy">Boy</option>
				<option value="nyc">New York</option>
				<option value="girl">Girl</option>
				<option value="suarez">Suarez</option>
				<option value="microsoft">Microsoft</option>
				<option value="india">India</option>
				<option value="columbia">Columbia</option>
				<option value="mumbai">Mumbai</option>
 </select>, Map Type
<select id="displayMode" name="displayMode">
				<option value="Heatmap" selected>Heatmap</option>
				<option value="Marker">Markers</option>
				<option value="Markers_Clustered">Markers_Clustered</option>
			</select>
			<input type="submit" value="Start Rendering"/>
</form>
</span>
<!-- </a>-->
</li>
   
   <li><a href='./aboutUs.html'><span>About Us</span></a></li>
   <li class='last'><a href='./techStack.html'><span>Technology Stack</span></a></li>
</ul>
</div>

<div id="wrapper">
    
    <div id="left">
   	<div id="map-canvas"></div>
    </div>
    
    <div class="right top">
        <div><%@include file="sideGauge.jsp" %></div>
    </div>
    
    <div class="right bot">
        <div>right bottom<br> more text in here</div>
    </div>
    <div id="wordCloud" style="float:left;border:solid 1px black">
	</div>
	<script>
		var fill = d3.scale.category20();
		var filters = ["Obama","Bieber","America","India","Modi","Columbia","Ebola","NYC","boy","girl","love","hate","cold","weather"].map(function(d) {
		    return {text: d, size: 5, count:0};
		});
		var updates = 0;
		
		  function updateCloud(filters){
			  console.log(filters);
			  d3.layout.cloud().size([300, 300])
		      .words(filters)
		      .padding(5)
		      .rotate(function() { return ~~(Math.random() * 2) * 90; })
		      .font("Impact")
		      .fontSize(function(d) { return d.size; })
		      .on("end", draw)
		      .start();
		  }
		  
		  function draw(filters) {
			  var svg;
			  $("#wordCloud").empty();
			  
			  if (d3.select("#wordCloud").selectAll("svg")[0][0] == undefined){
		          var svg = d3.select("#wordCloud").append("svg")
		                  .attr("width", 300)
		                  .attr("height", 300)
		                  .append("g")
		                  .attr("transform", "translate(200,200)");        
		      }else{
		    	  console.log("already found");
		    	  var svg =  d3.select("#wordCloud").selectAll("svg")
		              .attr("width", 300)
		              .attr("height", 300)
		              .select("g")
		              .attr("transform", "translate(200,200)");
		      }
			  
			    svg.selectAll("text")
			        .data(filters)
			      .enter().append("text")
			        .style("font-size", function(d) { return d.size + "px"; })
			        .style("font-family", "Impact")
			        .style("fill", function(d, i) { return fill(i); })
			        .attr("text-anchor", "middle")
			        .attr("transform", function(d) {
			          return "translate(" + [d.x, d.y] + ")rotate(" + d.rotate + ")";
			        })
			        .text(function(d) { return d.text; });
			  }
		  
		  function updateWords(){
			    $.ajax({
			    url: "Tweet",
			    type: "Post",
			    dataType: 'json',
			    data: {filterByKeyword:"All"},
			    success: function(data) {
			     var totalCount = 0;
			     for(var i=0;i<Object.keys(data).length;i++){
			      for(var j = 0; j<filters.length; j++){
			       if(filters[j].text.toLowerCase() == data[i].keyword.toLowerCase()){
			        totalCount++;
			        filters[j].count++;
			        
			        for(var k = 0; k<filters.length; k++){
			         relativeCount = filters[k].count/totalCount;
			         console.log(filters[k].text.toLowerCase() + ":" + filters[k].count);
			         filters[k].size = (relativeCount * 40) + 10*filters[k].count;
			        }
			       }
			      }
			     }
			     updateCloud(filters);
			    }
			   });
			    
			    }
		  
		  //updateWords();
	</script>
   </div>
 
	<script type="text/javascript">
	
	 var g1,  g2, g3, g4;
	 
     window.onload = function(){
     
   	  g1 = new JustGage({
             id: "g1", 
             value: 0, 
             min: 0,
             max: 100,
             title: "Tweet Sentiments",
             label: "Positive Sentiment %",
   		  shadowOpacity: 1,
           shadowSize: 0,
           shadowVerticalOffset: 10   ,

   		levelColors: [
             "#00B800",
             "#00B800",
             "#00B800"
           ] 		
           });
 

     };
     
	//refreshPositiveSentimentsGauge();
	//update Graph
	function refreshPositiveSentimentsGauge(){
		//document.getElementById('g1').innerHTML = "Loading Please wait...";
		var eventSourceGauge = new EventSource("PositiveSentimentStats");
		eventSourceGauge.addEventListener('message', function(event) {
			var resp = event.data;
			//alert(resp);
			var respParts = resp.split('^^*^^');
			var positive = respParts[0];
			var total = respParts[1];
			var percentage = positive*100/total;
			g1.refresh(percentage);
		 
 
		});
	
	}
	
	    //Server Side Event Implementation of Live Streaming
		function start() {
			document.getElementById('map-canvas').innerHTML = "Loading Please wait...";
			var mapOptionsP = {
 				    center: { lat: 40.8088, lng: -73.95},
			         zoom: 4, 
			         mapTypeId: google.maps.MapTypeId.HYBRID
			};
			var map = new google.maps.Map(document.getElementById("map-canvas"), mapOptionsP);
			var allMarkers = [];
			var eventSource = new EventSource("Tweet");
			for (var i = 0; i < allMarkers.length; i++) {
				allMarkers[i].setMap(null);
			}
			for (var i = 0; i < filters.length; i++) {
				filters[i].size=0;
			}
			//updateCloud(filters);
			eventSource.addEventListener('message', function(event) {
				var resp = event.data;
				//alert(resp);
				var respParts = resp.split('^^*^^');
				var id = respParts[0];
				var screenName = respParts[1];
				var latitude = respParts[2];
				var longitude = respParts[3];
				var keyword = respParts[4];
				var sentiment = respParts[5];
				var time = respParts[6];
				var text = respParts[7];
				var positive = respParts[8];
				var total = respParts[9];
				var marker_pos = new google.maps.LatLng(latitude, longitude);
				marker = new google.maps.Marker({
				    position: marker_pos,
				    map: map,
				    title: text,
				    animation: google.maps.Animation.DROP
				});
				if(sentiment == "positive")
				  	marker.setIcon('http://maps.google.com/mapfiles/ms/icons/green-dot.png');
				else if(sentiment == "negative") {
				   	marker.setIcon('http://maps.google.com/mapfiles/ms/icons/red-dot.png');
				}
				else {
				   	marker.setIcon('http://maps.google.com/mapfiles/ms/icons/yellow-dot.png');
				}
				//var info_window = new google.maps.InfoWindow();
				marker.info = new google.maps.InfoWindow({
					  content: '<b>Sreen name:</b> ' + screenName + '<br>' +
					  		   '<b>Latitude:</b> ' + latitude + '<br>' +
					  		   '<b>Longitude:</b> ' + longitude + '<br>' +
					  		   '<b>Keyword:</b> ' + keyword + '<br>' +
					  		   '<b>Text:</b> ' + text + '<br>' +
					  		   '<b>Time:</b> ' + time + '<br>'
					});
				allMarkers.push(marker);
				google.maps.event.addListener(marker, 'click', function() {
				  	//info_window.setContent('<b>'+screenName + "</b>");
				   	//info_window.open(map, marker);
					marker.info.open(map, marker);
				});
				//var percentage =Number(positive*100/total).toPrecision(4) ;
				//g1.refresh(percentage);
				var totalCount = 0;
				for(var j = 0; j<filters.length; j++){     
				     if(keyword.toLowerCase() == filters[j].text.toLowerCase()){
				      totalCount++;
				      filters[j].count++; 
				      for(var k = 0; k<filters.length; k++){
				       relativeCount = filters[k].count/totalCount;
				       console.log(filters[k].text.toLowerCase() + ":" + filters[k].count);
				       filters[k].size = (relativeCount * 40) + 10*filters[k].count;
				      }
				      //updateCloud(filters);
				     }
				    }	 
			});
		}
		/*
		function pausecomp(millis)
		 {
		  var date = new Date();
		  var curDate = null;
		  do { curDate = new Date(); }
		  while(curDate-date < millis);
		}
		
	    //Ajax Implementation of Live Streaming
		var frm1 = $('#updateUsername1');
 		frm1.submit(
 		  function() {
 			document.getElementById('map-canvas').innerHTML = "";
 			var mapOptionsP = {
 					zoom: 4,
 				    center: { lat: 40.8088, lng: -73.95},
			         mapTypeId: google.maps.MapTypeId.HYBRID
			};
 			var map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions);
            for(var i=0; i<1000; i++) {
 			  //Start Ajax callback
			  $.ajax({
				url: frm.attr('action'),
				type: frm.attr('method'),
				data: $('#updateUsername1').serialize(),
				success: function(data) {
					var resp = event.data;
					var respParts = resp.split('^');
					var id = respParts[0];
					var screenName = respParts[1];
					var latitude = respParts[2];
					var longitude = respParts[3];
					var content = respParts[4];
					
					var info_window = new google.maps.InfoWindow();
				    var marker_pos = new google.maps.LatLng(latitude, longitude);
				    marker = new google.maps.Marker({
				        position: marker_pos,
				        map: map,
				        title:content
				    });
				    allMarkers.push(marker);
				    google.maps.event.addListener(marker, 'click', function() {
				    	info_window.setContent('<b>'+screenName + "</b>");
				      	info_window.open(map, marker);
				     });
				 }
			  });
			  return false;
			  //End Ajax Call back
			  pausecomp(1000);
            }
		});
 		*/
 		//For getting from Data base
		var frm = $('#updateUsername');
 		frm.submit(
 		  function() {
 			document.getElementById('map-canvas').innerHTML = "Loading Please wait...";
 			updateWords();
			$.ajax({
				url: frm.attr('action'),
				type: frm.attr('method'),
				dataType: 'json',
				data: $('#updateUsername').serialize(),
				success: function(data) {
					document.getElementById('map-canvas').innerHTML = "";
					var mapOptions = {
							zoom: 4,
		 				    center: { lat: 40.8088, lng: -73.95},
					        mapTypeId: google.maps.MapTypeId.HYBRID
					       };
					var displayMode = document.getElementById("displayMode").value;
					var map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions);
					//var info_window = new google.maps.InfoWindow();
				    var markers = [];
				    var infowindow = new google.maps.InfoWindow();
				    var size = 0, key;
				    
				    for (key in data) {
				        if (data.hasOwnProperty(key)) size++;
				    }
				    if(displayMode == "Heatmap") {
				    
				    	for(i = 0; i < size; i++) {
			
				        	var marker_pos = new google.maps.LatLng(data[i].latitude, data[i].longitude);
				        	markers.push(marker_pos);
				    	}
				    	var pointArray = new google.maps.MVCArray(markers);

				    	var heatmap = new google.maps.visualization.HeatmapLayer({
				      	data: pointArray
				    	});
				    	heatmap.setMap(map);
				    }
				    else {
				    	for(i = 0; i < size; i++) {
							
				        	var marker_pos = new google.maps.LatLng(data[i].latitude, data[i].longitude);
				     
				        	marker = new google.maps.Marker({
				            	position: marker_pos,
				            	map: map,
				            	title:data[i].content
				        	});
				        	
				        	if(data[i].sentiment == "positive")
							  	marker.setIcon('http://maps.google.com/mapfiles/ms/icons/green-dot.png');
							else if(data[i].sentiment == "negative") {
							   	marker.setIcon('http://maps.google.com/mapfiles/ms/icons/red-dot.png');
							}
							else {
							   	marker.setIcon('http://maps.google.com/mapfiles/ms/icons/yellow-dot.png');
							}
				        	
				        	if(displayMode == "Markers_Clustered") {	
				        	marker.info = new google.maps.InfoWindow({
								  content: '<b>Content :</b> ' + data[i].content + '<br>' +
								  			'<b>Latitude:</b> ' + data[i].latitude + '<br>' +
								  		   '<b>Longitude:</b> ' + data[i].longitude + '<br>'  
								  		   

								});
				        	markers.push(marker);
							google.maps.event.addListener(marker, 'click', function() {
							  	//info_window.setContent('<b>'+screenName + "</b>");
							   	//info_window.open(map, marker);
								marker.info.open(map, marker);
							});
				        	}else{
							marker.info = new google.maps.InfoWindow({
								  content: '<b>Sreen name:</b> ' + data[i].screenName + '<br>' +
								  		   '<b>Latitude:</b> ' + data[i].latitude + '<br>' +
								  		   '<b>Longitude:</b> ' + data[i].longitude + '<br>' +
								  		   '<b>Keyword:</b> ' + data[i].keyword + '<br>' +
								  		   '<b>Text:</b> ' + data[i].text + '<br>' +
								  		   '<b>Time:</b> ' + data[i].time + '<br>'
								});
							markers.push(marker);
							google.maps.event.addListener(marker, 'click', function() {
							  	//info_window.setContent('<b>'+screenName + "</b>");
							   	//info_window.open(map, marker);
								marker.info.open(map, marker);
							});
				        	}
				        	/*
			        		   google.maps.event.addListener(marker, 'click', (function (marker, i) {
			        		        return function () {
			        		        	var titleStr ='<b>Content :</b> ' + data[i].content + '<br>' +
							  			'<b>Latitude:</b> ' + data[i].latitude + '<br>' +
								  		   '<b>Longitude:</b> ' + data[i].longitude + '<br>';
			        		            infowindow.setContent(titleStr);
			        		            infowindow.open(map, marker);
			        		        }
			        		    })(marker, i));
				     	
				        
				           	markers.push(marker);*/
				    	}
				    }
				}
			});
			return false;
		});
 	</script>
</body>
</html>