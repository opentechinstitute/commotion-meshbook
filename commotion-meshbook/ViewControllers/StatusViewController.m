//
//  StatusViewController.m
//  commotion-meshbook
//
//  Created by Brad : Scal.io, LLC - http://scal.io
//

#import "StatusViewController.h"

@implementation StatusViewController

//==========================================================
#pragma mark Init
//==========================================================

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"StatusViewController" bundle:nil];
    if (self) {
        
        // listen for successful return of json data from localhost
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(proccessMeshStatusData:)
                                                     name:@"meshDataProcessingComplete"
                                                   object:nil];
        
        // listen for network wifi data poll
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(proccessWifiStatusData:)
                                                     name:@"wifiDataProcessingComplete"
                                                   object:nil];
        
    }
    
    return self;
}

//==========================================================
#pragma mark Data Processing
//==========================================================

-(void) proccessMeshStatusData:(NSNotification *)fetchedMeshData {
    
    //NSLog(@"notification-meshData: %@", [fetchedMeshData userInfo]);
    
    NSDictionary *meshData = [fetchedMeshData userInfo];
    
    NSString *olsrdState = [meshData valueForKey:@"state"];
    NSString *meshLocalIP = [meshData valueForKey:@"localIP"];
    //NSString *meshRemoteIP = [meshData valueForKey:@"remoteIP"];
    //NSString *meshLinkQuality = [meshData valueForKey:@"linkQuality"];
    
    [localIP setStringValue:[NSString stringWithFormat:@"IP Address: %@", meshLocalIP]];
    [olsrdStatus setStringValue:[NSString stringWithFormat:@"OLSRD: %@", olsrdState]];

    
    NSLog(@"%s: meshData: %@", __FUNCTION__, meshData);
    

}

-(void) proccessWifiStatusData:(NSNotification *)fetchedWifiData {
    
    //NSLog(@"notification-meshData: %@", [fetchedMeshData userInfo]);
    
    NSDictionary *wifiData = [fetchedWifiData userInfo];
    
    //NSString *wifiPower = [wifiData valueForKey:@"state"];
    NSString *wifiSSID = [wifiData valueForKey:@"ssid"];
    NSString *wifiBSSID = [wifiData valueForKey:@"bssid"];
    NSString *wifiChannel = [wifiData valueForKey:@"channel"];

    [networkName setStringValue:[NSString stringWithFormat:@"%@", wifiSSID]];
    [networkSSID setStringValue:[NSString stringWithFormat:@"SSID: %@", wifiSSID]];
    [networkBSSID setStringValue:[NSString stringWithFormat:@"BSSID: %@", wifiBSSID]];
    [networkChannel setStringValue:[NSString stringWithFormat:@"Channel: %@", wifiChannel]];


    
    
    NSLog(@"%s: wifiData: %@", __FUNCTION__, wifiData);
    
    
}




//==========================================================
#pragma mark MASPreferencesViewController
//==========================================================

- (NSString *)identifier
{
    return @"Show Mesh Status";
}

- (NSImage *)toolbarItemImage
{
    return [NSImage imageNamed:@"tabStatus"];
}

- (NSString *)toolbarItemLabel
{
    return NSLocalizedString(@"Status", @"Toolbar item name for the Status pane");
}

@end
