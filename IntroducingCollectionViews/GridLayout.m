//
//  GridLayout.m
//  IntroducingCollectionViews
//
//  Created by Mark Pospesel on 10/4/12.
//  Copyright (c) 2012 Mark Pospesel. All rights reserved.
//

#import "GridLayout.h"

@implementation GridLayout

- (id)init
{
    self = [super init];
    if (self)
    {
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.itemSize = (CGSize){160, 189};
        self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        self.headerReferenceSize = (CGSize){768, 50};
    }
    return self;
}

@end
