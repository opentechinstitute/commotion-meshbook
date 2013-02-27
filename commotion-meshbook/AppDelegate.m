//
//  AppDelegate.m
//  commotion-meshbook
//
//  Created by Brad : Scal.io, LLC - http://scal.io
//

#import "AppDelegate.h"
#import "MASPreferencesWindowController.h"
#import "NetworkDataSync.h"
#import "OLSRDService.h"
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
    // listen for successful return of json data from localhost
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateMeshMenuItems:)
                                                 name:@"meshDataProcessingComplete"
                                            object:nil];
    
    // setup menu settings for mesh
    [self initMeshInterface];
        
    // setup menu settings for network
    [self initNetworkInterface];
    
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
    
    
    // add available profiles to the menubar
    //[self initProfilesMenuItems];
    
	[statusItem setMenu:statusMenu];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return NO;
}


- (void)initProfilesMenuItems {
 
    NSMenuItem *item = [statusMenu insertItemWithTitle:[NSString stringWithFormat:@"%@", @"meh"] action:@selector(placeholder) keyEquivalent:@"" atIndex:11];
    //[item setEnabled:TRUE];
    [item setTarget:self];
}

- (void)placeholder {
    
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
    OLSRDService *olsrdProcess = [[OLSRDService alloc] init];
    [olsrdProcess executeOLSRDService]; 
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
    //[menuMeshSSID setTitle:[NSString stringWithFormat:@"%@", [fetchedMeshData valueForKey:@"ssid"]]];
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
