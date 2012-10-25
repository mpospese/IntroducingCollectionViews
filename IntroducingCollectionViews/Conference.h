//
//  Conference.h
//  IntroducingCollectionViews
//
//  Created by Mark Pospesel on 10/8/12.
//  Copyright (c) 2012 Mark Pospesel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Conference : NSObject

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSDate* startDate;
@property (nonatomic, assign, readonly) NSUInteger durationDays;
@property (nonatomic, strong, readonly) NSMutableArray *speakers;

- (id)initWithName:(NSString *)name startDate:(NSDate *)startDate duration:(NSUInteger)durationDays speakers:(NSArray *)speakers;
+ (Conference *)conferenceWithName:(NSString *)name startDate:(NSDate *)startDate duration:(NSUInteger)durationDays speakers:(NSArray *)speakers;

- (BOOL)deleteSpeakerAtIndex:(NSUInteger)index;
- (BOOL)restoreSpeaker;

@end
