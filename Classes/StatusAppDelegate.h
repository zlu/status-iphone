//
//  StatusAppDelegate.h
//  Status
//
//  Created by zhao lu on 12/11/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StatusViewController;

@interface StatusAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	StatusViewController *statusViewController;
	
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) StatusViewController *statusViewController;

@end

