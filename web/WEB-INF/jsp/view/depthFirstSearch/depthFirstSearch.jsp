<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    												pageEncoding="UTF-8" %>
<!doctype html>

<html lang="en">
<head>
<meta charset="utf-8">
<title>Depth First Search</title>

<link rel="stylesheet"
              href="<c:url value="/resources/stylesheet/bfsDemo.css" />" />

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>


<script>

"use strict";

/*
Here I draw an oriented graph  
 */

 var Debugger = function() { };// create  object
	Debugger.log = function(message) {
  	try {
    	console.log(message);
  	} catch(exception) {
    	return;
  	}
}


function canvasSupport() {
  	return !!document.createElement('canvas').getContext;
} 

function canvasApp() {

 	function Vertex(name) {
    	this.mName = name;
    	this.mParent = null;
    	this.mD = null;
    	this.mF = null;
    	this.mColor = "black";    
  	}// Vertex

  	// Vertex augmentation
  	function DisplayVertex(name) {
    	Vertex.call(this, name);
  	}// DisplayVertex

  	DisplayVertex.prototype = new Vertex();
  	DisplayVertex.prototype.mRadius = 20;
  	DisplayVertex.prototype.xPos = 0;
  	DisplayVertex.prototype.yPos = 0;
  	DisplayVertex.prototype.yConnU = 0;
  	DisplayVertex.prototype.yConnB = 0;
  	DisplayVertex.prototype.xConnL = 0;
  	DisplayVertex.prototype.xConnR = 0;
  	// 4 connection points, bottom, up, left, right
  	DisplayVertex.prototype.mNx = 0;
  	DisplayVertex.prototype.mNy = 0;
 
  	DisplayVertex.prototype.updateGeometry = function() {  
    	this.yConnU = this.yPos - this.mRadius;
    	this.yConnB = this.yPos + this.mRadius;
    	this.xConnL = this.xPos - this.mRadius;
    	this.xConnR = this.xPos + this.mRadius;
  	};

  	function Graph(N) {// A Graph contains a vector of N vertices
    	this.mV = [];// all vertices
    	this.mAdj = [];// all vertices adjacent to a given vertex
    	this.init = function() {
      	for (var i = 0; i < N; i++) {
        	this.mAdj.push(new Array());
      	}
    	}; 
    	// array of arrays of arrays format [[v,v,v],[]...[]]
    	// v = vertex number 
    	this.init();
  	}// Graph


  	// get canvas context
  	if (!canvasSupport()) {
    	alert("canvas not supported");
    	return;
  	} else {
    	var theCanvas = document.getElementById("canvas");
    	var context = theCanvas.getContext("2d");
  	}// if

  	var sourcename;
  	
  	var graphReady = false;
  	
  	var classifiedEdges = [];
  
  	var xMin = 0;
  	var yMin = 0;
  	var xMax = theCanvas.width;
  	var yMax = theCanvas.height; 

  	var xPos = [50, 150, 250, 350, 450, 550, 650];
 
  	var yPos = [100, 200, 300, 400, 500];

  	var names = ["a", "b", "c", "d", "e", "f" ,"g"];
 
  	var delay = 1000;// for animation only

  	var N = 35;// number of vertices

  	var Nedges = 30;// number of edges

  	var graph = new Graph(N);// empty graph
  	var queue = [];// use push and shift for a queue
  	var results = [];// holds the search result collection

  	var animIndex;
  
  	var src = null;// source

  	function setTextStyle() {
    	context.fillStyle    = '#000000';
    	context.font         = '12px _sans';
  	}


  	function fillBackground() {
    	// draw background
    	context.fillStyle = '#ffffff';
    	context.fillRect(xMin, yMin, xMax, yMax);    
  	}

  	function drawVertex(vertex) {
    	context.beginPath();
    	context.strokeStyle = vertex.mColor;
    	context.lineWidth = 2;
    	context.arc(vertex.xPos, vertex.yPos, vertex.mRadius, (Math.PI/180)*0, (Math.PI/180)*360, true); // draw full circle
    	context.stroke();
    	context.closePath();
    	var roff = vertex.mRadius + 2;
    	var timestamp = "";
    	if (vertex.mD != null) {
    	    timestamp += vertex.mD + "/"; 
    	}
    	if (vertex.mF != null && vertex.mF != 0) {
    	    timestamp += vertex.mF; 
    	}
        context.fillText(vertex.mName, vertex.xPos, vertex.yPos);    
        context.fillText(timestamp, vertex.xPos + roff, vertex.yPos - roff);
	}


    function drawArrow(a, b, edgeType) {// a and b points 
    	
      	var xa = a[0];
      	var ya = a[1];
      	var xb = b[0];
      	var yb = b[1];
       
      	// main line
      	context.beginPath();
      	context.moveTo(xa, ya);
      	context.lineTo(xb, yb);
      	context.stroke();
      	context.closePath();

      	// get unity vector from a to b
      	var dx = xa - xb;
      	var dy = ya - yb;

      	var l = Math.sqrt(dx * dx + dy * dy);
      	var u = [dx/l, dy/l];

      	var angle = (Math.PI / 180) * 15;

      	var a1x = Math.cos(angle) * u[0] - Math.sin(angle) * u[1];
      	var a1y = Math.sin(angle) * u[0] + Math.cos(angle) * u[1];
      	var a2x = Math.cos(angle) * u[0] + Math.sin(angle) * u[1];
      	var a2y = -Math.sin(angle) * u[0] + Math.cos(angle) * u[1];
      	var a1 = [xb + a1x*10, yb + a1y*10];
      	var a2 = [xb + a2x*10, yb + a2y*10];

      	context.beginPath();
      	context.moveTo(xb, yb);
      	context.lineTo(a1[0], a1[1]);
      	context.stroke();
      	context.moveTo(xb, yb);
      	context.lineTo(a2[0], a2[1]);
      	context.stroke();
      	context.closePath();   
      	
     	// get midpoint
     	var xm = (xa + xb) / 2;
     	var ym = (ya + yb) / 2;

     	context.textBaseline = "bottom";
     	context.textAlign = "right";

     	var type = "";
     	
     	if (edgeType != null && edgeType != "null") {
     		if (edgeType == "TREE") {type = "T";}
       		//if (edgeType == "CROSS") {type = "C";}
       		//if (edgeType == "BACKWARD") {type = "B";}
       		//if (edgeType == "FORWARD") {type = "F";}
     		context.fillText(type, xm, ym);   
    	}

     	context.textBaseline = "middle";
     	context.textAlign = "center"; 

    }// drawArrow

    
    function drawConnect(v1, v2, edgeType) { 
    	// v1 v2 are vertices but v2.mParent is an index so the condition is 
    	// v1 == graph.mV[v2.mParent]  
        if (v1 == graph.mV[v2.mParent]) {
          context.strokeStyle = "blue";
        } else {
          context.strokeStyle = "black";
        }
        context.lineWidth = 2;
        // discuss according to geometry
        var xa, ya, xb, yb;

        // respect direction: a always v1, b always v2
        if (v1.mNx == v2.mNx) {
          xa = v1.xPos;
          xb = v1.xPos;
          if (v1.mNy < v2.mNy) {    
            ya = v1.yConnB;       
            yb = v2.yConnU;
          } else {
            ya = v1.yConnU;       
            yb = v2.yConnB;
          }
        } else if (v1.mNy == v2.mNy) {
          ya = v1.yPos;
          yb = v1.yPos; 
          if (v1.mNx < v2.mNx) {
            xa = v1.xConnR; 
            xb = v2.xConnL; 
          } else {
            xa = v1.xConnL;         
            xb = v2.xConnR; 
          }         
        } else {
          if (v1.mNx < v2.mNx) {
            xa = v1.xConnR;
            xb = v2.xConnL;
            ya = v1.yPos;
            yb = v2.yPos; 
          } else {
            xa = v1.xConnL;
            xb = v2.xConnR;
            ya = v1.yPos;
            yb = v2.yPos; 
          }      
        }

        drawArrow([xa, ya], [xb, yb], edgeType);
      
    }// drawConnect
    
   
 	var vertex;
 
 	function build() {
 
 		console.log("build begin");
 		
    	setTextStyle();

    	context.textBaseline = "middle";
    	context.textAlign = "center";

   		for (var i = 0; i < 5; i++) {
    		for (var j = 0; j < 7; j++) {
        		vertex = new DisplayVertex(names[j] + i);
        		vertex.mNx = j;
        		vertex.mNy = i;
        		vertex.xPos = xPos[j];
        		vertex.yPos = yPos[i];
        		vertex.updateGeometry();        
        		graph.mV.push(vertex);
        		drawVertex(vertex);         
    		}
  		}
  
    	randomize();
    	
    	console.log("build completed");
  
	}// build
	
	function drawEdge(edge) {
		var v1 = graph.mV[edge.from];
		var v2 = graph.mV[edge.to];
		var edgeType = edge.type;
		
		drawConnect(v1, v2, edgeType);
	}
	
	function redrawType() {
    	// only use mAdj for drawing connections
    	// clear canvas
    	fillBackground();

    	setTextStyle();

    	context.textBaseline = "middle";
    	context.textAlign = "center";

    	var N = graph.mV.length;

    	// draw all vertices
    	for (var i = 0; i < N; i++) {
      		drawVertex(graph.mV[i]);
    	}

    	for (var i = 0; i < classifiedEdges.length; i++) {// all edges
    		drawEdge(classifiedEdges[i]);
    	}
    
 	}// redrawType
 	


  	function initDraw() {
    	// only use mAdj for drawing connections
    	// clear canvas
    	fillBackground();

    	setTextStyle();

    	context.textBaseline = "middle";
    	context.textAlign = "center";

    	var N = graph.mV.length;

    	// draw all vertices
    	for (var i = 0; i < N; i++) {
      		drawVertex(graph.mV[i]);
    	}

    	// draw all connections
    	for (var i = 0; i < N; i++) {
      		var conn = graph.mAdj[i]; // all vertices connected to vertex i
      		for (var k = 0; k < conn.length; k++) {
      			//console.log("connect " + i + "," + conn[k])
        		drawConnect(graph.mV[i], graph.mV[conn[k]]);        
      		}
    	}
    
 	}// initDraw

  	function randomize() {

    	/* adding random edges, only Nedges (sparse)
       	allow connection only in cases below:
       mNx1 = mNx2, |mNy1 - mNy2| == 1
       mNy1 = mNy2, |mNx1 - mNx2| == 1
       |mNx1 - mNx2| == 1 and |mNy1 - mNy2| == 1   
    	*/
  
    	var edges = 0;
    	var count = 0;

    	var check = new Array(35);
    	for (var i = 0; i < 35; i++) {
      		check[i] = new Array(35);
    	}

    	for (var i = 0; i < 35; i++) {
      		for (var j = 0; j < 35; j++) {
        		check[i][j] = 0;
      		}
    	}

    	var index1, index2;

    	// reset all vertices
    	for (var i = 0; i < graph.mV.length; i++) {
      		graph.mV[i].mColor = "black";
      		graph.mV[i].mParent = null;
      		graph.mV[i].mD = null;
      		graph.mV[i].mF = null;
    	}

    	// remove all existing edges
    	for (var i = 0; i < graph.mAdj.length; i++) {
      		graph.mAdj[i] = [];
    	}

    	while (edges < Nedges) {
      		// select 2 random indexes
      		index1 = Math.floor(Math.random() * 35);// range
      		index2 = index1;
      		while (index2 == index1) {
        		index2 = Math.floor(Math.random() * 35);// range
      		}
      		var nX1 = graph.mV[index1].mNx;
      		var nY1 = graph.mV[index1].mNy;
      		var nX2 = graph.mV[index2].mNx;
      		var nY2 = graph.mV[index2].mNy;
      		if ((Math.abs(nX1-nX2) <= 1) && (Math.abs(nY1-nY2) <= 1) ) {// allow edge           
        		if (check[index1][index2] == 0) {// oriented graph
          			graph.mAdj[index1].push(index2);
          			check[index1][index2] = 1;
          			edges++;      
        		}        
      		}
    	}// while
    	 	
    	var disp;
    
 		initDraw();// draw graph before search
 
		$('#initForm').find(':submit')[0].disabled = false;
    	
		$('#status').text('Ready to search');
 	}// randomize

  	function animSpeedChanged(e) {
	  	console.log("animSpeedChanged");
    	delay = 1e4 / e.target.value;
  	}
     
	build();
  
	var message;
  
  	var edgeArray = [];
  	var vertexArray = [];
  
  	var count = 0;
  	var edges;
  	var vertices;
		
  	for (var j = 0; j < 35; j++) {// for each vertex
		vertexArray.push({"name":graph.mV[j].mName});
		for (var i = 0; i < graph.mAdj[j].length; i++) {// for each adjacent vertex		
			edgeArray.push({"from":j, "to":graph.mAdj[j][i]});
		}// i
  	}// j

  	function initStep() {
	  	
	  	$('#stepForm').find(':submit')[0].disabled = false;
	  
	  	
	  	console.log("initStep begin");
	  
	  	var message;
	  
	  	var edgeArray = [];
	  	var vertexArray = [];
	  
	  	var count = 0;
	  	var edges;
	  	var vertices;
			
	 	for (var j = 0; j < 35; j++) {// for each vertex
			vertexArray.push({"name":graph.mV[j].mName});
			for (var i = 0; i < graph.mAdj[j].length; i++) {// for each adjacent vertex		
				edgeArray.push({"from":j, "to":graph.mAdj[j][i]});
			}// i
	  	}// j
	  	
	  		  
	  	edges = {"jsonEdges":edgeArray};
	  	vertices = {"jsonVertices":vertexArray};
	   
	  	message = {"jsonEdges":edgeArray, "jsonVertices":vertexArray};
	  
	  	$.ajax({
			type : "POST",
			contentType : "application/json",
			url : '<c:url value="/initGraph" />',
			data : JSON.stringify(message),
			dataType : 'json',
			timeout : 100000,
			success : function(data) {
				console.log("SUCCESS");
			},
			
			error : function(e) {
				console.log("ERROR: ", e);
			},
			done : function(e) {
				console.log("DONE");
			}
		});
	   
	  	console.log("initStep completed");
  	}
  
  	function searchStep(graph) {// change this name in the final version
	  	
  	  	message = {"type":"STEP"};// minimal message
  	  
	  	$.ajax({
			type : "POST",
			contentType : "application/json",
			url : '<c:url value="/searchStep" />',
			data : JSON.stringify(message),
			dataType : 'json',
			timeout : 100000,
			success : function(data) {
				console.log("SUCCESS");
					
				if (data["status"] == "STEP" || data["status"] == "FINISHED") {
					// data is a StepResult container so we extract the graph attribute
					var stepVertices = data["graph"]["vertices"];
					for (var i = 0; i < stepVertices.length; i++) {
						graph.mV[i].mColor = stepVertices[i].color;// update graph
						graph.mV[i].mD = stepVertices[i].d;
						graph.mV[i].mF = stepVertices[i].f;
						graph.mV[i].mParent = stepVertices[i].parent;// vertex index, not vertex
					}
					
					var responseEdges = data["graph"]["edges"];
					
					classifiedEdges = [];
					
					// update edges
					for (var i1 = 0; i1 < N; i1++) {
						for (var i2 = 0; i2 < N; i2++) {
							if (responseEdges[i1][i2] != null) {
								//console.log(responseEdges[i1][i2]);
								classifiedEdges.push(responseEdges[i1][i2]);
							}
						}
					}
					
					console.log("classifiedEdges: " + classifiedEdges.length);
					
					redrawType();
					
					$('#status').text('Searching...');
				}
				
				if (data["status"] == "FINISHED") {
					redrawType();// last state
					$('#initForm').find(':submit')[0].disabled = true;
					console.log("Search completed");
					$('#status').text('Search completed');
					$('#stepForm').find(':submit')[0].disabled = true;
				}
			},
			
			error : function(e) {
				console.log("ERROR: ", e);
			},
			done : function(e) {
				console.log("DONE");
			}
		});
	  
  	}
 
  	$("#initelem").submit(function(event) { randomize(graph, Nedges); return false; }); 
  	$("#animspeed").change(function(event) { animSpeedChanged(event); return false; });
  	$('#initelem').find(':submit')[0].disabled = false;
  	$('#stepForm').find(':submit')[0].disabled = true;
  
  	$("#stepForm").submit(function(event) { searchStep(graph); return false; });
  	$("#initForm").submit(function(event) { initStep(graph); return false; });
}// canvasApp

