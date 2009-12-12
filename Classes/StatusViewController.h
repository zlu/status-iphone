//
//  StatusViewController.h
//  Status
//
//  Created by zhao lu on 12/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StatusView.h"

@class StatusView;

@interface StatusViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
	StatusView *statusView;
	
	NSArray *contactStatus;
	NSMutableArray *contactStats;
}

@property (nonatomic, assign) IBOutlet StatusView *statusView;
@property (nonatomic, retain) NSArray *contactStatus;
@property (nonatomic, retain) NSMutableArray *contactStats;

- (void)friends_status_callback:(NSData *)data;

@end
