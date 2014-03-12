//
//  PPSettingsViewController.m
//  Propain
//
//  Created by Matt Holcombe on 03/11/2014 @ 18:09 .
//  Copyright (c) 2014 Propain, LLC. All rights reserved.
//


#import "PPSettingsViewController.h"


@interface PPSettingsViewController ()
@end


@implementation PPSettingsViewController

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
	
	UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:([PPAppDelegate isRetina4Inch]) ? @"mainBG-568h@2x" : @"mainBG"]];
	bgImageView.frame = [[UIScreen mainScreen] bounds];
	[self.view addSubview:bgImageView];
}

- (void)viewDidLoad {
	ViewControllerLog(@"[:|:] [%@ viewDidLoad] [:|:]", self.class);
	[super viewDidLoad];
	
	UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
	closeButton.frame = CGRectMake(256.0, 24.0, 44.0, 44.0);
	[closeButton setBackgroundImage:[UIImage imageNamed:@"pointerButton_nonActive"] forState:UIControlStateNormal];
	[closeButton setBackgroundImage:[UIImage imageNamed:@"pointerButton_Active"] forState:UIControlStateHighlighted];
	[closeButton addTarget:self action:@selector(_goClose) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:closeButton];
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
- (void)_goClose {
	[self.navigationController dismissViewControllerAnimated:YES completion:^(void) {}];
}


@end
