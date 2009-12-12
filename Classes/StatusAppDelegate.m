//
//  StatusAppDelegate.m
//  Status
//
//  Created by zhao lu on 12/11/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "StatusAppDelegate.h"
#import "StatusView.h"

@implementation StatusAppDelegate

@synthesize window, statusViewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    

    // Override point for customization after application launch
	StatusViewController *controller = [[StatusViewController alloc] init];
	self.statusViewController = controller;
	[controller release];
	
	statusViewController.view.frame = [UIScreen mainScreen].applicationFrame;
	[window addSubview:[statusViewController view]];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
