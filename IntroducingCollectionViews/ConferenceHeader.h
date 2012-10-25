//
//  ConferenceHeader.h
//  IntroducingCollectionViews
//
//  Created by Mark Pospesel on 10/8/12.
//  Copyright (c) 2012 Mark Pospesel. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Conference;
@interface ConferenceHeader : UICollectionReusableView

- (void)setConference:(Conference *)conference;

@end

@interface SmallConferenceHeader: ConferenceHeader

+ (NSString *)kind;

@end
