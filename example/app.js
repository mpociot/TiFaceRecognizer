// This is a test harness for your module
// You should do something interesting in this harness 
// to test out the module and to provide instructions 
// to users on how to use it by example.


// open a single window
var win = Ti.UI.createWindow({
	backgroundColor:'white'
});
// TODO: write your module tests here
var TiFaceRecognizer = require('de.marcelpociot.facerecognizer');
Ti.API.info("module is => " + TiFaceRecognizer);

var imageView = Ti.UI.createImageView({
	top: 0,
	left: -150,
	width: 500,
	height: 400,
	image: 'faces.jpg'
});
win.add( imageView );

var analyzeButton = Ti.UI.createButton({
	layout: 'horizontal',
	bottom: 50,
	title: 'Analyze Faces'
});
analyzeButton.addEventListener('click',function(e)
{
	var result = TiFaceRecognizer.detectFaces({
		image: imageView.image
	});
	alert("Found "+result.faces.length+" faces");
	for( var i=0; i< result.faces.length; i++ )
	{
		var face 	 		= result.faces[i];		
		var facePosition 	= face.position;
		
		var faceView = Ti.UI.createView({
			top: 	 facePosition.y,
			left:	 facePosition.x,
			width:   facePosition.width,
			height:  facePosition.height,
			borderColor: 'white'
		});
		imageView.add( faceView );
		
		if( typeof( face.leftEye !== 'undefined' ) )
		{
			var leftEyeView = Ti.UI.createView({
				top:  imageView.height - face.leftEye.y,
				left: face.leftEye.x,
				width: 5,
				height: 5,
				borderColor: 'red'
			});
			imageView.add( leftEyeView );
		} 
		
		if( typeof( face.rightEye !== 'undefined' ) )
		{
			var rightEyeView = Ti.UI.createView({
				top:  imageView.height - face.rightEye.y,
				left: face.rightEye.x,
				width: 5,
				height: 5,
				borderColor: 'red'
			});
			imageView.add( rightEyeView );
		} 
		
		if( typeof( face.mouth !== 'undefined' ) )
		{
			var mouthView = Ti.UI.createView({
				top:  imageView.height - face.mouth.y,
				left: face.mouth.x,
				width: 5,
				height: 5,
				borderColor: 'red'
			});
			imageView.add( mouthView );
		} 
		
	}
	

});
win.add( analyzeButton );

win.open();