//
//  AppDelegate.m
//  commotion-meshbook
//
//  Created by Brad : Scal.io, LLC - http://scal.io
//

#import "AppDelegate.h"
#import "MASPreferencesWindowController.h"
#import "NetworkService.h"
#import "OLSRDService.h"
#import "ProfilesDoc.h"
#import "ProfilesData.h"
#import "ProfilesDatabase.h"

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
    
    // setup menu settings for network
    [self initNetworkInterface];
    
    // setup menu settings for mesh
    [self initMeshInterface];
    
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
    
    // set our delegate here so 'menuWillOpen' is called
    [statusMenu setDelegate:self];
	[statusItem setMenu:statusMenu];
}

//==========================================================
#pragma mark NSMenu Delegate
//==========================================================
// called every time the user opens the menu
- (void)menuWillOpen:(NSMenu *)menu
{
    //NSLog(@"%s", __FUNCTION__);
    
    NSMenuItem *selectedItem = [menu itemAtIndex:11];
    //NSLog(@"%s: selectedItem: %@", __FUNCTION__, selectedItem.title);
    
    // add available profiles to the menubar (dynamic adds based on data in plist directory)
    // load all profiles from our data store
    self.profiles = [ProfilesDatabase loadProfilesDocs];
    
    // here we reverse the loop to display the correct order of profiles
    for ( NSUInteger loopIndex = [self.profiles count]; loopIndex > 0; --loopIndex ) {
        NSUInteger i = loopIndex - 1;
        
        // get data from our model
        ProfilesDoc *profilesDoc = [self.profiles objectAtIndex:i];
        // add menu item
        NSMenuItem *item = [statusMenu insertItemWithTitle:[NSString stringWithFormat:@"%@", profilesDoc.data.ssid] action:@selector(setSelectedProfile:) keyEquivalent:@"" atIndex:12];
        
        if ([selectedItem.title isEqualToString:item.title]) {
            [item setState: NSOnState];
        }
        
        [item setTarget:self];
    }
}

// called when we need to update menu items
- (void)menuNeedsUpdate:(NSMenu *)menu {
    
    //NSLog(@"%s: menu %@", __FUNCTION__, menu);
    //NSMenuItem *selectedItem = [menu itemAtIndex:11];
    //NSLog(@"%s: selectedItem: %@", __FUNCTION__, selectedItem.title);
        
    // remove dynamic menu items in between the static ones
    for ( NSUInteger i = menu.numberOfItems-8; i >= 12; --i ) {
        
        //NSMenuItem *menuItem = [menu itemAtIndex:i];
        //NSLog(@"%s: index: %lu -- menuItem: %@", __FUNCTION__, i, menuItem.title);
        
        [menu removeItemAtIndex:i];
    }
}

// connect to our network
- (void)setSelectedProfile:(NSMenuItem *)selectedNetwork  {
    
    NSLog(@"%s-selectedMenuItem: %@", __FUNCTION__, selectedNetwork.title);
    
    [menuSelectedNetwork setTitle:selectedNetwork.title];
}


- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return NO;
}


//==========================================================
#pragma mark Network / Mesh Data Setup & Processing
//==========================================================

- (void)initNetworkInterface {
    
    NetworkService *NetworkServiceClass = [[NetworkService alloc] init];
    NSDictionary *fetchedNetworkData = [NetworkServiceClass fetchNetworkData];
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
	[menuNetworkStatus setTitle:[NSString stringWithFormat:@"Power: %@", [fetchedNetworkData valueForKey:@"state"]]];
	[menuNetworkSSID setTitle:[NSString stringWithFormat:@"Network (SSID): %@", [fetchedNetworkData valueForKey:@"ssid"]]];
	[menuNetworkBSSID setTitle:[NSString stringWithFormat:@"BSSID: %@", [fetchedNetworkData valueForKey:@"bssid"]]];
    [menuNetworkChannel setTitle:[NSString stringWithFormat:@"Channel: %@", [fetchedNetworkData valueForKey:@"channel"]]];

}

-(void) updateMeshMenuItems:(NSNotification *)fetchedMeshData {
  
    //NSLog(@"notification-meshData: %@", [fetchedMeshData userInfo]);
    
    NSDictionary *meshData = [fetchedMeshData userInfo];
    NSString *meshState = [meshData valueForKey:@"state"];
    
    
    // if wanting to update menu items dynamically while menu is shown
    // http://stackoverflow.com/questions/6301338/update-nsmenuitem-while-the-host-menu-is-shown
    /**
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                [self methodSignatureForSelector:@selector(doStuff)]];
    [invocation setTarget:self];
    [invocation setSelector:@selector(doStuff)];
    [[NSRunLoop mainRunLoop] addTimer:[NSTimer timerWithTimeInterval:1 invocation:invocation repeats:YES] forMode:NSRunLoopCommonModes];
    **/
    
    
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
