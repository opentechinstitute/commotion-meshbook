//
//  ProfilesViewController.h
//  commotion-meshbook
//
//  Created by Brad : Scal.io, LLC - http://scal.io
//

#import "MASPreferencesViewController.h"

@interface ProfilesViewController : NSViewController <MASPreferencesViewController>
{
}

@property (strong) NSMutableArray *profiles;


#pragma mark -
#pragma mark Init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

#pragma mark -
#pragma mark TableView 
- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView;
- (void)tableViewSelectionDidChange:(NSNotification *)aNotification;

- (IBAction)profileDidEndEdit:(id)sender;
- (IBAction)addProfile:(id)sender;
- (IBAction)addDefaultProfiles:(id)sender;
- (IBAction)deleteProfile:(id)sender;


@end
