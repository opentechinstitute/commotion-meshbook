//
//  ProfilesViewController.m
//  commotion-meshbook
//
//  Created by Brad : Scal.io, LLC - http://scal.io
//

#import "ProfilesViewController.h"
#import "ProfilesDoc.h"
#import "ProfilesData.h"
#import "ProfilesDatabase.h"

@interface ProfilesViewController ()

@property (assign) IBOutlet NSTableView *profilesTableView;
@property (assign) IBOutlet NSTextField *profilesSSIDView;
@property (assign) IBOutlet NSTextField *profilesBSSIDView;
@property (assign) IBOutlet NSTextField *profilesChannelView;
@property (assign) IBOutlet NSTextField *profilesIPView;
@property (assign) IBOutlet NSTextField *profilesIPGenerateView;
@property (assign) IBOutlet NSTextField *profilesNetmaskView;
@property (assign) IBOutlet NSTextField *profilesDNSView;
@property (assign) IBOutlet NSButton *deleteButton;

@end

@implementation ProfilesViewController

//==========================================================
#pragma mark Init
//==========================================================

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"ProfilesViewController" bundle:nil];
    if (self) {
        
        // load all profiles from our data store
        self.profiles = [ProfilesDatabase loadProfilesDocs];
    
        //NSLog(@"%s-profiles: %@", __FUNCTION__, self.profiles);
        //self.profiles = [[NSMutableArray alloc] init];
        //NSLog(@"self.profiles: %@", self.profiles);
        
        // get default profile set OLD BEFORE DATA STORE
        //ProfilesData *profilesData = [[ProfilesData alloc] init];
        //self.profiles = [profilesData profileDefaults];
        
    }
    
    return self;
}


//==========================================================
#pragma mark TableView
//==========================================================

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    //NSLog(@"%s-row: %lu", __FUNCTION__, row);
    
    // Get a new ViewCell
    NSTableCellView *cellView = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
    
    // Since this is a single-column table view, this would not be necessary.
    // But it's a good practice to do it in order by remember it when a table is multicolumn.
    if( [tableColumn.identifier isEqualToString:@"ProfileColumn"] )
    {
        // get data from our model
        ProfilesDoc *profilesDoc = [self.profiles objectAtIndex:row];
        cellView.imageView.image = [NSImage imageNamed:@"profileThumb"];
        cellView.textField.stringValue = profilesDoc.data.ssid;
        return cellView;
    }
    
    return cellView;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    
    //NSLog(@"[self.profiles count]: %lu", [self.profiles count]);

    return [self.profiles count];
}

-(ProfilesDoc*)selectedProfile
{
    NSInteger selectedRow = [self.profilesTableView selectedRow];
    
    if( selectedRow >=0 && self.profiles.count > selectedRow )
    {
        ProfilesDoc *selectedProfileRow = [self.profiles objectAtIndex:selectedRow];
                
        return selectedProfileRow;
    }
    return nil;
    
}

-(void)setDetailInfo:(ProfilesDoc*)profile
{
    
    //NSLog(@"%s-ssid: %@", __FUNCTION__, profile.data.ssid);
    
    NSString *ssid = @"";
    NSString *bssid = @"";
    NSString *channel = @"";
    NSString *ip = @"";
    NSString *ipgenerate = @"";
    NSString *netmask = @"";
    NSString *dns = @"";

    if( profile != nil )
    {
        ssid = profile.data.ssid;
        bssid = profile.data.bssid;
        channel = profile.data.channel;
        ip = profile.data.ip;
        ipgenerate = profile.data.ipgenerate;
        netmask = profile.data.netmask;
        dns = profile.data.dns;
    }
    
    [self.profilesSSIDView setStringValue:ssid];
    [self.profilesBSSIDView setStringValue:bssid];
    [self.profilesChannelView setStringValue:channel];
    [self.profilesIPView setStringValue:ip];
    [self.profilesIPGenerateView setStringValue:ipgenerate];
    [self.profilesNetmaskView setStringValue:netmask];
    [self.profilesDNSView setStringValue:dns];
    
}

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification
{
    ProfilesDoc *selectedProfileRow = [self selectedProfile];
    
    //NSLog(@"%s-ssid: %@", __FUNCTION__, selectedProfileRow.data.ssid);
    
    // Update info
    [self setDetailInfo:selectedProfileRow];
    
    // Enable/Disable buttons based on selection
    BOOL buttonsEnabled = (selectedProfileRow != nil);
    [self.deleteButton setEnabled:buttonsEnabled];
    [self.profilesSSIDView setEnabled:buttonsEnabled];
    [self.profilesBSSIDView setEnabled:buttonsEnabled];
    [self.profilesChannelView setEnabled:buttonsEnabled];
    [self.profilesIPView setEnabled:buttonsEnabled];
    [self.profilesIPGenerateView setEnabled:buttonsEnabled];
    [self.profilesNetmaskView setEnabled:buttonsEnabled];
    [self.profilesDNSView setEnabled:buttonsEnabled];
}

