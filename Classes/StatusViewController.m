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
	self.view = view;
    self.statusView = view;
	
    [view release];	
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

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
	
	//	NSDictionary *results = [status JSONValue];
	//	NSArray *values = [results allValues];
	//	for(NSArray *value in values) {
	//		[contactStats addObject:value];
	//	}
	
	NSLog(@"Combined stat %@", stat);
	
	[self.statusView.contactStatusView reloadData];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	
	return YES;
}

@end
