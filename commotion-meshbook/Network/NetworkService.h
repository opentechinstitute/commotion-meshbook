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
    BOOL powerState;
    NSString *ip;
    NSString *ssid;
    NSString *bssid;
    NSNumber *channel;
    
}

@property (readwrite, retain) CWInterface *currentInterface;

#pragma mark -
#pragma mark Initialization
-(id) init;

#pragma mark -
#pragma mark CoreWLAN Fetch & Processing
- (NSMutableDictionary*) fetchNetworkData;

#pragma mark -
#pragma mark Ifconfig Shell


#pragma mark -
#pragma mark Authentication Notifications
//- (void) shellCommandExecuteSuccess:(NSNotification*)aNotification;
//- (void) shellCommandExecuteFailure:(NSNotification*)aNotification;



@end
