/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2012 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiCameraView.h"
#import "TiCameraViewProxy.h"
#import "SCListener.h"
#import "TiUtils.h"
#import "TiViewProxy.h"


@interface  TiCameraView ()

@property (nonatomic, retain) UIView *cameraView;
@property (nonatomic, retain) UIImagePickerController *imagePicker;
@property (nonatomic, retain) UIImage *snap;




@end

@implementation TiCameraView

@synthesize cameraView, imagePicker, snap;

-(void)dealloc
{
    RELEASE_TO_NIL(self.cameraView);
    RELEASE_TO_NIL(self.imagePicker);
    [super dealloc];
}


-(void)commonPickerSetup:(NSDictionary*)args
{
    NSLog(@"MODULE commonPickerSetup!");
	if (args!=nil) {
		pickerSuccessCallback = [args objectForKey:@"success"];
		ENSURE_TYPE_OR_NIL(pickerSuccessCallback,KrollCallback);
		[pickerSuccessCallback retain];
	}
}

-(void)setCallbacks:(NSDictionary*)args
{
    NSLog(@"MODULE setCallbacks!");
	if (args!=nil)
	{
		[self commonPickerSetup:args];
    }
    ENSURE_UI_THREAD(setCallbacks,args);
    [imagePicker takePicture];
    
}
-(void)takePic:(id)args
{
    NSLog(@"MODULE takePic!");
    NSLog(@"MODULE takePic - IF cameraview not nil!");
    if (self.cameraView != nil) {
        NSLog(@"MODULE takePic - camera view exists!");
        
        if (imagePicker==nil)
        {
            [self throwException:@"invalid state" subreason:nil location:CODELOCATION];
        }
        NSLog(@"MODULE takePic - imagePicker is not noll!");
        ENSURE_UI_THREAD(takePic,args);
        NSLog(@"MODULE takePic - calling take picture!");
        [imagePicker takePicture];
        //        UIImagePickerController *picker = [self imagePicker];
        //        [picker takePicture]
        
    }
    NSLog(@"MODULE takePic - ENDIF cameraview not nil!");
    NSLog(@"MODULE takePic - RETURN!");
}


-(void)frameSizeChanged:(CGRect)frame bounds:(CGRect)bounds
{
    if (self.cameraView == nil) {
        
        self.imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.allowsEditing = NO;
        imagePicker.showsCameraControls = NO;
        [imagePicker setDelegate:self];
        
        self.cameraView = [[UIView alloc] initWithFrame: [self frame]];
        self.cameraView.clipsToBounds = YES;
        
        [self.cameraView addSubview:imagePicker.view];
        [self addSubview:self.cameraView];
    }
    
    [TiUtils setView:self.cameraView positionRect:bounds];

}

-(TiBlob*)asBlob:(id)args
{
    TiBlob *blob = [[[TiBlob alloc] init] autorelease];
    blob = [[[TiBlob alloc] initWithImage:snap] autorelease];
    return blob;
    
}



-(void)sendPickerSuccess:(id)event
{
    NSLog(@"MODULE sendPickerSuccess!");
	id listener = [[pickerSuccessCallback retain] autorelease];
	if (listener!=nil)
	{
		[NSThread detachNewThreadSelector:@selector(dispatchCallback:) toTarget:self withObject:[NSArray arrayWithObjects:@"success",event,listener,nil]];
	}
}

- (UIImage*)Snap:(id)args
{
    return snap;
}

- (UIImage*)getSnap:(id)args
{
    return snap;
}

- (TiBlob*)SnapAsBlob:(id)args
{
    TiBlob *blob = [[[TiBlob alloc] init] autorelease];
    blob = [[[TiBlob alloc] initWithImage:snap] autorelease];
    return blob;
}

- (TiBlob*)getSnapAsBlob:(id)args
{
    TiBlob *blob = [[[TiBlob alloc] init] autorelease];
    blob = [[[TiBlob alloc] initWithImage:snap] autorelease];
    return blob;
}

-(TiBlob*)snap_:(id)value
{
    TiBlob *blob = [[[TiBlob alloc] init] autorelease];
    blob = [[[TiBlob alloc] initWithImage:snap] autorelease];
    return blob;
}

-(TiBlob*)snip_:(id)value
{
    TiBlob *blob = [[[TiBlob alloc] init] autorelease];
    blob = [[[TiBlob alloc] initWithImage:snap] autorelease];
    return blob;
}



//Tells the delegate that the user cancelled the pick operation.
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"MODULE B imagePickerControllerDidCancel!");
    snap = nil;
}

