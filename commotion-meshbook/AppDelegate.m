//
//  AppDelegate.m
//  commotion-meshbook
//
//  Created by Brad : Scal.io, LLC - http://scal.io
//

#import "AppDelegate.h"
#import "MASPreferencesWindowController.h"
#import "StatusViewController.h"
#import "ProfilesViewController.h"
#import "HelpViewController.h"
#import "LogViewController.h"

@implementation AppDelegate

NSString *const kFocusedAdvancedControlIndex = @"FocusedAdvancedControlIndex";


@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    
    /**
    NSLog(@"ssid: %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"ssid"]);
    NSLog(@"bssid: %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"bssid"]);
    NSLog(@"channel: %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"channel"]);
    NSLog(@"ip: %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"]);
    NSLog(@"ipgenerate: %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"ipgenerate"]);
    NSLog(@"netmask: %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"netmask"]);
    NSLog(@"dns: %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"dns"]);
    **/

    // Default Preferences
	//userPrefs = [NSUserDefaults standardUserDefaults];

	// Initialize
	[menuQuit setEnabled:YES];
    
    // Enables or disables the receiver’s menu items and sizes the menu to fit its current menu items if necessary.
	[statusMenu update];
    
    // fetch information from the default profile
    [self updateProfileInfo:nil];

	
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
        
    [self.settingsWindowController showWindow:nil];
}

- (NSInteger)focusedAdvancedControlIndex
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:kFocusedAdvancedControlIndex];
}

- (void)setFocusedAdvancedControlIndex:(NSInteger)focusedAdvancedControlIndex
{
    [[NSUserDefaults standardUserDefaults] setInteger:focusedAdvancedControlIndex forKey:kFocusedAdvancedControlIndex];
}


- (NSMutableDictionary*) getProfileInfo {
    
	NSMutableDictionary *olsrdInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     @"Initializing...", @"state",
                                     @"N/A", @"profile",
                                     @"N/A", @"ssid",
                                     nil];

    
    
    
    // logic to fetch olsrd info from http://localhost:9090 here
    
    
    
    
	return olsrdInfo;
}


-(IBAction) updateProfileInfo: (id)sender {
    
    // fetch state and status from olsrd
	NSDictionary *status = [self getProfileInfo];
    
    // update menu items with fetched info
	[menuStatus setTitle:[NSString stringWithFormat:@"Status: %@", [status valueForKey:@"state"]]];
	[menuProfile setTitle:[NSString stringWithFormat:@"Profile: %@", [status valueForKey:@"profile"]]];
	[menuNetwork setTitle:[NSString stringWithFormat:@"Network: %@", [status valueForKey:@"ssid"]]];
    
}

-(IBAction) clearUserDefaults: (id)sender {
    
    NSLog(@"\n\n");
    NSLog(@"CLEARING USER DEFAULTS");
    
    // clear user defaults (text the user inputs into pref pane)
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ssid"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"bssid"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"channel"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ip"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ipgenerate"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"netmask"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"dns"];
    [[NSUserDefaults standardUserDefaults] synchronize];
 
    NSLog(@"CLEARED ssid: %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"ssid"]);
    NSLog(@"CLEARED bssid: %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"bssid"]);
    NSLog(@"CLEARED channel: %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"channel"]);
    NSLog(@"CLEARED ip: %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"]);
    NSLog(@"CLEARED ipgenerate: %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"ipgenerate"]);
    NSLog(@"CLEARED netmask: %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"netmask"]);
    NSLog(@"CLEARED dns: %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"dns"]);
    
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return YES;
}

@end
