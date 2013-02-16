//
//  HelpViewController.m
//  commotion-meshbook
//
//  Created by Brad : Scal.io, LLC - http://scal.io
//

#import "HelpViewController.h"

@implementation HelpViewController

- (id)init
{
    return [super initWithNibName:@"HelpViewController" bundle:nil];
}

#pragma mark -
#pragma mark MASPreferencesViewController

- (NSString *)identifier
{
    return @"Help";
}

- (NSImage *)toolbarItemImage
{
    return [NSImage imageNamed:@"tabHelp"];
}

- (NSString *)toolbarItemLabel
{
    return NSLocalizedString(@"Help", @"Toolbar item name for the Help pane");
}

@end