//Tells the delegate that the user picked an image. (Deprecated in iOS 3.0. Use imagePickerController:didFinishPickingMediaWithInfo: instead.)
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingImage:(UIImage *)image
        editingInfo:(NSDictionary *)editingInfo
{
    NSLog(@"MODULE B imagePickerController / didFinishPickingImage!");
    snap = image;
    
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)editingInfo
{
    NSLog(@"MODULE B didFinishPickingMediaWithInfo!");
	
	NSURL *mediaURL = [editingInfo objectForKey:UIImagePickerControllerMediaURL];
	NSValue * ourRectValue = [editingInfo objectForKey:UIImagePickerControllerCropRect];
	
	NSDictionary *cropRect = nil;
	TiBlob *media = nil;
	TiBlob *thumbnail = nil;
    
	BOOL imageWrittenToAlbum = NO;
	
    UIImage *resultImage = nil;
    UIImage *originalImage = [editingInfo objectForKey:UIImagePickerControllerOriginalImage];
    
    if (resultImage == nil) {
        resultImage = originalImage;
    }
    NSLog(@"MODULE didFinishPickingMediaWithInfo! result image set");
    
    media = [[[TiBlob alloc] initWithImage:resultImage] autorelease];
    NSLog(@"MODULE didFinishPickingMediaWithInfo! media set");
    snap = resultImage;
    NSLog(@"MODULE didFinishPickingMediaWithInfo! snap set");
    
    
	if (ourRectValue != nil)
	{
		CGRect ourRect = [ourRectValue CGRectValue];
		cropRect = [NSDictionary dictionaryWithObjectsAndKeys:
                    [NSNumber numberWithFloat:ourRect.origin.x],@"x",
                    [NSNumber numberWithFloat:ourRect.origin.y],@"y",
                    [NSNumber numberWithFloat:ourRect.size.width],@"width",
                    [NSNumber numberWithFloat:ourRect.size.height],@"height",
                    nil];
	}
    
	NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       media,@"media",nil];
    //                                       mediaType,@"mediaType",media,@"media",nil];
    
	if (thumbnail!=nil)
	{
		[dictionary setObject:thumbnail forKey:@"thumbnail"];
	}
    
	if (cropRect != nil)
	{
		[dictionary setObject:cropRect forKey:@"cropRect"];
	}
    NSLog(@"MODULE didFinishPickingMediaWithInfo! firing snapped");
    if ([self.proxy _hasListeners:@"snapped"])
    {
//        NSDictionary *returnDate = [NSDictionary dictionaryWithObjectsAndKeys:date, @"date", nil];
//        NSDictionary *dateSelected = [NSDictionary dictionaryWithObjectsAndKeys: returnDate, @"event", nil];
        [self.proxy fireEvent:@"snapped" withObject:dictionary];
    }
	
    NSLog(@"MODULE didFinishPickingMediaWithInfo! calling sendPickerSuccess BEFORE");
	[self sendPickerSuccess:dictionary];
    NSLog(@"MODULE didFinishPickingMediaWithInfo! calling sendPickerSuccess AFTER");
}



-(TiBlob*)getBlob:(id)args
{
    NSLog(@"MODULE getBlob!");
    KrollCallback *callback = nil;
    BOOL honorScale = NO;
    
    NSObject *obj = nil;
    if( [args count] > 0) {
        obj = [args objectAtIndex:0];
        
        if (obj == [NSNull null]) {
            obj = nil;
        }
        
        if( [args count] > 1) {
            honorScale = [TiUtils boolValue:[args objectAtIndex:1] def:NO];
        }
    }
    callback = (KrollCallback*)obj;
	TiBlob *blob = [[[TiBlob alloc] init] autorelease];
	// we spin on the UI thread and have him convert and then add back to the blob
	// if you pass a callback function, we'll run the render asynchronously, if you
	// don't, we'll do it synchronously
	TiThreadPerformOnMainThread(^{
//		TiUIView *myview = [self imagePicker];
        UIImagePickerController *picker = [self imagePicker];
        UIView *myview = [self cameraView];
        
		CGSize size = myview.bounds.size;
		if (CGSizeEqualToSize(size, CGSizeZero) || size.width==0 || size.height==0)
		{
			CGFloat width = [self autoWidthForSize:CGSizeMake(1000,1000)];
			CGFloat height = [self autoHeightForSize:CGSizeMake(width,0)];
			if (width > 0 && height > 0)
			{
				size = CGSizeMake(width, height);
			}
			if (CGSizeEqualToSize(size, CGSizeZero) || width==0 || height == 0)
			{
				size = [UIScreen mainScreen].bounds.size;
			}
			CGRect rect = CGRectMake(0, 0, size.width, size.height);
			[TiUtils setView:myview positionRect:rect];
		}
		UIGraphicsBeginImageContextWithOptions(size, [myview.layer isOpaque], (honorScale ? 0.0 : 1.0));
        [picker.cameraOverlayView.layer renderInContext:UIGraphicsGetCurrentContext()];
//		[myview.layer renderInContext:UIGraphicsGetCurrentContext()];
		UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
		[blob setImage:image];
        [blob setMimeType:@"image/png" type:TiBlobTypeImage];
		UIGraphicsEndImageContext();
	}, (callback==nil));
	
	return blob;
}

@end
