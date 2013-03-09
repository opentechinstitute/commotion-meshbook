//  ====================================================================== 	//
//  BLAuthentication.h														//
//  																		//
//  Last Modified on Tuesday April 24 2001									//
//  Copyright 2001 Ben Lachman
//
//  Updated again in 2013 by Bradley Greenwood
//																			//
//	Thanks to Brian R. Hill <http://personalpages.tds.net/~brian_hill/>		//
//  ====================================================================== 	//

#import <Cocoa/Cocoa.h>
#import <Security/Authorization.h>

@interface BLAuthentication : NSObject 
{
	AuthorizationRef authorizationRef; 
}
// returns a shared instance of the class
+ sharedInstance;
// checks if user is authentcated forCommands
- (BOOL)isAuthenticated:(NSArray *)forCommands;
// authenticates user forCommands
- (BOOL)authenticate:(NSArray *)forCommands;
// deauthenticates user
- (void)deauthenticate;
// gets the pid forProcess
- (int)getPID:(NSString *)forProcess;
// executes pathToCommand with privileges
- (BOOL)executeCommand:(NSString *)pathToCommand withArgs:(NSArray *)arguments andType:(NSString*)type andMessage:(NSString*)message;

+ (void)postNotification:(NSNotification *)aNotification;
+ (void)postAlert:(NSNotification *)aAlert;

//-(BOOL)executeKillallCommand:(NSString *)pathToCommand withArgs:(NSArray *)arguments andType:(NSString*)type;
// kills the process specified by commandFromPS
//- (BOOL)killProcess:(NSString *)commandFromPS;


@end

// strings for notification center
extern NSString* BLAuthenticatedNotification;
extern NSString* BLDeauthenticatedNotification;
// brads
extern NSString* BLshellCommandExecuteSuccessNotification;
extern NSString* BLshellCommandExecuteFailureNotification;


