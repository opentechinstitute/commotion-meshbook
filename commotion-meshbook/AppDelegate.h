//
//  AppDelegate.h
//  commotion-meshbook
//
//  Created by Brad : Scal.io, LLC - http://scal.io
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate> {

    // view controller setup
    NSWindowController *_settingsWindowController;
    
    // Menu Items
	NSStatusItem *statusItem;
	IBOutlet NSMenu *statusMenu;
	IBOutlet NSMenuItem *menuQuit;

    // Menu Items - Network
	IBOutlet NSMenuItem *menuNetworkStatus;
    IBOutlet NSMenuItem *menuNetworkSSID;
    IBOutlet NSMenuItem *menuNetworkBSSID;
    IBOutlet NSMenuItem *menuNetworkChannel;
    // Menu Items - Mesh
    IBOutlet NSMenuItem *menuMeshSSID;
    IBOutlet NSMenuItem *menuMeshStatus;
    IBOutlet NSMenuItem *menuMeshProfile;
    
    int executionCount;
}

@property (nonatomic, readonly) NSWindowController *settingsWindowController;
@property (nonatomic) NSInteger focusedAdvancedControlIndex; // maspref 

- (void)initProfilesMenuItems;
- (void)placeholder;

#pragma mark -
#pragma mark Network / Mesh Data Setup & Processing
- (void)initNetworkInterface;
- (void)initMeshInterface;
- (void)updateNetworkMenuItems:(NSDictionary *)fetchedNetworkData;
- (void)updateMeshMenuItems:(NSNotification *)fetchedMeshData;

#pragma mark -
#pragma mark Menu / Window Controller
- (NSWindowController *)settingsWindowController;
- (IBAction) openSettings:(id)sender;
- (NSInteger)focusedAdvancedControlIndex;
- (void)setFocusedAdvancedControlIndex:(NSInteger)focusedAdvancedControlIndex;

@end
