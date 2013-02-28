//
//  ProfilesDoc.h
//  commotion-meshbook
//
//  Created by Brad : Scal.io, LLC - http://scal.io
//

#import "ProfilesDoc.h"
#import "ProfilesData.h"
#import "ProfilesDatabase.h"

#define kDataKey        @"Data"
#define kDataFile       @"data.plist"

@implementation ProfilesDoc

@synthesize data = _data;


//==========================================================
#pragma mark Init
//==========================================================
- (id)init {
    if ((self = [super init])) {
    }
    return self;
}

- (id)initWithDocPath:(NSString *)docPath {
    if ((self = [super init])) {
        self.docPath = docPath;
    }
    return self;
}

- (id)initWithSSID:(NSString*)ssid bssid:(NSString*)bssid channel:(NSString*)channel ip:(NSString*)ip ipgenerate:(NSString*)ipgenerate netmask:(NSString*)netmask dns:(NSString*)dns
{
    if ((self = [super init])) {
        
        _data = [[ProfilesData alloc] initWithSSID:ssid bssid:bssid channel:channel ip:ip ipgenerate:ipgenerate netmask:netmask dns:dns]; 
    }
    return self;
}


//==========================================================
#pragma mark Manage Data
//==========================================================

/** Create the path to which we'll save data **/
- (BOOL)createDataPath {
    
    if (self.docPath == nil) {
        self.docPath = [ProfilesDatabase nextProfilesDocPath];
    }
    
    NSError *error;
    BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:self.docPath withIntermediateDirectories:YES attributes:nil error:&error];
    if (!success) {
        NSLog(@"Error creating data path: %@", [error localizedDescription]);
    }
    return success;
    
}

/** Get archived data FROM data store **/
- (ProfilesData *)data {
        
    //NSLog(@"%s-profilesData: %@", __FUNCTION__, _data);
    
    if (_data != nil) return _data;
    
    NSString *dataPath = [self.docPath stringByAppendingPathComponent:kDataFile];
    NSData *codedData = [[NSData alloc] initWithContentsOfFile:dataPath];
    if (codedData == nil) return nil;
    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:codedData];
    _data = [unarchiver decodeObjectForKey:kDataKey];
    [unarchiver finishDecoding];
    
    return _data;
}

/** Save archived data TO data store **/
- (void)saveData {
    
    if (_data == nil) return;
    
    [self createDataPath];
    
    NSString *dataPath = [self.docPath stringByAppendingPathComponent:kDataFile];
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:_data forKey:kDataKey];
    [archiver finishEncoding];
    [data writeToFile:dataPath atomically:YES];
    
    NSLog(@"DATA SAVED!: %@", _data);
    
}

- (void)deleteDoc {
    
    NSError *error;
    BOOL success = [[NSFileManager defaultManager] removeItemAtPath:self.docPath error:&error];
    if (!success) {
        NSLog(@"Error removing document path: %@", error.localizedDescription);
    }
    
}


@end
