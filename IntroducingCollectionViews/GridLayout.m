//
//  GridLayout.m
//  IntroducingCollectionViews
//
//  Created by Mark Pospesel on 10/4/12.
//  Copyright (c) 2012 Mark Pospesel. All rights reserved.
//

#import "GridLayout.h"
#import "ShelfView.h"
#import "CocoaConf.h"
#import "ConferenceLayoutAttributes.h"

@interface GridLayout()

@property (nonatomic, strong) NSDictionary *shelfRects;

@end

@implementation GridLayout

- (id)init
{
    self = [super init];
    if (self)
    {
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.itemSize = (CGSize){170, 197};
        self.sectionInset = UIEdgeInsetsMake(4, 10, 14, 10);
        self.headerReferenceSize = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad? (CGSize){50, 50} : (CGSize){43, 43};
        self.minimumInteritemSpacing = 10;
        self.minimumLineSpacing = 10;
        [self registerClass:[ShelfView class] forDecorationViewOfKind:[ShelfView kind]];
    }
    return self;
}

+ (Class)layoutAttributesClass
{
    return [ConferenceLayoutAttributes class];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSLog(@"%@", NSStringFromCGRect(rect));
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    
    for (UICollectionViewLayoutAttributes *attributes in array)
    {
        attributes.zIndex = 1;
        //if (attributes.representedElementCategory == UICollectionElementCategoryCell)
        //    attributes.alpha = 0.5;
        /*else if (attributes.indexPath.row > 0 || attributes.indexPath.section > 0)
            attributes.alpha = 0.5;*/
        if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal && attributes.representedElementCategory == UICollectionElementCategorySupplementaryView)
        {
            // make label vertical if scrolling is horizontal
            attributes.transform3D = CATransform3DMakeRotation(-90 * M_PI / 180, 0, 0, 1);
            attributes.size = CGSizeMake(attributes.size.height, attributes.size.width);            
        }
        
        if (attributes.representedElementCategory == UICollectionElementCategorySupplementaryView && [attributes isKindOfClass:[ConferenceLayoutAttributes class]])
        {
            ConferenceLayoutAttributes *conferenceAttributes = (ConferenceLayoutAttributes *)attributes;
            conferenceAttributes.headerTextAlignment = NSTextAlignmentLeft;
        }
    }
    
    NSMutableArray *newArray = [array mutableCopy];
    
    [self.shelfRects enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (CGRectIntersectsRect([obj CGRectValue], rect))
        {
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:[ShelfView kind] withIndexPath:key];
            attributes.frame = [obj CGRectValue];
            attributes.zIndex = 0;
            //attributes.alpha = 0.5; // screenshots
            [newArray addObject:attributes];
        }
    }];

    array = [NSArray arrayWithArray:newArray];
    
    return array;
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical)
    {
        int sectionCount = [self.collectionView numberOfSections];
        
        CGFloat y = 0;
        CGFloat availableWidth = self.collectionViewContentSize.width - (self.sectionInset.left + self.sectionInset.right);
        int itemsAcross = floorf((availableWidth + self.minimumInteritemSpacing) / (self.itemSize.width + self.minimumInteritemSpacing));
        
        for (int section = 0; section < sectionCount; section++)
        {
            y += self.headerReferenceSize.height;
            y += self.sectionInset.top;
            
            int itemCount = [self.collectionView numberOfItemsInSection:section];
            int rows = ceilf(itemCount/(float)itemsAcross);
            for (int row = 0; row < rows; row++)
            {
                y += self.itemSize.height;
                dictionary[[NSIndexPath indexPathForItem:row inSection:section]] = [NSValue valueWithCGRect:CGRectMake(0, y - 32, self.collectionViewContentSize.width, 37)];
                
                if (row < rows - 1)
                    y += self.minimumLineSpacing;
            }
            
            y += self.sectionInset.bottom;
        }
    }
    else
    {
        CGFloat y = self.sectionInset.top;
        CGFloat availableHeight = self.collectionViewContentSize.height - (self.sectionInset.top + self.sectionInset.bottom);
        int itemsAcross = floorf((availableHeight + self.minimumInteritemSpacing) / (self.itemSize.height + self.minimumInteritemSpacing));
        CGFloat interval = ((availableHeight - self.itemSize.height) / (itemsAcross <= 1? 1 : itemsAcross - 1)) - self.itemSize.height;
        for (int row = 0; row < itemsAcross; row++)
        {
            y += self.itemSize.height;
            dictionary[[NSIndexPath indexPathForItem:row inSection:0]] = [NSValue valueWithCGRect:CGRectMake(0, roundf(y - 32), self.collectionViewContentSize.width, 37)];
            
            y += interval;
        }
    }
    
    self.shelfRects = [NSDictionary dictionaryWithDictionary:dictionary];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    attributes.zIndex = 1;
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:[CocoaConf smallHeaderKind]])
        return nil;
    
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForSupplementaryViewOfKind:kind atIndexPath:indexPath];
    attributes.zIndex = 1;
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal)
    {
        // make label vertical if scrolling is horizontal
        attributes.transform3D = CATransform3DMakeRotation(-90 * M_PI / 180, 0, 0, 1);
        attributes.size = CGSizeMake(attributes.size.height, attributes.size.width);
    }
    
    if ([attributes isKindOfClass:[ConferenceLayoutAttributes class]])
    {
        ConferenceLayoutAttributes *conferenceAttributes = (ConferenceLayoutAttributes *)attributes;
        conferenceAttributes.headerTextAlignment = NSTextAlignmentLeft;
    }
    
   return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)decorationViewKind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForDecorationViewOfKind:decorationViewKind atIndexPath:indexPath];
    
    return attributes;
}

@end
