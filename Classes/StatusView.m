//
//  StatusView.m
//  Status
//
//  Created by zhao lu on 12/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "StatusView.h"
#import	"StatusAppDelegate.h"

@implementation StatusView

@synthesize statusViewController, myStatusView, contactStatusView, statusButton;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		self.myStatusView = [[[UITextField alloc] initWithFrame:CGRectMake(5, 5, 240, 25)] autorelease];
		self.myStatusView.font = [UIFont fontWithName:@"Helvetica" size:14];
		[self.myStatusView setBorderStyle:UITextBorderStyleRoundedRect];
		self.myStatusView.returnKeyType = UIReturnKeyDone;
		self.myStatusView.clearButtonMode = UITextFieldViewModeWhileEditing;
		self.myStatusView.placeholder = @"What is your status?";
		[self addSubview:myStatusView];
		
		self.statusButton = [[[UIButton alloc] initWithFrame:CGRectMake(250, 5, 65, 25)] autorelease];
		//self.statusButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[self.statusButton setTitle:@"Update" forState:UIControlStateNormal & UIControlStateHighlighted & UIControlStateSelected];
		[self.statusButton setTitleColor:[UIColor blackColor] forState:UIControlEventTouchDown];
		[self.statusButton setBackgroundColor:[UIColor orangeColor]];
		[self addSubview:self.statusButton];
		
		self.contactStatusView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, 340, 400) style:UITableViewStylePlain];
		self.contactStatusView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
		[self.contactStatusView reloadData];
		[self addSubview:self.contactStatusView];
	}
    return self;
}

- (void)dealloc {
	[myStatusView release];
	[statusButton release];
	[contactStatusView release];
    [super dealloc];
}

@end
