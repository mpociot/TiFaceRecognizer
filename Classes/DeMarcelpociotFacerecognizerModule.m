/**
 * Your Copyright Here
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "DeMarcelpociotFacerecognizerModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"
#import "TiRect.h"
#import "TiPoint.h"
#import "Imageloader.h"

@implementation DeMarcelpociotFacerecognizerModule

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"6538b307-5c7b-49cc-964c-91922c3a7b1b";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"de.marcelpociot.facerecognizer";
}

#pragma mark Lifecycle

-(void)startup
{
	// this method is called when the module is first loaded
	// you *must* call the superclass
	[super startup];
	
	NSLog(@"[INFO] %@ loaded",self);
}

-(void)shutdown:(id)sender
{
	// this method is called when the module is being unloaded
	// typically this is during shutdown. make sure you don't do too
	// much processing here or the app will be quit forceably
	
	// you *must* call the superclass
	[super shutdown:sender];
}

#pragma mark Cleanup 

-(void)dealloc
{
	// release any resources that have been retained by the module
	[super dealloc];
}

#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	// optionally release any resources that can be dynamically
	// reloaded once memory is available - such as caches
	[super didReceiveMemoryWarning:notification];
}

#pragma mark Listener Notifications

-(void)_listenerAdded:(NSString *)type count:(int)count
{
	if (count == 1 && [type isEqualToString:@"my_event"])
	{
		// the first (of potentially many) listener is being added 
		// for event named 'my_event'
	}
}

-(void)_listenerRemoved:(NSString *)type count:(int)count
{
	if (count == 0 && [type isEqualToString:@"my_event"])
	{
		// the last listener called for event named 'my_event' has
		// been removed, we can optionally clean up any resources
		// since no body is listening at this point for that event
	}
}

#pragma Public APIs

-(NSDictionary *)detectFaces:(id)args
{
    ENSURE_SINGLE_ARG(args, NSDictionary);
    
    UIImage* image          = [TiUtils toImage:[args objectForKey:@"image"] proxy:self];
    CIImage *detectionImage = [CIImage imageWithCGImage:image.CGImage];
    // Create detector
    CIDetector* detector    = [CIDetector detectorOfType:CIDetectorTypeFace
                                                 context:nil
                                                 options:[NSDictionary
                                                          dictionaryWithObject:CIDetectorAccuracyHigh
                                                          forKey:CIDetectorAccuracy]];
    
    NSArray *features       = [detector featuresInImage:detectionImage];
    
    NSMutableArray *faces   = [[NSMutableArray alloc] init];
    
    // Iterate over face features
    for( CIFaceFeature* faceFeature in features )
    {
        TiRect *faceRect        = [[[TiRect alloc] init] autorelease];
        [faceRect setRect:faceFeature.bounds];
        
        NSMutableDictionary *face = [[NSMutableDictionary alloc] init];
        [face setObject:faceRect forKey:@"position"];
        
        if( faceFeature.hasLeftEyePosition )
        {
            TiPoint *leftEye = [[TiPoint alloc] initWithPoint: faceFeature.leftEyePosition ];
            [face setObject:leftEye forKey:@"leftEye"];
        }
        
        if( faceFeature.hasRightEyePosition )
        {
            TiPoint *rightEye = [[TiPoint alloc] initWithPoint: faceFeature.rightEyePosition ];
            [face setObject:rightEye forKey:@"rightEye"];
        }
        
        if( faceFeature.hasMouthPosition )
        {
            TiPoint *mouth = [[TiPoint alloc] initWithPoint: faceFeature.mouthPosition ];
            [face setObject:mouth forKey:@"mouth"];
        }
        [faces addObject:face];
    }
    if( features.count > 0 )
    {
        NSDictionary *output    = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   @"true",@"status",
                                   faces,@"faces",
                                   nil];
    } else {
        NSDictionary *output    = [[NSDictionary alloc] initWithObjectsAndKeys:@"false",@"status", nil];
        return output;
    }
}

-(id)exampleProp
{
	// example property getter
	return @"hello world";
}

-(void)setExampleProp:(id)value
{
	// example property setter
}

@end
