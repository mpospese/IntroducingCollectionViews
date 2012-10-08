//
//  NSDate+Helpers.m
//  IntroducingCollectionViews
//
//  Created by Mark Pospesel on 10/8/12.
//  Copyright (c) 2012 Mark Pospesel. All rights reserved.
//

#import "NSDate+Helpers.h"

@implementation NSDate(Helpers)

+ (NSDate *)dateWithYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setYear:year];
    [dateComponents setMonth:month];
    [dateComponents setDay:day];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar dateFromComponents:dateComponents];
}

@end
