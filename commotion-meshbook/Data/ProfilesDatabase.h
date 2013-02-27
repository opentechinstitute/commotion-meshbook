//
//  ProfilesDatabase.h
//  commotion-meshbook
//
//  Created by Brad : Scal.io, LLC - http://scal.io
//

#import <Foundation/Foundation.h>

@interface ProfilesDatabase : NSObject

#pragma mark -
#pragma mark Database (Class Methods)

+ (NSMutableArray *)loadProfilesDocs;
+ (NSString *)nextProfilesDocPath;
+ (void)wipeAllProfilesDocs;

@end
