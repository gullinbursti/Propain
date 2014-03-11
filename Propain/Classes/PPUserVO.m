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
	
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	
	vo.addedDate = [dateFormat dateFromString:[dictionary objectForKey:@"time"]];
	
	return (vo);
}

- (void)dealloc {
	self.dictionary = nil;
	self.username = nil;
	self.addedDate = nil;
}

@end
