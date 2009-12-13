//
//  StatusRequest.m
//  Status
//
//  Created by zhao lu on 12/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "StatusRequest.h"

@implementation StatusRequest

@synthesize receivedData;
@synthesize	delegate;
@synthesize callback;
@synthesize errorCallback;

-(void)friends_status:(id)requestDelegate requestSelector:(SEL)requestSelector {
	// Set the delegate and selector
	self.delegate = requestDelegate;
	self.callback = requestSelector;
	// The URL of the Status request we intend to send
	NSURL * url = [NSURL URLWithString:@"http://phonestat.com/statuses/get_contact_status?user_id=5&format=json"];
	[self request:url];
}

-(void)status_update:(NSString *)status latitude:(NSString *)latitude longitude:(NSString *)longitude delegate:(id)requestDelegate requestSelector:(SEL)requestSelector; {
	isPost = YES;
	// Set the delegate and selector
	self.delegate = requestDelegate;
	self.callback = requestSelector;
	// the URL of the Status request we intend to send
	if (latitude == nil) {
		latitude = @"";
	}
	
	if (longitude == nil) {
		longitude = @"";
	}
	
	NSString *encodedStatus = [status stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSString *withLocation = [status stringByAppendingFormat:@"&status[latitude]=%@&status[longitude]=%@", latitude, longitude];
	NSURL *url = [NSURL URLWithString:[@"http://phonestat.com/statuses?format=json&user_id=5&status[type]=CustomStatus&status[stat]=" stringByAppendingString:withLocation]];
	requestBody = [NSString	stringWithFormat:@"status=%@", status];
	[self request:url];
}

-(void)request:(NSURL *)url {
	theRequest = [[NSMutableURLRequest alloc] initWithURL:url];
	
	if (isPost) {
		NSLog(@"isPost");
		[theRequest setHTTPMethod:@"POST"];
		[theRequest setValue:@"application/x-www-form_urlencoded" forHTTPHeaderField:@"Content-Type"];
		[theRequest setHTTPBody:[requestBody dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES]];
		[theRequest setValue:[NSString stringWithFormat:@"%d", [requestBody length]] forHTTPHeaderField:@"Content-Length"];
	}
	
	theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	
	if (theConnection) {
		// Create the NSMutableData that will hold the receivedData
		receivedData = [[NSMutableData data] retain];
	} else {
		// inform the user that the request could not be made		
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[receivedData setLength:0];	
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[connection release];
	[receivedData release];
	[theRequest release];
	
	// inform the user
	NSLog(@"Connection failed! Error - %@ %@",
		  [error localizedDescription],
		  [[error userInfo] objectForKey:NSErrorFailingURLStringKey]);
	
	if (errorCallback) {
		[delegate performSelector:errorCallback withObject:error];
	}
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	if (delegate && callback) {
		if ([delegate respondsToSelector:self.callback]) {
			[delegate performSelector:self.callback withObject:receivedData];
		} else {
			NSLog(@"No response from delegate");
		}
	}
	
	[theConnection release];
	[receivedData release];
	[theRequest release];
}

@end
