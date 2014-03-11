//
//  PPUserVO.h
//  Propain
//
//  Created by Matt Holcombe on 03/10/2014 @ 18:52 .
//  Copyright (c) 2014 Propain, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPUserVO : NSObject
+ (PPUserVO *)userWithDictionary:(NSDictionary *)dictionary;
@property (nonatomic, retain) NSDictionary *dictionary;
@property (nonatomic) int userID;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSDate *addedDate;
@end
