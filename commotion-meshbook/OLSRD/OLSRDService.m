//
//  OLSRDService.m
//  commotion-meshbook
//
//  Created by Brad : Scal.io, LLC - http://scal.io
//

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
                                             selector:@selector(OLSRDServiceExecuteSuccess:)
                                                 name:BLshellCommandExecuteSuccessNotification
                                               object:[BLAuthentication sharedInstance]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(OLSRDServiceExecuteFailure:)
                                                 name:BLshellCommandExecuteFailureNotification
                                               object:[BLAuthentication sharedInstance]];

    
    
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
    
    // kill existing process (if exists)
    [[BLAuthentication sharedInstance] killProcess:@"olsrd"];
    
    NSArray *args = [NSArray arrayWithObjects:@"-f", olsrdConfPath, @"-i", @"en1", @"-d", @"1", nil];
    [[BLAuthentication sharedInstance] executeCommand:olsrdPath withArgs:args andType:@"olsrd"];
    
}

- (void) OLSRDServiceExecuteSuccess:(NSNotification*)aNotification {
    
    // our olsrd shell command executed successfully -- now ok to fetch (poll) json data from localhost:9090
    // BEGIN POLLING
    
    // Note: runs on main thread - I dont see any reason to spin up a new thread as no UI blocking occuring that I can tell
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(executeMeshDataPolling) userInfo:nil repeats:YES];
}

- (void) OLSRDServiceExecuteFailure:(NSNotification*)aNotification {
    
    // there was a (sporadic) problem with AuthorizationExecuteWithPriveldges auth
    // (happens once every few auths -- nature of using deprecated call?
    [self executeOLSRDService];
    
}

- (void) executeMeshDataPolling {
    
    MeshDataSync *meshSyncClass = [[MeshDataSync alloc] init];
    [meshSyncClass fetchMeshData];
    
}




@end
