//
//  OLSRDService.m
//  commotion-meshbook
//
//  Created by Brad : Scal.io, LLC - http://scal.io
//

#import <Growl/Growl.h>
#import "OLSRDService.h"
#import "BLAuthentication.h"
#import "MeshDataSync.h"

@implementation OLSRDService

//==========================================================
#pragma mark Initialization & Run Loop
//==========================================================
-(id) init {
    //NSLog(@"olsrdService: init");
    
	if (![super init]) return nil;

    // setup notifications
    // listen for successful return of olsrd shell process starting
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(shellCommandExecuteSuccess:)
                                                 name:BLshellCommandExecuteSuccessNotification
                                               object:[BLAuthentication sharedInstance]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(shellCommandExecuteFailure:)
                                                 name:BLshellCommandExecuteFailureNotification
                                               object:[BLAuthentication sharedInstance]];

    // setup background queue (thread)
    backgroundQueue = dispatch_queue_create("com.blekko.izikBlekko.bgqueue", NULL);
    
    // start new process - setup bundle paths so we're looking in the app dir
    myBundle = [NSBundle mainBundle];
    olsrdPath = [myBundle pathForResource:@"olsrd" ofType:nil];
    olsrdConfPath = [myBundle pathForResource:@"olsrd" ofType:@"conf"];
    //NSLog(@"myBundle olsrd conf path: %@", olsrdConfPath);
    //shows: commotion-meshbook.app/Contents/Resources/olsrd

    return self;
}

//==========================================================
#pragma mark OLSRD Service & Mesh Polling
//==========================================================
- (void) executeOLSRDService {
    
    // BLAuthentication Method - using a deprecated api "AuthorizationExecuteWithPrivileges"
    // as of 10.7!  Unfortunately, the "right" wayto auth as root is to sign the app and 
    // use SMJobBless() or equivalent.  Can't do that for this app, its open-source. Open to suggestions.
    
    dispatch_async(backgroundQueue, ^(void) {

        NSArray *args1 = [NSArray arrayWithObjects:@"-9", @"olsrd", nil];
        [[BLAuthentication sharedInstance] executeCommand:@"/usr/bin/killall" withArgs:args1 andType:@"kill" andMessage:@"Killing existing olsrd processes"];
        
        NSArray *args2 = [NSArray arrayWithObjects:@"-f", olsrdConfPath, @"-i", @"en1", @"-d", @"1", nil];
        [[BLAuthentication sharedInstance] executeCommand:olsrdPath withArgs:args2 andType:@"olsrd" andMessage:@"Starting a new olsrd process"];
        
    });
}

- (void) executeMeshDataPolling {
    
    MeshDataSync *meshSyncClass = [[MeshDataSync alloc] init];
    [meshSyncClass fetchMeshData];
}


- (void) shellCommandExecuteSuccess:(NSNotification*)aNotification {
    
    [GrowlApplicationBridge notifyWithTitle:@"Executing Process"
                                description:@"Starting mesh data polling"
                           notificationName:@"meshbookGrowlNotification"
                                   iconData:nil
                                   priority:0 // -2 == Low priority. +2 == High Priority. 0 == Neutral
                                   isSticky:NO
                               clickContext:nil];
    
    // our olsrd shell command executed successfully -- now ok to fetch (poll) json data from localhost:9090
    // BEGIN POLLING
    
    // Note: runs on main thread - I dont see any reason to spin up a new thread as no UI blocking occuring that I can tell
    
    // use "scheduledTimer..." to have it already scheduled in NSRunLoopCommonModes, it will fire when the menu is closed
    /** METHOD 1 of updating menu **/
    
    // use "scheduledTimer..." to have it already scheduled in NSRunLoopCommonModes, it will fire when the menu is closed
    NSTimer *menuTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(executeMeshDataPolling) userInfo:nil repeats:YES];
    
    // add the timer to the run loop in NSEventTrackingRunLoopMode to have it fired even when menu is open
    [[NSRunLoop currentRunLoop] addTimer:menuTimer forMode:NSEventTrackingRunLoopMode];
    
    /** METHOD 2 of updating menu **/
    /**
     NSInvocation *invocation = [NSInvocation invocationWithMethodSignature: [self methodSignatureForSelector:@selector(executeMeshDataPolling)]];
     [invocation setTarget:self];
     [invocation setSelector:@selector(executeMeshDataPolling)];
     [[NSRunLoop mainRunLoop] addTimer:[NSTimer timerWithTimeInterval:5 invocation:invocation repeats:YES] forMode:NSRunLoopCommonModes];
     **/
}

- (void) shellCommandExecuteFailure:(NSNotification*)aNotification {
    
    // there was a (sporadic) problem with AuthorizationExecuteWithPriveldges auth
    // (happens once every few auths -- nature of using deprecated call?  RETRY
    [self executeOLSRDService];
    
}

- (void)dealloc {
    
    //NSLog(@"dealloc Background Thread");
    
    // release memory for grand central dispatch
#if !OS_OBJECT_USE_OBJC
	dispatch_release(backgroundQueue);
#endif
}



@end
