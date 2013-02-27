//
//  StatusViewController.m
//  commotion-meshbook
//
//  Created by Brad : Scal.io, LLC - http://scal.io
//

#import "StatusViewController.h"

@implementation StatusViewController

- (id)init
{
    return [super initWithNibName:@"StatusViewController" bundle:nil];
}

#pragma mark -
#pragma mark MASPreferencesViewController

- (NSString *)identifier
{
    return @"Show Mesh Status";
}

- (NSImage *)toolbarItemImage
{
    return [NSImage imageNamed:@"tabStatus"];
}

- (NSString *)toolbarItemLabel
{
    return NSLocalizedString(@"Status", @"Toolbar item name for the Status pane");
}

@end
