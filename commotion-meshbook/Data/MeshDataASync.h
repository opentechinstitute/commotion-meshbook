//
//  MeshDataSync.h
//  commotion-meshbook
//
//  Created by Brad : Scal.io, LLC - http://scal.io
//

#import <Foundation/Foundation.h>

@interface MeshDataSync : NSOperation <NSURLConnectionDelegate> {
    
	NSOperationQueue *operationQueue;
}

// Object properties
@property (nonatomic, retain) NSURL *downloadURL;
@property (nonatomic, retain) NSMutableData *downloadData;
@property (nonatomic, retain) NSString *downloadPath;
// NSOperation state properties
@property BOOL downloadDone;
@property BOOL executing;
@property BOOL finished;

#pragma mark -
#pragma mark Initialization & Run Loop
-(id) init;
-(void) main;

#pragma mark -
#pragma mark Mesh Data Processing
- (void)processMeshData:(NSMutableData *)responseData;

#pragma mark -
#pragma mark NSURLConnection Delegates
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
- (void) terminateOperation;

#pragma mark -
#pragma mark NSOperation state Delegate methods
- (BOOL)isConcurrent;
- (BOOL)isExecuting;
- (BOOL)isFinished;
@end
