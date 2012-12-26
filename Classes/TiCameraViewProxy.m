/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2012 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiCameraViewProxy.h"
#import "TiUtils.h"

@implementation TiCameraViewProxy



-(void)takePic:(id)args
{
    [self makeViewPerformSelector:@selector(takePic:) withObject:args createIfNeeded:YES waitUntilDone:NO];

}

-(UIImage*)Snap:(id)args
{
    [self makeViewPerformSelector:@selector(Snap:) withObject:args createIfNeeded:YES waitUntilDone:NO];
    
}
-(TiBlob*)SnapAsBlob:(id)args
{
    [self makeViewPerformSelector:@selector(SnapAsBlob:) withObject:args createIfNeeded:YES waitUntilDone:NO];
    
}
-(TiBlob*)asBlob:(id)args
{
    [self makeViewPerformSelector:@selector(asBlob:) withObject:args createIfNeeded:YES waitUntilDone:NO];
    
}


@end
