//
//  PPAppDelegate.h
//  Propain
//
//  Created by Matt Holcombe on 03/10/2014.
//  Copyright (c) 2014 Propain, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PPServiceRequestVO.h"
#import "PPUserVO.h"

#define __DEV_BUILD__ 1
#define __WIPE_USER_INFO__ 1
#define __REQUIRE_REGISTRATION__ 0


#define kMetersPerMile 1609.344f
#define kMilesPerLatitudeDegree 69.0f


extern const CGFloat kNavHeaderHeight;
extern const CGFloat kNavFooterHeight;


@interface PPAppDelegate : UIResponder <UIApplicationDelegate>
+ (void)writeUserInfoToUserDefaults:(NSDictionary *)userInfo;
+ (PPUserVO *)userInfoFromUserDefaults;

+ (void)writeServiceRequestToUserDefaults:(NSDictionary *)dictionary;
+ (PPServiceRequestVO *)serviceRequestFromUserDefaults;


+ (BOOL)isRetina4Inch;
+ (NSDate *)dateForFormattedString:(NSString *)dateString;


@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *rootNavigationController;

@end
