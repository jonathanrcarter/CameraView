/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2012 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import "TiUIView.h"
#import "SCListener.h"
#import "KrollCallback.h"



@interface TiCameraView : TiUIView
<
    UINavigationControllerDelegate,
    UIImagePickerControllerDelegate
> {
    UIView *cameraView;
    UIImagePickerController *imagePicker;
    UIImage *snap;

    @private
    KrollCallback *pickerSuccessCallback;
    KrollCallback *pickerErrorCallback;
    KrollCallback *pickerCancelCallback;

}

-(void)commonPickerSetup:(NSDictionary*)args;
-(void)setCallbacks:(NSDictionary*)args;
-(TiBlob*)getBlob:(id)args;
-(void)takePic:(id)args;
-(UIImage*)Snap:(id)args;
-(TiBlob*)SnapAsBlob:(id)args;
-(TiBlob*)asBlob:(id)args;






@end
