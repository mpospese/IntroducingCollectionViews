//
//  CoverFlowLayout.m
//  IntroducingCollectionViews
//
//  Created by Mark Pospesel on 10/7/12.
//  Copyright (c) 2012 Mark Pospesel. All rights reserved.
//

#import "CoverFlowLayout.h"
#import "ConferenceLayoutAttributes.h"

@implementation CoverFlowLayout

#define ACTIVE_DISTANCE 100
#define TRANSLATE_DISTANCE 100
#define ZOOM_FACTOR 0.3
#define FLOW_OFFSET 40

- (id)init
{
    self = [super init];
    if (self)
    {
        BOOL iPad = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.itemSize = (CGSize){170, 200};
        self.sectionInset = UIEdgeInsetsMake(iPad? 225 : 0, 35, iPad? 225 : 0, 35);
        self.minimumLineSpacing = -51.0;
        self.minimumInteritemSpacing = 200;
        self.headerReferenceSize = iPad? (CGSize){50, 50} : (CGSize){43, 43};
    }
    return self;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds
{
    return YES;
}

+ (Class)layoutAttributesClass
{
    return [ConferenceLayoutAttributes class];
}

-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray* array = [super layoutAttributesForElementsInRect:rect];
    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    
    for (UICollectionViewLayoutAttributes* attributes in array) {
        if (attributes.representedElementCategory == UICollectionElementCategoryCell)
        {
            if (CGRectIntersectsRect(attributes.frame, rect)) {
                [self setCellAttributes:attributes forVisibleRect:visibleRect];
            }
        }
        else if (attributes.representedElementCategory == UICollectionElementCategorySupplementaryView)
        {
            [self setHeaderAttributes:attributes];
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
    
    [self setCellAttributes:attributes forVisibleRect:visibleRect];
    
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForSupplementaryViewOfKind:kind atIndexPath:indexPath];
    
    [self setHeaderAttributes:attributes];
    
    return attributes;
}

- (void)setHeaderAttributes:(UICollectionViewLayoutAttributes *)attributes
{
    attributes.transform3D = CATransform3DMakeRotation(-90 * M_PI / 180, 0, 0, 1);
    attributes.size = CGSizeMake(attributes.size.height, attributes.size.width);
    if ([attributes isKindOfClass:[ConferenceLayoutAttributes class]])
    {
        ConferenceLayoutAttributes *conferenceAttributes = (ConferenceLayoutAttributes *)attributes;
        conferenceAttributes.headerTextAlignment = NSTextAlignmentCenter;
    }
}

- (void)setCellAttributes:(UICollectionViewLayoutAttributes *)attributes forVisibleRect:(CGRect)visibleRect
{
    CGFloat distance = CGRectGetMidX(visibleRect) - attributes.center.x;
    CGFloat normalizedDistance = distance / ACTIVE_DISTANCE;
    BOOL isLeft = distance > 0;
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1/(4.6777 * self.itemSize.width);
    
    if (ABS(distance) < ACTIVE_DISTANCE)
    {
        if (ABS(distance) < TRANSLATE_DISTANCE)
        {
            transform = CATransform3DTranslate(CATransform3DIdentity, (isLeft? - FLOW_OFFSET : FLOW_OFFSET)*ABS(distance/TRANSLATE_DISTANCE), 0, (1 - ABS(normalizedDistance)) * 40000 + (isLeft? 200 : 0));
        }
        else
        {
            transform = CATransform3DTranslate(CATransform3DIdentity, (isLeft? - FLOW_OFFSET : FLOW_OFFSET), 0, (1 - ABS(normalizedDistance)) * 40000 + (isLeft? 200 : 0));
        }
        transform.m34 = -1/(4.6777 * self.itemSize.width);
        CGFloat zoom = 1 + ZOOM_FACTOR*(1 - ABS(normalizedDistance));
        transform = CATransform3DRotate(transform, (isLeft? 1 : -1) * ABS(normalizedDistance) * 45 * M_PI / 180, 0, 1, 0);
        transform = CATransform3DScale(transform, zoom, zoom, 1);
        attributes.zIndex = 1;//ABS(ACTIVE_DISTANCE - ABS(distance)) + 1;
    }
    else
    {
        transform = CATransform3DTranslate(transform, isLeft? -FLOW_OFFSET : FLOW_OFFSET, 0, 0);
        transform = CATransform3DRotate(transform, (isLeft? 1 : -1) * 45 * M_PI / 180, 0, 1, 0);
        attributes.zIndex = 0;
    }
    attributes.transform3D = transform;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    CGFloat offsetAdjustment = MAXFLOAT;
    CGFloat horizontalCenter = proposedContentOffset.x + (CGRectGetWidth(self.collectionView.bounds) / 2.0);
    
    CGRect targetRect = CGRectMake(proposedContentOffset.x, 0.0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    NSArray* array = [super layoutAttributesForElementsInRect:targetRect];
    
    for (UICollectionViewLayoutAttributes* layoutAttributes in array) {
        if (layoutAttributes.representedElementCategory != UICollectionElementCategoryCell)
            continue; // skip headers
        
        CGFloat itemHorizontalCenter = layoutAttributes.center.x;
        if (ABS(itemHorizontalCenter - horizontalCenter) < ABS(offsetAdjustment)) {
            offsetAdjustment = itemHorizontalCenter - horizontalCenter;
        }
    }
    return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
}

@end
