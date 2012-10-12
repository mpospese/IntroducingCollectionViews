//
//  CoverFlowLayout.m
//  IntroducingCollectionViews
//
//  Created by Mark Pospesel on 10/7/12.
//  Copyright (c) 2012 Mark Pospesel. All rights reserved.
//

#import "CoverFlowLayout.h"

@implementation CoverFlowLayout

#define ACTIVE_DISTANCE 200
#define ZOOM_FACTOR 0.3

- (id)init
{
    self = [super init];
    if (self)
    {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.itemSize = (CGSize){160, 190};
        self.sectionInset = UIEdgeInsetsMake(250, 35, 200, 250);
        self.minimumLineSpacing = -30.0;
        self.minimumInteritemSpacing = 200;
    }
    return self;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds
{
    return YES;
}

-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray* array = [super layoutAttributesForElementsInRect:rect];
    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    
    for (UICollectionViewLayoutAttributes* attributes in array) {
        if (CGRectIntersectsRect(attributes.frame, rect)) {
            CGFloat distance = CGRectGetMidX(visibleRect) - attributes.center.x;
            CGFloat normalizedDistance = distance / ACTIVE_DISTANCE;
            BOOL isLeft = distance > 0;
            CATransform3D transform = CATransform3DIdentity;
            transform.m34 = -1/(4.6777 * self.itemSize.width);
            
            if (ABS(distance) < ACTIVE_DISTANCE)
            {
                transform = CATransform3DTranslate(CATransform3DIdentity, 0, 0, (1 - ABS(normalizedDistance)) * 40000 + (isLeft? 200 : 0));
                transform.m34 = -1/(4.6777 * self.itemSize.width);
                CGFloat zoom = 1 + ZOOM_FACTOR*(1 - ABS(normalizedDistance));
                transform = CATransform3DRotate(transform, (isLeft? 1 : -1) * ABS(normalizedDistance) * 45 * M_PI / 180, 0, 1, 0);
                transform = CATransform3DScale(transform, zoom, zoom, 1);
                attributes.zIndex = 1;//ABS(ACTIVE_DISTANCE - ABS(distance)) + 1;
            }
            else
            {
                transform = CATransform3DRotate(transform, (isLeft? 1 : -1) * 45 * M_PI / 180, 0, 1, 0);
                attributes.zIndex = 0;
            }
            attributes.transform3D = transform;
       }
    }
    return array;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    CGFloat distance = CGRectGetMidX(visibleRect) - attributes.center.x;
    CGFloat normalizedDistance = distance / ACTIVE_DISTANCE;
    BOOL isLeft = distance > 0;
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1/(4.6777 * self.itemSize.width);
    
    if (ABS(distance) < ACTIVE_DISTANCE)
    {
        //transform = CATransform3DTranslate(CATransform3DIdentity, 0, 0, ABS(ACTIVE_DISTANCE - distance) * 200 + 1);
        transform.m34 = -1/(4.6777 * self.itemSize.width);
        CGFloat zoom = 1 + ZOOM_FACTOR*(1 - ABS(normalizedDistance));
        transform = CATransform3DRotate(transform, (isLeft? 1 : -1) * ABS(normalizedDistance) * 45 * M_PI / 180, 0, 1, 0);
        transform = CATransform3DScale(transform, zoom, zoom, 1);
        attributes.zIndex = 1;//ABS(ACTIVE_DISTANCE - ABS(distance)) + 1;
    }
    else
    {
        transform = CATransform3DRotate(transform, (isLeft? 1 : -1) * 45 * M_PI / 180, 0, 1, 0);
        attributes.zIndex = 0;
    }
    attributes.transform3D = transform;
    
    return attributes;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    CGFloat offsetAdjustment = MAXFLOAT;
    CGFloat horizontalCenter = proposedContentOffset.x + (CGRectGetWidth(self.collectionView.bounds) / 2.0);
    
    CGRect targetRect = CGRectMake(proposedContentOffset.x, 0.0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    NSArray* array = [super layoutAttributesForElementsInRect:targetRect];
    
    for (UICollectionViewLayoutAttributes* layoutAttributes in array) {
        CGFloat itemHorizontalCenter = layoutAttributes.center.x;
        if (ABS(itemHorizontalCenter - horizontalCenter) < ABS(offsetAdjustment)) {
            offsetAdjustment = itemHorizontalCenter - horizontalCenter;
        }
    }
    return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
}

@end
