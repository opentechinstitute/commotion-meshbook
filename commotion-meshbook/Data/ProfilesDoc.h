//
//  ProfilesDoc.h
//  commotion-meshbook
//
//  Created by Brad : Scal.io, LLC - http://scal.io
//

#import <Foundation/Foundation.h>

@class ProfilesData;

@interface ProfilesDoc : NSObject {
    
    ProfilesData *_data;
    
}

@property (strong, nonatomic) ProfilesData *data;
@property (strong) NSString *docPath;

#pragma mark -
#pragma mark Init Profile Defaults
- (id)init;
- (id)initWithDocPath:(NSString *)docPath;
- (id)initWithSSID:(NSString*)ssid bssid:(NSString*)bssid channel:(NSString*)channel ip:(NSString*)ip ipgenerate:(NSString*)ipgenerate netmask:(NSString*)netmask dns:(NSString*)dns;

#pragma mark -
#pragma mark Manage Data
- (BOOL)createDataPath;
- (ProfilesData *)data;
- (void)saveData;
- (void)deleteDoc;

@end
