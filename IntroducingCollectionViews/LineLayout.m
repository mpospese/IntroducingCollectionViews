//
//  LineLayout.m
//  IntroducingCollectionViews
//
//  Created by Mark Pospesel on 10/7/12.
//  Copyright (c) 2012 Mark Pospesel. All rights reserved.
//

#import "LineLayout.h"
#import "ConferenceLayoutAttributes.h"

@interface LineLayout()

@end

@implementation LineLayout

#define ACTIVE_DISTANCE 200
#define ZOOM_FACTOR 0.3

- (id)init
{
    self = [super init];
    if (self)
    {
        BOOL iPad = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.itemSize = (CGSize){170, 200};
        self.sectionInset = UIEdgeInsetsMake(iPad? 225 : 0, 35, iPad? 225 : 0, 35);
        self.minimumLineSpacing = 30.0;
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
                [self setLineAttributes:attributes visibleRect:visibleRect];
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
    [self setLineAttributes:attributes visibleRect:visibleRect];
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

- (void)setLineAttributes:(UICollectionViewLayoutAttributes *)attributes visibleRect:(CGRect)visibleRect
{
    CGFloat distance = CGRectGetMidX(visibleRect) - attributes.center.x;
    CGFloat normalizedDistance = distance / ACTIVE_DISTANCE;
    if (ABS(distance) < ACTIVE_DISTANCE) {
        CGFloat zoom = 1 + ZOOM_FACTOR*(1 - ABS(normalizedDistance));
        attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0);
        attributes.zIndex = 1;
    }    
    else
    {
        attributes.transform3D = CATransform3DIdentity;
        attributes.zIndex = 0;
    }
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
