//
//  ProfileData.h
//  commotion-meshbook
//
//  Created by Brad : Scal.io, LLC - http://scal.io
//

#import <Foundation/Foundation.h>

@interface ProfileData : NSObject

@property (strong) NSString *ssid;
@property (strong) NSString *bssid;
@property (strong) NSString *channel;
@property (strong) NSString *ip;
@property (strong) NSString *ipgenerate;
@property (strong) NSString *netmask;
@property (strong) NSString *dns;
@property (strong) NSImage  *thumbImage;


- (id)initWithSSID:(NSString*)ssid bssid:(NSString*)bssid channel:(NSString*)channel ip:(NSString*)ip ipgenerate:(NSString*)ipgenerate netmask:(NSString*)netmask dns:(NSString*)dns thumbImage:(NSImage *)thumbImage;

@end