//
//  GridLayout.m
//  IntroducingCollectionViews
//
//  Created by Mark Pospesel on 10/4/12.
//  Copyright (c) 2012 Mark Pospesel. All rights reserved.
//

#import "GridLayout.h"
#import "ShelfView.h"
#import "ConferenceHeader.h"
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
        self.sectionInset = UIEdgeInsetsMake(4, 10, 14, 10);//UIEdgeInsetsMake(54, 60, 64, 60);
        self.headerReferenceSize = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad? (CGSize){50, 50} : (CGSize){43, 43}; // 100
        self.footerReferenceSize = (CGSize){44, 44}; // 88
        self.minimumInteritemSpacing = 10; // 40;
        self.minimumLineSpacing = 10;//40;
        [self registerClass:[ShelfView class] forDecorationViewOfKind:[ShelfView kind]];
    }
    return self;
}

+ (Class)layoutAttributesClass
{
    return [ConferenceLayoutAttributes class];
}

// Do all the calculations for determining where shelves go here
- (void)prepareLayout
{
    // call super so flow layout can do all the math for cells, headers, and footers
    [super prepareLayout];
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical)
    {
        // Calculate where shelves go in a vertical layout
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
            y += self.footerReferenceSize.height;
        }
    }
    else
    {
        // Calculate where shelves go in a horizontal layout
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

// Return attributes of all items (cells, supplementary views, decoration views) that appear within this rect
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    // call super so flow layout can return default attributes for all cells, headers, and footers
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    
    // tweak the attributes slightly
    for (UICollectionViewLayoutAttributes *attributes in array)
    {
        attributes.zIndex = 1;
        //if (attributes.representedElementCategory != UICollectionElementCategoryCell)
        /*if (attributes.representedElementCategory != UICollectionElementCategorySupplementaryView || [attributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader])
            attributes.alpha = 0.5;
        else if (attributes.indexPath.row > 0 || attributes.indexPath.section > 0)
            attributes.alpha = 0.5; // for single cell closeup*/
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
    
    // Add our decoration views (shelves)
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

// Layout attributes for a specific cell
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    attributes.zIndex = 1;
    return attributes;
}

// layout attributes for a specific header or footer
- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:[SmallConferenceHeader kind]])
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

// layout attributes for a specific decoration view
- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)decorationViewKind atIndexPath:(NSIndexPath *)indexPath
{
    id shelfRect = self.shelfRects[indexPath];
    if (!shelfRect)
        return nil; // no shelf at this index (this is probably an error)
    
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:[ShelfView kind] withIndexPath:indexPath];
    attributes.frame = [shelfRect CGRectValue];
    attributes.zIndex = 0; // shelves go behind other views
    
    return attributes;
}

@end
