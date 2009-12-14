//
//  StatusViewController.m
//  Status
//
//  Created by zhao lu on 12/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "StatusViewController.h"
#import	"StatusView.h"
#import "StatusRequest.h"
#import "JSON/JSON.h"

@implementation StatusViewController

@synthesize statusView, contactStats, contactStatus;
@synthesize locationManager, locationMeasurements, bestEffortAtLocation;
//@synthesize audioRecorder;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {	
  //	self.wantsFullScreenLayout = YES;
	StatusRequest *statusRequest = [[StatusRequest alloc] init];
	NSLog(@"Getting friends status for user");
	contactStatus = [[NSArray alloc] init];
	contactStats = [[NSMutableArray alloc] init];
	[statusRequest friends_status:self requestSelector:@selector(friends_status_callback:)];
	
	StatusView *view = [[StatusView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
	view.statusViewController = self;
	view.contactStatusView.delegate = self;
	view.contactStatusView.dataSource = self;
	view.myStatusView.delegate = self;
	
	self.view = view;
	self.statusView = view;
	
	[view release];	
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.locationManager = [[[CLLocationManager alloc] init] autorelease];
	self.locationManager.delegate = self;
	// This is the most important property to set for the manager. It ultimately determines how the manager will
	// attempt to acquire location and thus, the amount of power that will be consumed.
	//locationManager.desiredAccuracy = [NSNumber numberWithDouble:kCLLocationAccuracyThreeKilometers];
	// Once configured, the location manager must be "started".
	//[self.locationManager startUpdatingLocation];
	
	[self createAVAudioRecorder];

}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[self.locationManager release];
	[self.locationMeasurements release];
	[self.bestEffortAtLocation release];
	[self.statusView release];
	
	[super dealloc];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [contactStats count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return @"Contact Status";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *MyIdentifier = @"MyIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if(cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier] autorelease];
	}
	
	cell.textLabel.font = [UIFont systemFontOfSize:13.0];
	
	NSDictionary *dict = [contactStats objectAtIndex:indexPath.row];
	for(id key in dict) {
		NSString *stat = [[dict objectForKey:key] objectForKey:@"stat"];
		cell.textLabel.text = stat;
	}
	return cell;
}

- (void) friends_status_callback:(NSData *)data {
	NSString *status = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
	NSLog(@"Friend status %@", status);
	
	SBJSON *jsonParser = [SBJSON new];
	contactStatus = [jsonParser objectWithString:status];
	NSMutableString *stat = [NSMutableString stringWithString:@"Friend Status:\n"];
	for (int i=0; i<[contactStatus count]; i++) {		
		NSString * s = [contactStatus objectAtIndex:i];
		[stat appendFormat:@"%@\n", s];
		[contactStats addObject:s];
	}
	
	NSLog(@"Combined stat %@", stat);
	
	[self.statusView.contactStatusView reloadData];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	NSLog(@"Updating status for user");
	
	//[statusRequest friends_status:self requestSelector:@selector(friends_status_callback:)];
	
  //[statusRequest status_update:@"foo bar status" delegate:self requestSelector:@selector(status_update_callback:)];
	
	return YES;
}

- (IBAction) postStatus:(id)sender {
	[self.locationManager startUpdatingLocation];
}

- (void)postStatusWithLocation:(CLLocation *)location {
	NSLog(@"posting status");
	NSString *status = [statusView.myStatusView text];
	NSString *latitude = [NSString stringWithFormat:@"%3.5f", location.coordinate.latitude];
	NSString *longitude = [NSString stringWithFormat:@"%3.5f", location.coordinate.longitude];
	StatusRequest *statusRequest = [[StatusRequest alloc] init];
	
	if([status length] == 0) {
		NSLog(@"The status is empty, nothing to post");
	  return;
	}
	
	[statusRequest status_update:status latitude:latitude longitude:longitude delegate:self requestSelector:@selector(status_update_callback:)];	
	
}

- (void) status_update_callback:(NSData *)data {
	NSString *status = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
	NSLog(@"Status update callback %@", status);	
	SBJSON *jsonParser = [SBJSON new];
	NSDictionary *myStatusDictionary = [[jsonParser objectWithString:status] objectForKey:@"custom_status"];
	NSString *stat = [myStatusDictionary objectForKey:@"stat"];
	NSString *business = [myStatusDictionary objectForKey:@"business"];
	NSString *myStatus = [stat stringByAppendingFormat:@" at %@", business];
	NSLog(@"Combined status %@", myStatus);
	self.statusView.myStatusView.text = myStatus;
}

