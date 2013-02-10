//
//  AppDelegate.m
//  commotion-meshbook
//
//  Created by Bradley on 1/14/13.
//  Copyright (c) 2013 Scal.io, LLC. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{

    // Default Preferences
	userPrefs = [NSUserDefaults standardUserDefaults];

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

-(IBAction) showPreferences: (id)sender {
    
    // make the pref window visible and focused
	[self.window makeKeyAndOrderFront:sender];
	[self.window becomeMainWindow];
}

@end
