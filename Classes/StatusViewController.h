//
//  StatusViewController.h
//  Status
//
//  Created by zhao lu on 12/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

#import "StatusView.h"

@class StatusView;

@interface StatusViewController : UIViewController <UITableViewDelegate, 
													UITableViewDataSource, 
													UITextFieldDelegate, 
													CLLocationManagerDelegate, 
													AVAudioRecorderDelegate,
													AVAudioPlayerDelegate> {
	StatusView *statusView;
	
	NSArray *contactStatus;
	NSMutableArray *contactStats;
	
	CLLocationManager *locationManager;
	NSMutableArray *locationMeasurements;
	CLLocation *bestEffortAtLocation;
														
	NSString *_documentsPath;
	AVAudioRecorder *audioRecorder;
    AVAudioPlayer *audioPlayer;
}

@property (nonatomic, assign) IBOutlet StatusView *statusView;
@property (nonatomic, retain) NSArray *contactStatus;
@property (nonatomic, retain) NSMutableArray *contactStats;

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) NSMutableArray *locationMeasurements;
@property (nonatomic, retain) CLLocation *bestEffortAtLocation;

@property (nonatomic, retain) IBOutlet UITableView *tableView;

- (IBAction) postStatus:(id)sender;
- (void) postStatusWithLocation:(CLLocation *)location;
- (void) friends_status_callback:(NSData *)data;
- (void) status_update_callback:(NSData *)data;
- (void) upload_voicemail_greeting_callback:(NSData *)data;

- (NSError *) createAVAudioRecorder;
- (IBAction) startRecording:(id)sender;
- (IBAction) stopRecord:(id)sender;
@end
