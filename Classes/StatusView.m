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

@synthesize statusViewController, myStatusView, contactStatusView, statusButton, startRecordButton, stopRecordButton;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		
//		UIImage *image = [UIImage imageNamed:@"minibill.png"]; 
//		CGFloat idealSize = 50.0f; 
//		CGFloat ratio = 1.0f; 
//		CGFloat heightRatio = idealSize / image.size.height; 
//		CGFloat widthRatio = idealSize / image.size.width; 
//		if(heightRatio < widthRatio) {
//			ratio = heightRatio; 
//		} else {
//			ratio = widthRatio;
//		}
		
		//CGRect imageRect = CGRectMake(10.0f, 10.0f, image.size.width * ratio, image.size.height * ratio);
		//CGRect imageRect = CGRectMake(5.0f, 5.0f, 40, 50);
		//[image drawInRect:imageRect blendMode:kCGBlendModeDifference alpha:1.0f];
		//[self addSubview:image];
        
		self.myStatusView = [[[UITextField alloc] initWithFrame:CGRectMake(50, 5, 240, 25)] autorelease];
		self.myStatusView.font = [UIFont fontWithName:@"Helvetica" size:14];
		[self.myStatusView setBorderStyle:UITextBorderStyleRoundedRect];
		self.myStatusView.returnKeyType = UIReturnKeyDone;
		self.myStatusView.clearButtonMode = UITextFieldViewModeWhileEditing;
		self.myStatusView.placeholder = @"What is your status?";
		[self addSubview:myStatusView];
		
		self.statusButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		self.statusButton.frame = CGRectMake(250, 5, 65, 25);			
		[self.statusButton setTitle:@"Update" forState:UIControlStateNormal & UIControlStateHighlighted & UIControlStateSelected];
		[self.statusButton setTitleColor:[UIColor blackColor] forState:UIControlEventTouchDown];
		[self.statusButton addTarget:statusViewController action:@selector(postStatus:)forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:self.statusButton];

		self.startRecordButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		self.startRecordButton.frame = CGRectMake(5, 55, 65, 25);
		[self.startRecordButton setTitle:@"Record" forState:UIControlStateNormal & UIControlStateHighlighted & UIControlStateSelected];
		[self.startRecordButton setTitleColor:[UIColor blackColor] forState:UIControlEventTouchDown];
		[self.startRecordButton addTarget:statusViewController action:@selector(startRecording:)forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:self.startRecordButton];

		self.stopRecordButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		self.stopRecordButton.frame = CGRectMake(80, 55, 65, 25);
		[self.stopRecordButton setTitle:@"Done" forState:UIControlStateNormal & UIControlStateHighlighted & UIControlStateSelected];
		[self.stopRecordButton setTitleColor:[UIColor blackColor] forState:UIControlEventTouchDown];
		[self.stopRecordButton addTarget:statusViewController action:@selector(stopRecording:)forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:self.stopRecordButton];
		
		self.contactStatusView = [[UITableView alloc] initWithFrame:CGRectMake(0, 85, 340, 400) style:UITableViewStylePlain];
		self.contactStatusView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
		[self.contactStatusView reloadData];
		[self addSubview:self.contactStatusView];
	}
    return self;
}

- (void)dealloc {
	[myStatusView release];
	[statusButton release];
	[startRecordButton release];
	[stopRecordButton release];
	[contactStatusView release];
    [super dealloc];
}

@end
