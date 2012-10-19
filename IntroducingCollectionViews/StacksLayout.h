//
//  StacksLayout.h
//  IntroducingCollectionViews
//
//  Created by Mark Pospesel on 10/12/12.
//  Copyright (c) 2012 Mark Pospesel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UICollectionViewStackDataSource<UICollectionViewDataSource>

@optional

- (NSInteger)selectedSection;
- (void)setSelectedSection:(NSInteger)selectedSection;

@end

@interface StacksLayout : UICollectionViewLayout

@property (nonatomic, assign) NSInteger pinchedStackIndex;
@property (nonatomic, assign) CGFloat pinchedStackScale;
@property (nonatomic, assign) CGPoint pinchedStackCenter;

@end
