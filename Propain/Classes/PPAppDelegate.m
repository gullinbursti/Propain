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

const CGFloat kNavHeaderHeight = 77.0f;
const CGFloat kNavFooterHeight = 55.0f;


@interface PPAppDelegate ()
@property (nonatomic, strong) UIImageView *launchImageView;
@property (nonatomic, strong) UIView *statusBarTintView;
@end

@implementation PPAppDelegate

#pragma mark - UserDefaults
+ (void)writeUserInfoToUserDefaults:(NSDictionary *)userInfo {
	if ([[NSUserDefaults standardUserDefaults] objectForKey:@"user_info"] != nil)
		[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user_info"];
	
	[[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:@"user_info"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+ (PPUserVO *)userInfoFromUserDefaults {
	if ([[NSUserDefaults standardUserDefaults] objectForKey:@"user_info"] != nil)
		return ([PPUserVO userWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_info"]]);
	
	else
		return ([PPUserVO userWithDictionary:@{@"id"		: @"0",
											   @"username"	: @"",
											   @"added"		: @"2014-03-11 09:43:21"}]);
}

+ (void)writeServiceRequestToUserDefaults:(NSDictionary *)dictionary {
	if ([[NSUserDefaults standardUserDefaults] objectForKey:@"service_request"] != nil)
		[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"service_request"];
	
	[[NSUserDefaults standardUserDefaults] setObject:dictionary forKey:@"service_request"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+ (PPServiceRequestVO *)serviceRequestFromUserDefaults {
	if ([[NSUserDefaults standardUserDefaults] objectForKey:@"service_request"] != nil)
		return ([PPServiceRequestVO serviceRequestWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"service_request"]]);
	
	else
		return ([PPServiceRequestVO serviceRequestWithDictionary:@{@"id"				: @"0",
																   @"status"			: [NSString stringWithFormat:@"%d", PPServiceRequestStatusInvalid],
																   @"supplier_id"		: @"0",
																   @"supplier_name"		: @"",
																   @"supplier_coords"	: @{@"latitude"		: [NSString stringWithFormat:@"%f", 0.0],
																							@"longitude"	: [NSString stringWithFormat:@"%f", 0.0]},
																   @"added"				: @"0000-00-00 00:00:00",
																   @"updated"			: @"0000-00-00 00:00:00",
																   @"ended"				: @"0000-00-00 00:00:00"}]);
}


#pragma mark - Helper Functions
+ (BOOL)isRetina4Inch {
	return (([UIScreen mainScreen].scale == 2.0f) && ([UIScreen mainScreen].bounds.size.height == 568.0f));
}

+ (NSDate *)dateForFormattedString:(NSString *)dateString {
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	
	return ([dateFormat dateFromString:dateString]);
}


#pragma mark - Notifications
- (void)_toggleStatusBar:(NSNotification *)notification {
	BOOL willDisplay = ([[notification object] isEqualToString:@"YES"]);
	
	if (self.statusBarTintView != nil) {
		[[UIApplication sharedApplication] setStatusBarHidden:!willDisplay
												withAnimation:UIStatusBarAnimationFade];
		
		[UIView animateWithDuration:0.33
						 animations:^(void) {self.statusBarTintView.alpha = (int)willDisplay;}
						 completion:^(BOOL finished) {}];
	}
}



#pragma mark - UI Presentation
- (void)_styleAppUI {
	
	// make status bar content white
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
	
	self.statusBarTintView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 20.0)];
	self.statusBarTintView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.75];
	self.statusBarTintView.alpha = 0.0;
	[self.window addSubview:self.statusBarTintView];
}

- (void)_showRegistration {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"TOGGLE_STATUS_BAR"
														object:@"NO"];
	
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
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"TOGGLE_STATUS_BAR"
														object:@"NO"];
	
	// window setup
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.window.backgroundColor = [UIColor whiteColor];
	[self.window setRootViewController:self.rootNavigationController];
	
	
	// show app ui
	[self.window makeKeyAndVisible];
	[self _styleAppUI];
	
	
	// clear out user info
#if __WIPE_USER_INFO__ == 1
	if ([[NSUserDefaults standardUserDefaults] objectForKey:@"user_info"] != nil) {
		[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user_info"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
#endif
	
#if __REQUIRE_REGISTRATION__ == 1
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
