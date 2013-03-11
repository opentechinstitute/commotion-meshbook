//
//  HelpViewController
//  commotion-meshbook
//
//  Created by Brad : Scal.io, LLC - http://scal.io
//

#import "MASPreferencesViewController.h"
#import <WebKit/WebKit.h>

@interface HelpViewController : NSViewController  <MASPreferencesViewController> {
    	WebView *webView;
}

//@property(nonatomic, retain) WebView *webView;

#pragma mark -
#pragma mark Init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;







@end
