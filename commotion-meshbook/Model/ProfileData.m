//
//  ProfileData.m
//  commotion-meshbook
//
//  Created by Brad : Scal.io, LLC - http://scal.io
//

#import "ProfileData.h"

@implementation ProfileData

- (id)initWithSSID:(NSString*)ssid bssid:(NSString*)bssid channel:(NSString*)channel ip:(NSString*)ip ipgenerate:(NSString*)ipgenerate netmask:(NSString*)netmask dns:(NSString*)dns thumbImage:(NSImage *)thumbImage {
    
    if ((self = [super init])) {
        
        self.ssid = ssid;
        self.bssid = bssid;
        self.channel = channel;
        self.ip = ip;
        self.ipgenerate = ipgenerate;
        self.netmask = netmask;
        self.dns = dns;
        self.thumbImage = thumbImage;

    }
    return self;
}

@end
