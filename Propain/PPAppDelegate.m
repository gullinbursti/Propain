//
//  PPAppDelegate.m
//  Propain
//
//  Created by Matt Holcombe on 03/10/2014.
//  Copyright (c) 2014 Propain, LLC. All rights reserved.
//

#import "PPAppDelegate.h"
#import "PPMainViewController.h"
#import "PPRegisterViewController.h"

const CGFloat kNavHeaderHeight = 77.0;
const CGFloat kNavFooterHeight = 52.0;
const CGPoint kHomePoint = {-80.626703, 24.922894};
const CGFloat kMapDistanceMeters = 5000.0f;
const CGFloat kMapScaleMiles = 12.0f;

@interface PPAppDelegate ()
@property (nonatomic, strong) UIImageView *launchImageView;
@property (nonatomic, strong) UIView *statusBarTintView;
@end

@implementation PPAppDelegate

#pragma mark - UserDefaults
+ (void)writeUserToUserDefaults:(NSDictionary *)userInfo {
	
	// remove previous info if exists
	if ([[NSUserDefaults standardUserDefaults] objectForKey:@"user_info"] != nil)
		[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user_info"];
	
	// write
	[[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:@"user_info"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+ (PPUserVO *)userFromUserDefaults {
	
	// user info exists, convert to vo
	if ([[NSUserDefaults standardUserDefaults] objectForKey:@"user_info"] != nil)
		return ([PPUserVO userWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_info"]]);
	
	// doesn't exist, return a nil
	else
		return (nil);
}


#pragma mark - Helper Functions
+ (BOOL)isRetina4Inch {
	
	// screen is 4"
	return (([UIScreen mainScreen].scale == 2.0f) && ([UIScreen mainScreen].bounds.size.height == 568.0f));
}


#pragma mark - Notifications
- (void)_toggleStatusBar:(NSNotification *)notification {
	BOOL willDisplay = ([[notification object] isEqualToString:@"YES"]);
	
	// make sure tint view exists
	if (self.statusBarTintView != nil) {
		
		// hide/show status bar
		[[UIApplication sharedApplication] setStatusBarHidden:!willDisplay
												withAnimation:UIStatusBarAnimationFade];
		
		// animate tint in/out
		[UIView animateWithDuration:0.33
						 animations:^(void) {self.statusBarTintView.alpha = (int)willDisplay;}
						 completion:^(BOOL finished) {}];
	}
}


#pragma mark - UI Presentation
- (void)_styleAppUI {
	
	// make status bar content white
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
	
	// status bar tint
	self.statusBarTintView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 20.0)];
	self.statusBarTintView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.75];
	self.statusBarTintView.alpha = 0.0;
	[self.window addSubview:self.statusBarTintView];
}

- (void)_showRegistration {
	// hide status bar
	[[NSNotificationCenter defaultCenter] postNotificationName:@"TOGGLE_STATUS_BAR"
														object:@"NO"];
	
	// present view controller
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[[PPRegisterViewController alloc] init]];
	[navigationController setNavigationBarHidden:YES animated:NO];
	[self.rootNavigationController presentViewController:navigationController animated:NO completion:^(void) {
	}];
}

#pragma mark - Application Delegates
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	
	// app notifications
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(_toggleStatusBar:)
												 name:@"TOGGLE_STATUS_BAR"
											   object:nil];
	
	
	// init app view controller
	self.rootNavigationController = [[UINavigationController alloc] initWithRootViewController:[[PPMainViewController alloc] init]];
	[self.rootNavigationController setNavigationBarHidden:YES animated:NO];
	
	// hide the status bar
	[[NSNotificationCenter defaultCenter] postNotificationName:@"TOGGLE_STATUS_BAR"
														object:@"NO"];
	
	// window setup
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.window.backgroundColor = [UIColor whiteColor];
	[self.window setRootViewController:self.rootNavigationController];
	
	
	// show app ui
	[self.window makeKeyAndVisible];
	
	// setup app appearance
	[self _styleAppUI];
	
	
	// clear out user info
#if __FORCE_REGISTRATION__ == 1
	if ([[NSUserDefaults standardUserDefaults] objectForKey:@"user_info"] != nil) {
		[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user_info"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
#endif
	
	// requires user to register
#if __REQUIRE_REGISTRATION__ == 1
	// no user assigned, show register
	if ([PPAppDelegate userFromUserDefaults] == nil)
		[self _showRegistration];
#endif
	
	return (YES);
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

@end
