//
//  PPUserVO.m
//  Propain
//
//  Created by Matt Holcombe on 03/10/2014 @ 18:52 .
//  Copyright (c) 2014 Propain, LLC. All rights reserved.
//

#import "PPUserVO.h"

@implementation PPUserVO
@synthesize dictionary;
@synthesize userID, username, addedDate;

+ (PPUserVO *)userWithDictionary:(NSDictionary *)dictionary {
	PPUserVO *vo = [[PPUserVO alloc] init];
	vo.dictionary = dictionary;
	
	vo.userID = [[dictionary objectForKey:@"id"] intValue];
	vo.username = [dictionary objectForKey:@"username"];
	vo.addedDate = [PPAppDelegate dateForFormattedString:[dictionary objectForKey:@"added"]];
	
	return (vo);
}

- (void)dealloc {
	self.dictionary = nil;
	self.username = nil;
	self.addedDate = nil;
}

@end
