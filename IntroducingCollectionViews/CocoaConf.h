//
//  CocoaConf.h
//  IntroducingCollectionViews
//
//  Created by Mark Pospesel on 10/8/12.
//  Copyright (c) 2012 Mark Pospesel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StacksLayout.h"

@interface CocoaConf : NSObject<UICollectionViewDataSource>

+ (CocoaConf *)combined;
+ (CocoaConf *)all;
+ (CocoaConf *)currentCocoaConf;
+ (CocoaConf *)recent;

+ (NSString *)smallHeaderKind;

- (void)deleteSpeakerAtPath:(NSIndexPath *)indexPath;

@end
