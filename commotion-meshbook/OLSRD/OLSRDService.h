//
//  OLSRDService.h
//  commotion-meshbook
//
//  Created by Brad : Scal.io, LLC - http://scal.io
//

#import <Foundation/Foundation.h>

@interface OLSRDService : NSObject {
    NSBundle* myBundle;
    NSString* olsrdPath;
    NSString* olsrdConfPath;
    dispatch_queue_t backgroundQueue;

}

#pragma mark -
#pragma mark Initialization & Run Loop
-(id) init;

#pragma mark -
#pragma mark OLSRD Service & Mesh Polling
- (void) executeOLSRDService;
- (void) executeMeshDataPolling;

#pragma mark -
#pragma mark Authentication Notifications
- (void) shellCommandExecuteSuccess:(NSNotification*)aNotification;
- (void) shellCommandExecuteFailure:(NSNotification*)aNotification;

@end
