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
@property (nonatomic, strong) NSArray *speakers;

@end

@implementation Conference

- (id)initWithName:(NSString *)name startDate:(NSDate *)startDate duration:(NSUInteger)durationDays speakers:(NSArray *)speakers
{
    self = [super init];
    if (self)
    {
        _name = name;
        _startDate = startDate;
        _durationDays = durationDays;
        _speakers = speakers;
    }
    return self;
}

+ (Conference *)conferenceWithName:(NSString *)name startDate:(NSDate *)startDate duration:(NSUInteger)durationDays speakers:(NSArray *)speakers
{
    return [[Conference alloc] initWithName:name startDate:startDate duration:durationDays speakers:speakers];
}

- (void)deleteSpeakerAtIndex:(NSUInteger)index
{
    NSMutableArray *newSpeakers = [self.speakers mutableCopy];
    [newSpeakers removeObjectAtIndex:index];
    self.speakers = [NSArray arrayWithArray:newSpeakers];
}
@end