- (IBAction)profileDidEndEdit:(id)sender {
    
    // 1. Get selected profile
    ProfilesDoc *selectedProfileRow = [self selectedProfile];
        
    if (selectedProfileRow)
    {
        
        //NSLog(@"%s-ssid: %@", __FUNCTION__, selectedProfileRow.data.ssid);

        
        // 2. Get the new profile name from the text field
        selectedProfileRow.data.ssid = [self.profilesSSIDView stringValue];
        selectedProfileRow.data.bssid = [self.profilesBSSIDView stringValue];
        selectedProfileRow.data.channel = [self.profilesChannelView stringValue];
        selectedProfileRow.data.ip = [self.profilesIPView stringValue];
        selectedProfileRow.data.ipgenerate = [self.profilesIPGenerateView stringValue];
        selectedProfileRow.data.netmask = [self.profilesNetmaskView stringValue];
        selectedProfileRow.data.dns = [self.profilesDNSView stringValue];
        
        // 3. Update the cell
        NSIndexSet * indexSet = [NSIndexSet indexSetWithIndex:[self.profiles indexOfObject:selectedProfileRow]];
        NSIndexSet * columnSet = [NSIndexSet indexSetWithIndex:0];
        [self.profilesTableView reloadDataForRowIndexes:indexSet columnIndexes:columnSet];
        
        // 4. Save data to file
        [selectedProfileRow saveData];
    }
    
}

- (IBAction)addProfile:(id)sender {
    
    // 1. Create a new ProfilesData object with a default name
    ProfilesDoc *newProfile = [[ProfilesDoc alloc] initWithSSID:@"New Mesh Network Name" bssid:@"a" channel:@"b" ip:@"c" ipgenerate:@"d" netmask:@"e" dns:@"f"];
    
    //NSLog(@"%s-newProfile SSID: %@", __FUNCTION__, newProfile.data.ssid);
    
    // 2. Add the new profile object to our model (insert into the array)
    [self.profiles addObject:newProfile];
    
    NSInteger newRowIndex = self.profiles.count-1;
    
    // 3. Insert new row in the table view
    [self.profilesTableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:newRowIndex] withAnimation:NSTableViewAnimationEffectGap];
    
    // 4. Select the new profile and scroll to make sure it's visible
    [self.profilesTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:newRowIndex] byExtendingSelection:NO];
    [self.profilesTableView scrollRowToVisible:newRowIndex];
}

- (IBAction)addDefaultProfiles:(id)sender {
    
    // DELETE ALL EXISTING PROFILES
    // first we blow away plist data from the doc path -- should probably pop a confirmation page here
    [ProfilesDatabase wipeAllProfilesDocs];
    
    // next we remove all rows from our table
    [self.profiles removeAllObjects];
    [self.profilesTableView reloadData];

    // ADD DEFAULT PROFILES
    // Setup sample data
    ProfilesDoc *profile1 = [[ProfilesDoc alloc] initWithSSID:@"commotionwireless.net" bssid:@"02:CA:FF:EE:BA:BE" channel:@"5" ip:@"172.29.0.0" ipgenerate:@"true" netmask:@"255.255.0.0" dns:@"8.8.8.8"];
    ProfilesDoc *profile2 = [[ProfilesDoc alloc] initWithSSID:@"Commotion Test 1" bssid:@"01:CA:FF:EE:BA:BE" channel:@"3" ip:@"5.0.0.0" ipgenerate:@"false" netmask:@"255.255.255.255" dns:@"8.8.8.8"];
    ProfilesDoc *profile3 = [[ProfilesDoc alloc] initWithSSID:@"Commotion Test 2" bssid:@"01:CA:FF:EE:BB:BE" channel:@"10" ip:@"5.0.0.10" ipgenerate:@"false" netmask:@"255.255.255.255" dns:@"8.8.8.8"];
    NSMutableArray *defaultProfiles = [NSMutableArray arrayWithObjects:profile1, profile2, profile3, nil];
    
    // wipe our current profiles array
    self.profiles = [[NSMutableArray alloc] init];
    
    // loop through our given default profiles to add each row to the table
    for (int i = 0; i < [defaultProfiles count]; i++) {

        // 1. Add the new profile object to our model (insert from the array)
        [self.profiles addObject:[defaultProfiles objectAtIndex: i]];
        
        // 2. Get the last index position available for insertion
        NSInteger newRowIndex = self.profiles.count-1;
        
        // 3. Insert new row in the table view
        [self.profilesTableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:newRowIndex] withAnimation:NSTableViewAnimationEffectGap];
        
        // 4. Select the new profile and scroll to make sure it's visible
        [self.profilesTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:newRowIndex] byExtendingSelection:NO];
        //[self.profilesTableView scrollRowToVisible:newRowIndex];
        
        // 5. Save the default profile we just added
        [self profileDidEndEdit:nil];
    }
    
}

- (IBAction)deleteProfile:(id)sender {
    
    // 1. Get selected profile
    ProfilesDoc *selectedProfileRow = [self selectedProfile];
    
    if (selectedProfileRow)
    {
        // 2. Remove the profile from the array
        [self.profiles removeObject:selectedProfileRow];
        
        // 3. Remove the selected row from the table view.
        [self.profilesTableView removeRowsAtIndexes:[NSIndexSet indexSetWithIndex:self.profilesTableView.selectedRow] withAnimation:NSTableViewAnimationSlideUp];
        
        // 4. Delete the row from the database (plist directory)
        [selectedProfileRow deleteDoc];
        
        // Clear detail info
        [self setDetailInfo:nil];
    }
}

//==========================================================
#pragma mark MASPreferencesViewController
//==========================================================

- (NSString *)identifier
{
    return @"Profiles";
}

- (NSImage *)toolbarItemImage
{
    return [NSImage imageNamed:@"tabProfiles"];
}

- (NSString *)toolbarItemLabel
{
    return NSLocalizedString(@"Profiles", @"Toolbar item name for the Profiles pane");
}


@end
