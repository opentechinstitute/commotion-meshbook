//
//  ProfilesDatabase.m
//  commotion-meshbook
//
//  Created by Brad : Scal.io, LLC - http://scal.io
//

#import "ProfilesDatabase.h"
#import "ProfilesDoc.h"

@implementation ProfilesDatabase


//==========================================================
#pragma mark Database (Class Methods)
//==========================================================

/** get directory where plist profiles are stored - if no exist, create the dir **/
+ (NSString *)getPrivateDocsDir {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"Meshbook Profiles"];
    
    NSError *error;
    [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:&error];
    
    return documentsDirectory;
    
}

/** read-in stored profiles from plist in given directory **/
+ (NSMutableArray *)loadProfilesDocs {
    
    // Get private docs dir
    NSString *documentsDirectory = [ProfilesDatabase getPrivateDocsDir];
    NSLog(@"Loading profiles from %@", documentsDirectory);
    
    // Get contents of documents directory
    NSError *error;
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:&error];
    if (files == nil) {
        NSLog(@"Error reading contents of documents directory: %@", [error localizedDescription]);
        return nil;
    }
    
    // Create a ProfileDoc for each plist file
    NSMutableArray *retval = [NSMutableArray arrayWithCapacity:files.count];
    for (NSString *file in files) {
        
        // plist files will look like "1.profile, 2.profile, 3.profile ..."
        if ([file.pathExtension compare:@"profile" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:file];
            ProfilesDoc *doc = [[ProfilesDoc alloc] initWithDocPath:fullPath];
        
            [retval addObject:doc];
        }
    }
    
    return retval;
}

+ (NSString *)nextProfilesDocPath {
        
    // Get private docs dir
    NSString *documentsDirectory = [ProfilesDatabase getPrivateDocsDir];
    
    // Get contents of documents directory
    NSError *error;
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:&error];
    if (files == nil) {
        NSLog(@"Error reading contents of documents directory: %@", [error localizedDescription]);
        return nil;
    }
    
    // Search for an available name
    int maxNumber = 0;
    for (NSString *file in files) {
        if ([file.pathExtension compare:@"profile" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            NSString *fileName = [file stringByDeletingPathExtension];
            maxNumber = MAX(maxNumber, fileName.intValue);
        }
    }
    
    // Get available name
    NSString *availableName = [NSString stringWithFormat:@"%d.profile", maxNumber+1];
    return [documentsDirectory stringByAppendingPathComponent:availableName];
}

/** wipe the contents of the profiles directory **/
+ (void)wipeAllProfilesDocs {
    
    // Get path of profiles directory
    NSString *documentsDirectory = [ProfilesDatabase getPrivateDocsDir];
    NSLog(@"Loading profiles from %@", documentsDirectory);
    
    // Get contents of documents directory
    NSError *error;
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:&error];
    if (files == nil) {
        NSLog(@"Error reading contents of documents directory: %@", [error localizedDescription]);
    }
    
    // Iterate through each profile path to remove
    for (NSString *file in files) {
        
        NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:file];
        
        BOOL success = [[NSFileManager defaultManager] removeItemAtPath:fullPath error:&error];
        if (success) {
            //NSLog(@"Removed file: %@", file);
        }
        else {
            NSLog(@"Error removing document path: %@", error.localizedDescription);
        }
    }
    
}


@end
