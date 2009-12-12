//
//  StatusRequest.h
//  Status
//
//  Created by zhao lu on 12/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StatusRequest : NSObject {
	NSMutableData		*receivedData;
	NSURLRequest		*theRequest;
	NSURLConnection	*theConnection;
	id							delegate;
	SEL							callback;
	SEL							errorCallback;	
	BOOL						isPost;
	NSString				*requestBody;
}

@property(nonatomic, retain) NSMutableData	*receivedData;
@property(nonatomic, retain) id							delegate;
@property(nonatomic)				 SEL						callback;
@property(nonatomic)				 SEL						errorCallback;

-(void)friends_status:(id)requestDelegate requestSelector:(SEL)requestSelector;
-(void)status_update:(NSString *)status delegate:(id)requestDelegate requestSelector:(SEL)requestSelector;
-(void)request:(NSURL *)url;

@end

