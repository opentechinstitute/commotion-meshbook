//
//  NetworkService.h
//  commotion-meshbook
//
//  Created by Brad : Scal.io, LLC - http://scal.io
//

#import <Foundation/Foundation.h>

@class CWInterface, CWConfiguration, CWNetwork, SFAuthorizationView;

@interface NetworkService : NSObject {
    
    // Networking lib CoreWLAN
    CWInterface *currentInterface;
    // User Wifi Data
    BOOL powerState;
    NSString *ip;
    NSString *ssid;
    NSString *bssid;
    NSNumber *channel;
    // Scanned Networks Data
    //NSDictionary *scannedNetworkData;
    //NSMutableDictionary *scannedNetworks;
    NSMutableArray *scannedNetworks;
    
}

@property (readwrite, retain) CWInterface *currentInterface;
@property (readwrite, retain) NSMutableArray *scanResults;

#pragma mark -
#pragma mark Initialization
-(id) init;

#pragma mark -
#pragma mark CoreWLAN Fetch & Processing
- (NSDictionary *) scanUserWifiSettings;
- (NSMutableArray *) scanAvailableNetworks;

#pragma mark -
#pragma mark Ifconfig Shell


#pragma mark -
#pragma mark Authentication Notifications
//- (void) shellCommandExecuteSuccess:(NSNotification*)aNotification;
//- (void) shellCommandExecuteFailure:(NSNotification*)aNotification;



@end
