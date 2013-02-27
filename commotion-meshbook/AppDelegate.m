//
//  AppDelegate.m
//  commotion-meshbook
//
//  Created by Brad : Scal.io, LLC - http://scal.io
//

#import "AppDelegate.h"
#import "MASPreferencesWindowController.h"
#import "BLAuthentication.h"
#import "MeshDataSync.h"
#import "NetworkDataSync.h"
// view controllers
#import "StatusViewController.h"
#import "ProfilesViewController.h"
#import "HelpViewController.h"
#import "LogViewController.h"


static NSString *const kMASPreferencesSelectedViewKey = @"MASPreferences Selected Identifier View";

@implementation AppDelegate 


//==========================================================
#pragma mark Application Lifecycle
//==========================================================
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    
    // setup notifications
    // listen for successful return of olsrd shell process starting
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(OLSRDServiceExecuteSuccess:)
                                                 name:BLshellCommandExecuteSuccessNotification
                                               object:[BLAuthentication sharedInstance]];
    
    // listen for successful return of json data from localhost
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateMeshMenuItems:)
                                                 name:@"meshDataProcessingComplete"
                                               object:nil];
    
    // setup menu settings for mesh
    //[self initMeshInterface];
    
    // setup menu settings for network
    //[self initNetworkInterface];
    
	// 'Quit' menu item is enabled always
	[menuQuit setEnabled:YES];
    
    // Enables or disables the receiver’s menu items and sizes the menu to fit its current menu items if necessary.
	[statusMenu update];
    
}

- (void) awakeFromNib {
    
    // Setup "status menu extra" menulet with icons and mode
	statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
	
	NSImage *meshIcon = [[NSImage alloc] initWithContentsOfFile:
                         [[NSBundle mainBundle] pathForResource:@"menuIcon"
                                                         ofType:@"png"]];
	[statusItem setImage:meshIcon];
    [statusItem setAlternateImage: [NSImage imageNamed:@"menuIconHighlighted"]];
    
    [statusItem setHighlightMode:YES];
	[statusItem setMenu:statusMenu];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return NO;
}



//==========================================================
#pragma mark Network / Mesh Data Setup & Processing
//==========================================================

- (void)initNetworkInterface {
    
    NetworkDataSync *networkSyncClass = [[NetworkDataSync alloc] init];
    NSDictionary *fetchedNetworkData = [networkSyncClass fetchNetworkData];
    //NSLog(@"%s-fetchedNetworkData: %@", __FUNCTION__, fetchedNetworkData);
    
    [self updateNetworkMenuItems:fetchedNetworkData];

}

- (void)initMeshInterface {
    
    // Start olsrd process -- this should be started as early as possible
    [self initOLSRDService];
}

- (void)initOLSRDService {
    
    // BLAuthentication Method - using a deprecated api "AuthorizationExecuteWithPrivileges" -- as of 10.7!  Unfortunately, the "right" way
    // to auth as root is to sign the app and use SMJobBless() or equivalent.  Can't do that for this app, its open-source. Open to suggestions.
    
    // kill existing process (if exists)
    [[BLAuthentication sharedInstance] killProcess:@"olsrd"];
    
    // start new process - setup bundle paths so we're looking in the app dir   
    NSBundle* myBundle = [NSBundle mainBundle];
    NSString* olsrdPath = [myBundle pathForResource:@"olsrd" ofType:nil];
    NSString* olsrdConfPath = [myBundle pathForResource:@"olsrd" ofType:@"conf"];
    //NSLog(@"myBundle olsrd path: %@", olsrdPath);  // shows: commotion-meshbook.app/Contents/Resources/olsrd
    
    NSArray *args = [NSArray arrayWithObjects:@"-f", olsrdConfPath, @"-i", @"en1", @"-d", @"3", nil];
    [[BLAuthentication sharedInstance] executeCommand:olsrdPath withArgs:args andType:@"olsrd"];
}

