//
//  NetworkDataSync.m
//  commotion-meshbook
//
//  Created by Brad : Scal.io, LLC - http://scal.io
//

#import <CoreWLAN/CoreWLAN.h>
#import <SecurityInterface/SFAuthorizationView.h>

#import "NetworkDataSync.h"

@implementation NetworkDataSync

@synthesize currentInterface = _currentInterface;

//==========================================================
#pragma mark Initialization & Run Loop
//==========================================================

-(id) init {
    //NSLog(@"NetworkDataSync: init");
    
	if (![super init]) return nil;
    
    // get interface array (common == 'en1')
    NSArray *supportedInterfaces = [CWInterface supportedInterfaces];
    //NSLog(@"[supportedInterfaces objectAtIndex:0: %@", [supportedInterfaces objectAtIndex:0]);
    
    // init network interface with 'en1'
    currentInterface = [CWInterface interfaceWithName:[supportedInterfaces objectAtIndex:0]];
    //NSLog(@"currentInterface: %@", currentInterface);
    
    return self;
}

//==========================================================
#pragma mark Data Fetch & Processing
//==========================================================
- (NSMutableDictionary*) fetchNetworkData {
    
    //NSLog(@"NetworkDataSync: fetchNetworkData");

    // get data from CoreWLAN wireless interface
    powerState = [currentInterface power];
    NSString *power;
    if (powerState==NO) { power=@"Off"; } else { power=@"On";}
    
    ssid = ([currentInterface ssid] ? : @"");
    bssid = ([currentInterface bssid] ? : @"");
    channel = ([currentInterface channel] ? : 0);
    
    //NSLog(@"powerState: %i", powerState);
    //NSLog(@"Network (SSID): %@", ssid);
    //NSLog(@"BSSID: %@", bssid);
    //NSLog(@"CHANNEL: %@", channel);
    
	NSMutableDictionary *networkItems = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                         power, @"state",
                                         ssid, @"ssid",
                                         bssid, @"bssid",
                                         (channel ? : @""), @"channel",
                                         nil];
    
	return networkItems;
}

@end