$(document).ready(canvasApp);


</script>
</head>

<body>

<nav>
<br>
<br><br>
</nav>

<header id="intro">
<h1>Depth First Search Demonstration</h1>
<p>I present here a Java based demonstration of the Depth First Search algorithm.<br>
I follow closely the approach of Cormen in his classical textbook.</p>
<h2>Explanations</h2>
<p>The graph edges are randomly initialized. 
The search always start from the same vertex named a0.<br/>
On each step a new Ajax request is sent to the server that sends a response that is used to update the graph.<br/>
All newly discovered vertices are colored in green.<br/> 
When the search is completed all vertices are blue and the edges that connect a vertex to a parent are blue.<br/> 
The values of d and f are displayd as d/f.<br>
An edged that belongs to a tree is marked as T<br/>
The animation speed can be changed at any time using the range control.</p>
</header>

<div id="display">
  <canvas id="canvas" width="700" height="600">
    Your browser does not support HTML 5 Canvas
  </canvas>
<footer>
<p>Dominique Ubersfeld, Cachan, France</p>
</footer> 
 
</div>

<div id="controls">
  <div id="stepwise">
  <h3>Stepwise mode</h3>
   	<form name="stepForm" id="stepForm">
        Click to step:
        <input type="submit" name="step-btn" value="Step">
    </form>
    <form name="initForm" id="initForm">
        Click to initialize the graph:
        <input type="submit" name="step-btn" value="Init">
    </form>
  </div>

  <div id="randomize">
      <p>Click here to randomize the graph edges</p>
      <form name="initialize" id="initelem">
        <input type="submit" name="randomize-btn" value="Randomize">
      </form>
  </div>

  <div id="animspeed">
      <label for="animSpeed">Animation speed</label>
      <input type="range" id="animSpeed" min="5" max="100" step="5" value="20">
  </div>
  <div id="msg">
    <p id="status"></p>
  </div> 

</div>

</body>

</html>