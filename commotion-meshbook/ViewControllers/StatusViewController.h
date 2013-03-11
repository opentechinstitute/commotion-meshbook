//
//  StatusViewController.h
//  commotion-meshbook
//
//  Created by Brad : Scal.io, LLC - http://scal.io
//

#import "MASPreferencesViewController.h"

@interface StatusViewController : NSViewController  <MASPreferencesViewController> {
    

    //NSString *fetchedWifiSSID;
    //NSString *fetchedWifiChannel;
    //BOOL wifiOn;
    
    IBOutlet NSView *statusView;
    IBOutlet NSTextField *networkName;      // ssid
    IBOutlet NSTextField *networkSSID;      // ssid
    IBOutlet NSTextField *networkBSSID;     // bssid
    IBOutlet NSTextField *networkChannel;   // channel
    IBOutlet NSTextField *localIP;          // ip
    IBOutlet NSTextField *olsrdStatus;      // olsrd running/stopped
    
}

#pragma mark -
#pragma mark Init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

#pragma mark -
#pragma mark Data Processing
-(void) proccessMeshStatusData:(NSNotification *)fetchedMeshData;
-(void) proccessWifiStatusData:(NSNotification *)fetchedWifiData;

@end