- (void)OLSRDServiceExecuteSuccess:(NSNotification*)aNotification {
    
    // our olsrd shell command executed successfully -- now ok to fetch (poll) json data from localhost:9090
    // BEGIN POLLING
    
    executionCount = 0;
    
    // runs on main thread
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(executeMeshDataPolling) userInfo:nil repeats:YES];
    
    // ASYNC timer GOES OFF INTO SPACE on new thread
    //NSTimer *timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(executeMeshDataPolling) userInfo:nil repeats:NO];
    //[[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

- (void)executeMeshDataPolling {
    
    // create operation queue and start mesh data polling
    //NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    //[operationQueue setMaxConcurrentOperationCount:1];
    //MeshDataSync *meshSyncClass = [[MeshDataSync alloc] init];
    //[operationQueue addOperation: meshSyncClass];
    
    MeshDataSync *meshSyncClass = [[MeshDataSync alloc] init];
    [meshSyncClass fetchMeshData];
    
    executionCount++;
    
    //NSLog(@"executionCount: %i", executionCount);
    
}


-(void) updateNetworkMenuItems:(NSDictionary *)fetchedNetworkData {
    
    //NSLog(@"fetchedNetworkData: %@", fetchedNetworkData);
    
    // update menu items with fetched info
	[menuNetworkStatus setTitle:[NSString stringWithFormat:@"Wi-Fi: %@", [fetchedNetworkData valueForKey:@"state"]]];
	[menuNetworkSSID setTitle:[NSString stringWithFormat:@"Network (SSID): %@", [fetchedNetworkData valueForKey:@"ssid"]]];
	[menuNetworkBSSID setTitle:[NSString stringWithFormat:@"BSSID: %@", [fetchedNetworkData valueForKey:@"bssid"]]];
    [menuNetworkChannel setTitle:[NSString stringWithFormat:@"Channel: %@", [fetchedNetworkData valueForKey:@"channel"]]];

}

-(void) updateMeshMenuItems:(NSNotification *)fetchedMeshData {
  
    //NSLog(@"notification-meshData: %@", [fetchedMeshData userInfo]);
    
    NSDictionary *meshData = [fetchedMeshData userInfo];
    NSString *meshState = [meshData valueForKey:@"state"];
    
    // update menu items with fetched info
    [menuMeshStatus setTitle:[NSString stringWithFormat:@"OLSRD: %@", (meshState ? : @"Stopped")]];

	//[menuMeshProfile setTitle:[NSString stringWithFormat:@"Profile: %@", [data valueForKey:@"profile"]]];
}


//==========================================================
#pragma mark Menu / Window Controller
//==========================================================

- (NSWindowController *)settingsWindowController
{
    if (_settingsWindowController == nil)
    {
        // here we can create as many tabs as we'd like -- just add another view controller to the stack
        NSViewController *statusViewController = [[StatusViewController alloc] init];
        NSViewController *profilesViewController = [[ProfilesViewController alloc] init];
        NSViewController *helpViewController = [[HelpViewController alloc] init];
        NSViewController *logViewController = [[LogViewController alloc] init];
        NSArray *controllers = [[NSArray alloc] initWithObjects:statusViewController, profilesViewController, helpViewController, logViewController, nil];
        
        _settingsWindowController = [[MASPreferencesWindowController alloc] initWithViewControllers:controllers title:@"Settings"];
    }
    return _settingsWindowController;
}

-(IBAction) openSettings: (id)sender {
    
    //NSLog(@"sender: %@", [sender title]);
    
    // Record new selected controller in user defaults
    [[NSUserDefaults standardUserDefaults] setObject:[sender title] forKey:kMASPreferencesSelectedViewKey];
    // Post to update window
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kMenuItemChangeViewControllerTab" object:[sender title]];

    [NSApp activateIgnoringOtherApps:YES];
    
    [self.settingsWindowController showWindow:nil];
}

/** Sets the tab the user was on **/
NSString *const kFocusedAdvancedControlIndex = @"FocusedAdvancedControlIndex";

- (NSInteger)focusedAdvancedControlIndex
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:kFocusedAdvancedControlIndex];
}

- (void)setFocusedAdvancedControlIndex:(NSInteger)focusedAdvancedControlIndex
{
    [[NSUserDefaults standardUserDefaults] setInteger:focusedAdvancedControlIndex forKey:kFocusedAdvancedControlIndex];
}



@end
