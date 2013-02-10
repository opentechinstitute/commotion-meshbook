//
//  AppDelegate.h
//  commotion-meshbook
//
//  Created by Bradley on 1/14/13.
//  Copyright (c) 2013 Scal.io, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RegexKitLite.h"

@interface AppDelegate : NSObject <NSApplicationDelegate> {

    NSWindow *window;
	NSStatusItem *statusItem;       
	IBOutlet NSMenu *statusMenu;
	IBOutlet NSMenuItem *menuStatus;
    IBOutlet NSMenuItem *menuProfile;
    IBOutlet NSMenuItem *menuNetwork;
	IBOutlet NSMenuItem *menuQuit;
    
	NSUserDefaults *userPrefs;
}

@property (assign) IBOutlet NSWindow *window;

-(NSMutableDictionary*) getProfileInfo;
-(IBAction) updateProfileInfo: (id)sender;
-(IBAction) showPreferences: (id)sender;

@end
