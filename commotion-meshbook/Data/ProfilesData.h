//
//  ProfilesData.h
//  commotion-meshbook
//
//  Created by Brad : Scal.io, LLC - http://scal.io
//

#import <Foundation/Foundation.h>

@interface ProfilesData : NSObject 

@property (strong) NSString *ssid;
@property (strong) NSString *bssid;
@property (strong) NSString *channel;
@property (strong) NSString *ip;
@property (strong) NSString *ipgenerate;
@property (strong) NSString *netmask;
@property (strong) NSString *dns;


#pragma mark -
#pragma mark Init Profile Defaults
- (id)initWithSSID:(NSString*)ssid bssid:(NSString*)bssid channel:(NSString*)channel ip:(NSString*)ip ipgenerate:(NSString*)ipgenerate netmask:(NSString*)netmask dns:(NSString*)dns;

#pragma mark -
#pragma mark NSCoding
- (void) encodeWithCoder:(NSCoder *)encoder;
- (id) initWithCoder:(NSCoder *)decoder;

@end