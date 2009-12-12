//
//  StatusView.h
//  Status
//
//  Created by zhao lu on 12/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StatusViewController.h"

@class StatusViewController;

@interface StatusView : UIView {
	StatusViewController *statusViewController;
	UITextField *myStatusView;
	IBOutlet UIButton *statusButton;
	UITableView *contactStatusView;

}

@property (nonatomic, assign) IBOutlet StatusViewController *statusViewController;
@property (nonatomic, retain) UITextField *myStatusView;
@property (nonatomic, retain) IBOutlet UIButton *statusButton;
@property (nonatomic, retain) UITableView *contactStatusView;

@end