/*
 * We want to get and store a location measurement that meets the desired accuracy. For this example, we are
 *      going to use horizontal accuracy as the deciding factor. In other cases, you may wish to use vertical
 *      accuracy, or both together.
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	// store all of the measurements, just so we can see what kind of data we might receive
	[self.locationMeasurements addObject:newLocation];
	// test the age of the location measurement to determine if the measurement is cached
	// in most cases you will not want to rely on cached measurements
	NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
	if (locationAge > 5.0) return;
	// test that the horizontal accuracy does not indicate an invalid measurement
	if (newLocation.horizontalAccuracy < 0) return;
	// test the measurement to see if it is more accurate than the previous measurement
	if (bestEffortAtLocation == nil || bestEffortAtLocation.horizontalAccuracy < newLocation.horizontalAccuracy) {
		// store the location as the "best effort"
		self.bestEffortAtLocation = newLocation;
		// test the measurement to see if it meets the desired accuracy
		//
		// IMPORTANT!!! kCLLocationAccuracyBest should not be used for comparison with location coordinate or altitidue 
		// accuracy because it is a negative value. Instead, compare against some predetermined "real" measure of 
		// acceptable accuracy, or depend on the timeout to stop updating. This sample depends on the timeout.
		//
		if (newLocation.horizontalAccuracy <= locationManager.desiredAccuracy) {
			// we have a measurement that meets our requirements, so we can stop updating the location
			// 
			// IMPORTANT!!! Minimize power usage by stopping the location manager as soon as possible.
			//
			[self.locationManager stopUpdatingLocation];
			// we can also cancel our previous performSelector:withObject:afterDelay: - it's no longer necessary
			[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopUpdatingLocation:) object:nil];
		}
	}
	// update the display with the new location data
	[self postStatusWithLocation:newLocation];   
	[self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	// The location "unknown" error simply means the manager is currently unable to get the location.
	// We can ignore this error for the scenario of getting a single location fix, because we already have a 
	// timeout that will stop the location manager to save power.
	if ([error code] != kCLErrorLocationUnknown) {
		[self.locationManager stopUpdatingLocation];
	}
}

- (NSString *) documentsPath {
	if (! _documentsPath) {
		NSArray *searchPaths =
		NSSearchPathForDirectoriesInDomains
		(NSDocumentDirectory, NSUserDomainMask, YES);
		_documentsPath = [searchPaths objectAtIndex: 0];
		[_documentsPath retain];
	}
	return _documentsPath;
}

- (NSError *) createAVAudioRecorder {
	[audioRecorder release];
	audioRecorder = nil;
	
	NSString *destinationString = [[self documentsPath] stringByAppendingPathComponent:@"vmgreeting"];
	NSURL *destinationURL = [NSURL fileURLWithPath:destinationString];
	
	NSMutableDictionary *recordSettings = [[NSMutableDictionary alloc] initWithCapacity:10];
	[recordSettings setObject:[NSNumber numberWithInt: kAudioFormatLinearPCM] forKey: AVFormatIDKey];
	[recordSettings setObject:[NSNumber numberWithFloat:44100.0] forKey: AVSampleRateKey]; 
	[recordSettings setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
	[recordSettings setObject:[NSNumber numberWithBool:FALSE] forKey:AVLinearPCMIsBigEndianKey];
	[recordSettings setObject:[NSNumber numberWithBool:FALSE] forKey:AVLinearPCMIsFloatKey];
	
	NSError *recorderSetupError = nil;
	audioRecorder = [[AVAudioRecorder alloc] initWithURL:destinationURL settings:recordSettings error:&recorderSetupError];
	[recordSettings release];
	
	if(recorderSetupError) {
		UIAlertView *cantRecordAlert = [[UIAlertView alloc] initWithTitle:@"Cannot record" message:@"Please try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[cantRecordAlert show];
		[cantRecordAlert release];
		return recorderSetupError;
	}
	[audioRecorder prepareToRecord];
	audioRecorder.delegate = self;
	
	NSLog (@"error: %@", recorderSetupError);
	return recorderSetupError;
}

- (IBAction) startRecording:(id)sender {
	[audioRecorder record];
}

- (IBAction) stopRecording:(id)sender {
	[audioRecorder stop];
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder
						   successfully:(BOOL)flag {
	NSLog(@"audioRecorderDidfinishRecording:successfully:");
	[audioRecorder release];
	audioRecorder = nil;
	[self createAVAudioPlayer];
	[audioPlayer play];
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder
								   error:(NSError *)error {
	NSLog(@"audioRecorderEncodeErrorDidOccur:error:");
	[audioRecorder release];
	audioRecorder = nil;
}

- (NSError*) createAVAudioPlayer {
	[audioPlayer release];
	audioPlayer = nil;

	[_documentsPath release];
	NSArray *searchPaths =
	NSSearchPathForDirectoriesInDomains
	(NSDocumentDirectory, NSUserDomainMask, YES);
	_documentsPath = [searchPaths objectAtIndex: 0];
	[_documentsPath retain];
	
	NSString *filename = @"vmgreeting";
	NSString *playbackPath =
	[_documentsPath stringByAppendingPathComponent: filename];
	NSURL *playbackURL = [NSURL fileURLWithPath: playbackPath];
	NSError *playerSetupError = nil;
	audioPlayer = [[AVAudioPlayer alloc]
	initWithContentsOfURL:playbackURL error:&playerSetupError];
	
	if (playerSetupError) {
		NSString *errorTitle =
		[NSString stringWithFormat:@"Cannot Play %@:", filename];
		UIAlertView *cantPlayAlert =
		[[UIAlertView alloc] initWithTitle: errorTitle
								   message: [playerSetupError localizedDescription]
								  delegate:nil
						 cancelButtonTitle:@"OK"
						 otherButtonTitles:nil];
		[cantPlayAlert show];
		[cantPlayAlert release]; 
		audioPlayer = nil;
		return playerSetupError;
	}
	
	audioPlayer.delegate = self;
	audioPlayer.meteringEnabled = YES;
	return playerSetupError;
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
	NSLog (@"did finish playing");
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
	UIAlertView *cantPlayAlert =
	[[UIAlertView alloc] initWithTitle: @"Playback error"
							   message: [error localizedDescription]
							  delegate:nil
					 cancelButtonTitle:@"OK"
					 otherButtonTitles:nil];
	[cantPlayAlert show];
	[cantPlayAlert release]; 
}

@end
