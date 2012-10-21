//
//  ConferenceLayoutAttributes.h
//  IntroducingCollectionViews
//
//  Created by Mark Pospesel on 10/21/12.
//  Copyright (c) 2012 Mark Pospesel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConferenceLayoutAttributes : UICollectionViewLayoutAttributes

// whether header view (ConferenceHeader class) should align label left or center (default = left)
@property (nonatomic, assign) NSTextAlignment headerTextAlignment;

// shadow opacity for the shadow on the photo in SpeakerCell (default = 0.5)
@property (nonatomic, assign) CGFloat shadowOpacity;

@end
