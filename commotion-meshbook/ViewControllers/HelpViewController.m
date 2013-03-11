//
//  HelpViewController.m
//  commotion-meshbook
//
//  Created by Brad : Scal.io, LLC - http://scal.io
//

#import "HelpViewController.h"

@implementation HelpViewController


//==========================================================
#pragma mark Init
//==========================================================

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"HelpViewController" bundle:nil];
    if (self) {
        

    }
    
    return self;
}

//==========================================================
#pragma mark 
//==========================================================










//==========================================================
#pragma mark MASPreferencesViewController
//==========================================================

- (NSString *)identifier
{
    return @"View Help";
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
