//
//  ProfilesViewController.h
//  commotion-meshbook
//
//  Created by Brad : Scal.io, LLC - http://scal.io
//

#import "MASPreferencesViewController.h"

@interface ProfilesViewController : NSViewController <MASPreferencesViewController>

@property (strong) NSMutableArray *profiles;

- (IBAction)addProfile:(id)sender;
- (IBAction)deleteProfile:(id)sender;
- (IBAction)profileDidEndEdit:(id)sender;
- (IBAction)clearUserDefaults: (id)sender;

@end
