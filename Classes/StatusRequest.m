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
	NSString *withLocation = [encodedStatus stringByAppendingFormat:@"&status[latitude]=%@&status[longitude]=%@", latitude, longitude];
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

- (void)upload_voicemail:(id)requestDelegate requestSelector:(SEL)requestSelector {
	self.delegate = requestDelegate;
	self.callback = requestSelector;
	NSString *urlString = @"http://phonestat.com/updated_voice_status?format=json&user_id=5";
	NSURL *url = [NSURL URLWithString:urlString];
	NSString *filename = @"vmgreeting";
	[self upload:url filename:filename];
}

- (void)upload:(NSURL *)url filename:(NSString *)filename {
	theRequest = [[NSMutableURLRequest alloc] initWithURL:url];
	[theRequest setHTTPMethod:@"POST"];
	NSString *boundary = @"+++++++++++++++++++++++iPhone upload boundary+++++++++++++++++++++++";
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];	
	[theRequest setValue:contentType forHTTPHeaderField:@"Content-Type"];
	
	NSMutableData *postBody = [NSMutableData data];
	[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@\"\r\n", filename] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	_documentsPath = [searchPaths objectAtIndex: 0];
	[_documentsPath retain];
	
	NSString *path = [_documentsPath stringByAppendingPathComponent: filename];
	//NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"image.jpg"]
	NSData *data = [[NSData alloc] initWithContentsOfFile:path];
	[postBody appendData:[NSData dataWithData:data]];
	[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[theRequest setHTTPBody:postBody];
//	[theRequest setValue:[NSString stringWithFormat:@"%d", [requestBody length]] forHTTPHeaderField:@"Content-Length"];
	
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
