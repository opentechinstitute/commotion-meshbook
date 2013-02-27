//
//  ProfilesData.m
//  commotion-meshbook
//
//  Created by Brad : Scal.io, LLC - http://scal.io
//
//  Encoding and decoding of our objects

#import "ProfilesData.h"

@implementation ProfilesData

//==========================================================
#pragma mark Init Profile Defaults
//==========================================================
- (id)initWithSSID:(NSString*)ssid bssid:(NSString*)bssid channel:(NSString*)channel ip:(NSString*)ip ipgenerate:(NSString*)ipgenerate netmask:(NSString*)netmask dns:(NSString*)dns {
    
    if ((self = [super init])) {
        
        self.ssid = ssid;
        self.bssid = bssid;
        self.channel = channel;
        self.ip = ip;
        self.ipgenerate = ipgenerate;
        self.netmask = netmask;
        self.dns = dns;

    }
    return self;
}

//==========================================================
#pragma mark NSCoding
//==========================================================

#define kSSIDKey       @"SSID"
#define kBSSIDKey      @"BSSID"
#define kChannelKey    @"Channel"
#define kIPKey         @"IP"
#define kIPGenerateKey @"IPGenerate"
#define kNetmaskKey    @"Netmask"
#define kDNSKey        @"DNS"

- (void) encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:self.ssid forKey:kSSIDKey];
    [encoder encodeObject:self.bssid forKey:kBSSIDKey];
    [encoder encodeObject:self.channel forKey:kChannelKey];
    [encoder encodeObject:self.ip forKey:kIPKey];
    [encoder encodeObject:self.ipgenerate forKey:kIPGenerateKey];
    [encoder encodeObject:self.netmask forKey:kNetmaskKey];
    [encoder encodeObject:self.dns forKey:kDNSKey];
}

- (id) initWithCoder:(NSCoder *)decoder {
    
    NSString *ssid = [decoder decodeObjectForKey:kSSIDKey];
    NSString *bssid = [decoder decodeObjectForKey:kBSSIDKey];
    NSString *channel = [decoder decodeObjectForKey:kChannelKey];
    NSString *ip = [decoder decodeObjectForKey:kIPKey];
    NSString *ipgenerate = [decoder decodeObjectForKey:kIPGenerateKey];
    NSString *netmask = [decoder decodeObjectForKey:kNetmaskKey];
    NSString *dns = [decoder decodeObjectForKey:kDNSKey];
    
    return [self initWithSSID:ssid bssid:bssid channel:channel ip:ip ipgenerate:ipgenerate netmask:netmask dns:dns];
}



@end
