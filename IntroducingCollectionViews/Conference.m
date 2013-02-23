//
//  Conference.m
//  IntroducingCollectionViews
//
//  Created by Mark Pospesel on 10/8/12.
//  Copyright (c) 2012 Mark Pospesel. All rights reserved.
//

#import "Conference.h"

@interface Conference()

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSDate* startDate;
@property (nonatomic, assign) NSUInteger durationDays;
@property (nonatomic, strong) NSMutableArray *speakers;
@property (nonatomic, strong) NSMutableArray *deletedSpeakers;

@end

@implementation Conference

- (id)initWithName:(NSString *)name startDate:(NSDate *)startDate duration:(NSUInteger)durationDays speakers:(NSArray *)speakers
{
    self = [super init];
    if (self)
    {
        _name = [name copy];
        _startDate = [startDate copy];
        _durationDays = durationDays;
        _speakers = [[speakers sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [obj1 caseInsensitiveCompare:obj2];
        }] mutableCopy];
        _deletedSpeakers = [NSMutableArray array];
    }
    return self;
}

+ (Conference *)conferenceWithName:(NSString *)name startDate:(NSDate *)startDate duration:(NSUInteger)durationDays speakers:(NSArray *)speakers
{
    return [[Conference alloc] initWithName:name startDate:startDate duration:durationDays speakers:speakers];
}

- (BOOL)deleteSpeakerAtIndex:(NSUInteger)index
{
    if (index >= self.speakers.count)
        return NO;
    
    [self.deletedSpeakers addObject:self.speakers[index]];
    [self.speakers removeObjectAtIndex:index];
    
    return YES;
}

- (BOOL)restoreSpeaker
{
    if (self.deletedSpeakers.count == 0)
        return NO;

    [self.speakers addObject:self.deletedSpeakers[0]];    
    [self.deletedSpeakers removeObjectAtIndex:0];

    return YES;
}


@end
