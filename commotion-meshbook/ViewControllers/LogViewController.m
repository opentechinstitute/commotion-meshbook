//
//  LogViewController.m
//  commotion-meshbook
//
//  Created by Brad : Scal.io, LLC - http://scal.io
//

#import "LogViewController.h"

@implementation LogViewController

- (id)init
{
    return [super initWithNibName:@"LogViewController" bundle:nil];
}

#pragma mark -
#pragma mark MASPreferencesViewController

- (NSString *)identifier
{
    return @"Log";
}

- (NSImage *)toolbarItemImage
{
    return [NSImage imageNamed:@"tabLog"];
}

- (NSString *)toolbarItemLabel
{
    return NSLocalizedString(@"Log", @"Toolbar item name for the Log pane");
}

@end
