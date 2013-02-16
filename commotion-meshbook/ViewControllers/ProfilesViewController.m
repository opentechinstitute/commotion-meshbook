//
//  ProfilesViewController.m
//  commotion-meshbook
//
//  Created by Brad : Scal.io, LLC - http://scal.io
//

#import "ProfilesViewController.h"
#import "ProfileData.h"

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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"ProfilesViewController" bundle:nil];
    if (self) {
        // Initialization code here.
        
        // Setup sample data
        ProfileData *profile1 = [[ProfileData alloc] initWithSSID:@"Commotion 1" bssid:@"" channel:@"" ip:@"" ipgenerate:@"" netmask:@"" dns:@"" thumbImage:[NSImage imageNamed:@"profileThumb"]];
        ProfileData *profile2 = [[ProfileData alloc] initWithSSID:@"Commotion 2" bssid:@"" channel:@"" ip:@"" ipgenerate:@"" netmask:@"" dns:@"" thumbImage:[NSImage imageNamed:@"profileThumb"]];
        ProfileData *profile3 = [[ProfileData alloc] initWithSSID:@"Commotion 3" bssid:@"" channel:@"" ip:@"" ipgenerate:@"" netmask:@"" dns:@"" thumbImage:[NSImage imageNamed:@"profileThumb"]];
        ProfileData *profile4 = [[ProfileData alloc] initWithSSID:@"Commotion 4" bssid:@"" channel:@"" ip:@"" ipgenerate:@"" netmask:@"" dns:@"" thumbImage:[NSImage imageNamed:@"profileThumb"]];
        
        self.profiles = [NSMutableArray arrayWithObjects:profile1, profile2, profile3, profile4, nil];
        
    }
    
    return self;
}


#pragma mark TableView

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    // Get a new ViewCell
    NSTableCellView *cellView = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
    
    // Since this is a single-column table view, this would not be necessary.
    // But it's a good practice to do it in order by remember it when a table is multicolumn.
    if( [tableColumn.identifier isEqualToString:@"ProfileColumn"] )
    {
        // get data from our model
        ProfileData *profileData = [self.profiles objectAtIndex:row];
        cellView.imageView.image = profileData.thumbImage;
        cellView.textField.stringValue = profileData.ssid;
        return cellView;
    }
    return cellView;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [self.profiles count];
}






-(ProfileData*)selectedProfile
{
    NSInteger selectedRow = [self.profilesTableView selectedRow];
    if( selectedRow >=0 && self.profiles.count > selectedRow )
    {
        ProfileData *selectedProfileRow = [self.profiles objectAtIndex:selectedRow];
        return selectedProfileRow;
    }
    return nil;
    
}

-(void)setDetailInfo:(ProfileData*)profile
{
    NSString *ssid = @"";
    NSString *bssid = @"";
    NSString *channel = @"";
    NSString *ip = @"";
    NSString *ipgenerate = @"";
    NSString *netmask = @"";
    NSString *dns = @"";

    if( profile != nil )
    {
        ssid = profile.ssid;
        bssid = profile.bssid;
        channel = profile.channel;
        ip = profile.ip;
        ipgenerate = profile.ipgenerate;
        netmask = profile.netmask;
        dns = profile.dns;
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
    ProfileData *selectedProfileRow = [self selectedProfile];
    
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
    ProfileData *selectedProfileRow = [self selectedProfile];
    
    if (selectedProfileRow)
    {
        // 2. Get the new profile name from the text field
        selectedProfileRow.ssid = [self.profilesSSIDView stringValue];
        selectedProfileRow.bssid = [self.profilesBSSIDView stringValue];
        selectedProfileRow.channel = [self.profilesChannelView stringValue];
        selectedProfileRow.ip = [self.profilesIPView stringValue];
        selectedProfileRow.ipgenerate = [self.profilesIPGenerateView stringValue];
        selectedProfileRow.netmask = [self.profilesNetmaskView stringValue];
        selectedProfileRow.dns = [self.profilesDNSView stringValue];
        
        // 3. Update the cell
        NSIndexSet * indexSet = [NSIndexSet indexSetWithIndex:[self.profiles indexOfObject:selectedProfileRow]];
        NSIndexSet * columnSet = [NSIndexSet indexSetWithIndex:0];
        [self.profilesTableView reloadDataForRowIndexes:indexSet columnIndexes:columnSet];
    }
}

- (IBAction)addProfile:(id)sender {
    
    // 1. Create a new ProfileData object with a default name
    ProfileData *newProfile = [[ProfileData alloc] initWithSSID:@"New Mesh Network Name" bssid:@"" channel:@"" ip:@"" ipgenerate:@"" netmask:@"" dns:@"" thumbImage:[NSImage imageNamed:@"profileThumb"]];
    
    // 2. Add the new profile object to our model (insert into the array)
    [self.profiles addObject:newProfile];
    NSInteger newRowIndex = self.profiles.count-1;
    
    // 3. Insert new row in the table view
    [self.profilesTableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:newRowIndex] withAnimation:NSTableViewAnimationEffectGap];
    
    // 4. Select the new profile and scroll to make sure it's visible
    [self.profilesTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:newRowIndex] byExtendingSelection:NO];
    [self.profilesTableView scrollRowToVisible:newRowIndex];
}

- (IBAction)deleteProfile:(id)sender {
    
    // 1. Get selected profile
    ProfileData *selectedProfileRow = [self selectedProfile];
    
    if (selectedProfileRow)
    {
        // 2. Remove the profile from the model
        [self.profiles removeObject:selectedProfileRow];
        
        // 3. Remove the selected row from the table view.
        [self.profilesTableView removeRowsAtIndexes:[NSIndexSet indexSetWithIndex:self.profilesTableView.selectedRow] withAnimation:NSTableViewAnimationSlideUp];
        
        // Clear detail info
        [self setDetailInfo:nil];
    }
}

/**
 - (IBAction)saveData:(id)sender {
 }
 **/









#pragma mark MASPreferencesViewController

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
