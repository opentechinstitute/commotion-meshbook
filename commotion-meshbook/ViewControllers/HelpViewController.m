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
        
        
        
        // Custom initialization.
        self.view.frame = CGRectMake(0, 0, 825, 625);
        webView = [[WebView alloc] initWithFrame:CGRectMake(25, 25, 775, 575)];
        [webView setUIDelegate:self];
        [self.view addSubview:webView];

        
        NSString *urlStr = @"http://commotionwireless.net/docs";
        [webView setMainFrameURL:urlStr];	// re-target to the new url
        
        //[[webView mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://commotionwireless.net/docs"]]];
    }
    
    return self;
}



- (void)awakeFromNib
{
	[webView setUIDelegate:self];	// be the webView's delegate to capture NSResponder calls
}

//==========================================================
#pragma mark - WebView delegate
//==========================================================

// -------------------------------------------------------------------------------
//	webView:makeFirstResponder
//
//	We want to keep the outline view in focus as the user clicks various URLs.
//
//	So this workaround applies to an unwanted side affect to some web pages that might have
//	JavaScript code thatt focus their text fields as we target the web view with a particular URL.
//
// -------------------------------------------------------------------------------
- (void)webView:(WebView *)sender makeFirstResponder:(NSResponder *)responder
{
    /**
	if (retargetWebView)
	{
		// we are targeting the webview ourselves as a result of the user clicking
		// a url in our outlineview: don't do anything, but reset our target check flag
		//
		retargetWebView = NO;
	}
	else
	{
		// continue the responder chain
		[[self window] makeFirstResponder:sender];
	}
     **/
}

- (void) makeTextSmaller: (id) sender
{
	[webView makeTextSmaller: sender];
}






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
