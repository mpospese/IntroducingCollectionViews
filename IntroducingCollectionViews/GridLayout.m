//
//  GridLayout.m
//  IntroducingCollectionViews
//
//  Created by Mark Pospesel on 10/4/12.
//  Copyright (c) 2012 Mark Pospesel. All rights reserved.
//

#import "GridLayout.h"

@implementation GridLayout

- (CGSize)itemSize
{
    return (CGSize){140, 140};
}

- (UIEdgeInsets)sectionInset
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

@end
