//
//  PPRegisterViewController.m
//  Propain
//
//  Created by Matt Holcombe on 03/10/2014 @ 17:40 .
//  Copyright (c) 2014 Propain, LLC. All rights reserved.
//


#import "PPRegisterViewController.h"


@interface PPRegisterViewController ()
@end


@implementation PPRegisterViewController

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


#pragma mark - Data Calls


#pragma mark - View lifecycle
- (void)loadView {
	ViewControllerLog(@"[:|:] [%@ loadView] [:|:]", self.class);
	[super loadView];
	
	UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:([PPAppDelegate isRetina4Inch]) ? @"firstRunBG-568h@2x" : @"firstRunBG"]];
	bgImageView.frame = [[UIScreen mainScreen] bounds];
	[self.view addSubview:bgImageView];
}

- (void)viewDidLoad {
	ViewControllerLog(@"[:|:] [%@ viewDidLoad] [:|:]", self.class);
	[super viewDidLoad];
	
	UIButton *checkAvailButton = [UIButton buttonWithType:UIButtonTypeCustom];
	checkAvailButton.frame = CGRectMake(33.0, self.view.bounds.size.height - 111.0, 254.0, 74.0);
	[checkAvailButton setBackgroundImage:[UIImage imageNamed:@"checkAvail_nonActive"] forState:UIControlStateNormal];
	[checkAvailButton setBackgroundImage:[UIImage imageNamed:@"checkAvail_Active"] forState:UIControlStateHighlighted];
	[checkAvailButton addTarget:self action:@selector(_goCheckAvailability) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:checkAvailButton];
}

- (void)viewWillAppear:(BOOL)animated {
	ViewControllerLog(@"[:|:] [%@ viewWillAppear:%@] [:|:]", self.class, (animated) ? @"YES" : @"NO");
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	ViewControllerLog(@"[:|:] [%@ viewDidAppear:%@] [:|:]", self.class, (animated) ? @"YES" : @"NO");
	[super viewDidAppear:animated];
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
- (void)_goCheckAvailability {
	[self.navigationController dismissViewControllerAnimated:YES completion:^(void) {}];
}


@end
