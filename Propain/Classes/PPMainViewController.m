//
//  PPMainViewController.m
//  Propain
//
//  Created by Matt Holcombe on 03/10/2014 @ 16:35 .
//  Copyright (c) 2014 Propain, LLC. All rights reserved.
//

#import "PPMainViewController.h"
#import "PPMapViewController.h"
#import "PPSettingsViewController.h"

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
	
	UIButton *settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
	settingsButton.frame = CGRectMake(3.0, 26.0, 44.0, 44.0);
	[settingsButton setBackgroundImage:[UIImage imageNamed:@"settings_nonActive"] forState:UIControlStateNormal];
	[settingsButton setBackgroundImage:[UIImage imageNamed:@"settings_Active"] forState:UIControlStateHighlighted];
	[settingsButton addTarget:self action:@selector(_goSettings) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:settingsButton];
		
	UIButton *locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
	locationButton.frame = CGRectMake(256.0, 24.0, 44.0, 44.0);
	[locationButton setBackgroundImage:[UIImage imageNamed:@"pointerButton_nonActive"] forState:UIControlStateNormal];
	[locationButton setBackgroundImage:[UIImage imageNamed:@"pointerButton_Active"] forState:UIControlStateHighlighted];
	[locationButton addTarget:self action:@selector(_goLocation) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:locationButton];
	
	_mapViewController = [[PPMapViewController alloc] init];
	_mapViewController.view.frame = CGRectOffset(_mapViewController.view.frame, 0.0, kNavHeaderHeight);
	_mapViewController.delegate = self;
	
	[self addChildViewController:_mapViewController];
	[self.view addSubview:_mapViewController.view];
	[_mapViewController didMoveToParentViewController:self];
	
	UIButton *requestButton = [UIButton buttonWithType:UIButtonTypeCustom];
	requestButton.frame = CGRectMake(113.0, self.view.bounds.size.height - 98.0, 94.0, 94.0);
	[requestButton setBackgroundImage:[UIImage imageNamed:@"mainButton_nonActive"] forState:UIControlStateNormal];
	[requestButton setBackgroundImage:[UIImage imageNamed:@"mainButton_Active"] forState:UIControlStateHighlighted];
	[requestButton addTarget:self action:@selector(_goRequestService) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:requestButton];
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
- (void)_goSettings {
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[[PPSettingsViewController alloc] init]];
	[navigationController setNavigationBarHidden:YES animated:NO];
	[self.navigationController presentViewController:navigationController animated:YES completion:^(void) {
	}];
}

- (void)_goLocation {
	[_mapViewController updateUserLocation];
}

- (void)_goRequestService {
	[_mapViewController requestService];
}


#pragma mark - MapViewController Delegates
- (void)mapViewController:(PPMapViewController *)mapViewController didUpdateLocation:(CLLocationCoordinate2D *)locationCoordinate2D {
	NSLog(@"**_[%@ mapViewController:didUpdateLocation:]_**", self.class);
}

@end
