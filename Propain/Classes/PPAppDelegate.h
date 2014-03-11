//
//  PPAppDelegate.h
//  Propain
//
//  Created by Matt Holcombe on 03/10/2014.
//  Copyright (c) 2014 Propain, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PPUserVO.h"

#define __DEV_BUILD__ 1
#define __FORCE_REGISTRATION__ 1
#define __REQUIRE_REGISTRATION__ 0

extern const CGFloat kNavHeaderHeight;
extern const CGFloat kNavFooterHeight;
extern const CGPoint kHomePoint;
extern const CGFloat kMapDistanceMeters;
extern const CGFloat kMapScaleMiles;


@interface PPAppDelegate : UIResponder <UIApplicationDelegate>
+ (void)writeUserToUserDefaults:(NSDictionary *)userInfo;
+ (PPUserVO *)userFromUserDefaults;
+ (BOOL)isRetina4Inch;


@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *rootNavigationController;

@end
