//
//  PPMainViewController.m
//  Propain
//
//  Created by Matt Holcombe on 03/10/2014 @ 16:35 .
//  Copyright (c) 2014 Propain, LLC. All rights reserved.
//

#import "PPMainViewController.h"
#import "PPMapViewController.h"

@interface PPMainViewController () <PPMapViewControllerDelegate>
@property (nonatomic, strong) PPMapViewController *mapViewController;
@end


@implementation PPMainViewController

- (id)init {
	if ((self = [super init])) {
		
	}
	
	return (self);
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (void)dealloc {
	
}

- (BOOL)shouldAutorotate {
	return (NO);
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return (UIStatusBarStyleLightContent);
}


#pragma mark - Data Calls


#pragma mark - View lifecycle
- (void)loadView {
	ViewControllerLog(@"[:|:] [%@ loadView] [:|:]", self.class);
	[super loadView];
	
	UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:([PPAppDelegate isRetina4Inch]) ? @"mainBG-568h@2x" : @"mainBG"]];
	bgImageView.frame = [[UIScreen mainScreen] bounds];
	[self.view addSubview:bgImageView];
}

- (void)viewDidLoad {
	ViewControllerLog(@"[:|:] [%@ viewDidLoad] [:|:]", self.class);
	[super viewDidLoad];
	
	_mapViewController = [[PPMapViewController alloc] init];
	_mapViewController.delegate = self;
	
	[self addChildViewController:_mapViewController];
	[self.view addSubview:_mapViewController.view];
	[_mapViewController didMoveToParentViewController:self];
}

- (void)viewWillAppear:(BOOL)animated {
	ViewControllerLog(@"[:|:] [%@ viewWillAppear:%@] [:|:]", self.class, (animated) ? @"YES" : @"NO");
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	ViewControllerLog(@"[:|:] [%@ viewDidAppear:%@] [:|:]", self.class, (animated) ? @"YES" : @"NO");
	[super viewDidAppear:animated];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"TOGGLE_STATUS_BAR"
														object:@"YES"];
}

- (void)viewWillDisappear:(BOOL)animated {
	ViewControllerLog(@"[:|:] [%@ viewWillDisappear:%@] [:|:]", self.class, (animated) ? @"YES" : @"NO");
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	ViewControllerLog(@"[:|:] [%@ viewDidDisappear:%@] [:|:]", self.class, (animated) ? @"YES" : @"NO");
	[super viewDidDisappear:animated];
}

- (void)viewDidUnload {
	ViewControllerLog(@"[:|:] [%@ viewDidUnload] [:|:]", self.class);
	[super viewDidUnload];
}


#pragma mark - Navigation


#pragma mark - MapViewController Delegates
- (void)mapViewController:(PPMapViewController *)mapViewController didUpdateLocation:(CLLocationCoordinate2D *)locationCoordinate2D {
	NSLog(@"**_[%@ mapViewController:didUpdateLocation:]_**", self.class);
}

@end
