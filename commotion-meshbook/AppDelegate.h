//
//  AppDelegate.h
//  commotion-meshbook
//
//  Created by Brad : Scal.io, LLC - http://scal.io
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate> {

    //NSWindow *_window;
    NSWindowController *_settingsWindowController;
    
	NSStatusItem *statusItem;       
	IBOutlet NSMenu *statusMenu;
	IBOutlet NSMenuItem *menuStatus;
    IBOutlet NSMenuItem *menuProfile;
    IBOutlet NSMenuItem *menuNetwork;
	IBOutlet NSMenuItem *menuQuit;
    
	//NSUserDefaults *userPrefs;
}

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, readonly) NSWindowController *settingsWindowController;
@property (nonatomic) NSInteger focusedAdvancedControlIndex;

-(NSMutableDictionary*) getProfileInfo;
-(IBAction)openSettings:(id)sender;
-(IBAction) updateProfileInfo: (id)sender;
-(IBAction) clearUserDefaults: (id)sender;

@end
