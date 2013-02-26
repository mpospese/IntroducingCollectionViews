//
//  StacksLayout.m
//  IntroducingCollectionViews
//
//  Created by Mark Pospesel on 10/12/12.
//  Copyright (c) 2012 Mark Pospesel. All rights reserved.
//

#import "StacksLayout.h"
#import "GridLayout.h"
#import "ConferenceHeader.h"
#import "ConferenceLayoutAttributes.h"

#define STACKS_LEFT_MARGIN  20.0f
#define STACKS_TOP_MARGIN  20.0f
#define STACKS_RIGHT_MARGIN  20.0f
#define STACKS_BOTTOM_MARGIN  20.0f
#define MINIMUM_INTERSTACK_SPACING_IPAD 50.0f
#define MINIMUM_INTERSTACK_SPACING_IPHONE 20.0f
#define STACK_WIDTH 180.0f
#define STACK_HEIGHT 180.0f
#define STACK_FOOTER_GAP 8.0f
#define STACK_FOOTER_HEIGHT 25.0f
#define ITEM_SIZE 170.0f

#define MIN_PINCH_SCALE 1.0f
#define MAX_PINCH_SCALE 4.0f
#define FADE_PROGRESS 0.75
#define VISIBLE_ITEMS_PER_STACK 3

@interface StacksLayout()

@property (nonatomic, assign) NSUInteger numberOfStacks;
@property (nonatomic, assign, getter = isPinching) BOOL pinching;
@property (nonatomic, assign) CGFloat minimumInterStackSpacing;
@property (nonatomic, assign) CGFloat minimumLineSpacing;
@property (nonatomic, assign) UIEdgeInsets stacksInsets;
@property (nonatomic, assign) CGSize stackSize;
@property (nonatomic, strong) NSMutableArray *stackFrames;
@property (nonatomic, strong) NSMutableArray *itemFrames;
@property (nonatomic, strong) UICollectionViewFlowLayout *gridLayout;
@property (nonatomic, assign) NSUInteger numberOfStacksAcross;
@property (nonatomic, assign) NSUInteger numberOfStackRows;
@property (nonatomic, assign) CGSize pageSize;
@property (nonatomic, assign) CGSize contentSize;

@end

@implementation StacksLayout

- (id)init
{
    self = [super init];
    if (self)
    {
        BOOL iPad = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;
        _minimumInterStackSpacing = iPad? MINIMUM_INTERSTACK_SPACING_IPAD : MINIMUM_INTERSTACK_SPACING_IPHONE;
        _minimumLineSpacing = _minimumInterStackSpacing;
        _stacksInsets = UIEdgeInsetsMake(STACKS_TOP_MARGIN, STACKS_LEFT_MARGIN, STACKS_BOTTOM_MARGIN, STACKS_RIGHT_MARGIN);
        _stackSize = CGSizeMake(STACK_WIDTH, STACK_HEIGHT);
        _numberOfStacksAcross = 0;
        _numberOfStackRows = 0;
        _contentSize = CGSizeZero;
        _pinchedStackIndex = -1;
    }
    return self;
}

#pragma mark - UICollectionViewLayout

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds
{
    return !CGSizeEqualToSize(oldBounds.size, self.pageSize);
}

+ (Class)layoutAttributesClass
{
    return [ConferenceLayoutAttributes class];
}

- (CGSize)collectionViewContentSize
{
    return self.contentSize;
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    // calculate everything!
    [self prepareStacksLayout];
    if (self.isPinching)
        [self prepareItemsLayout];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)path
{
    CGRect stackFrame = [self.stackFrames[path.section] CGRectValue];
    
    ConferenceLayoutAttributes* attributes = [ConferenceLayoutAttributes layoutAttributesForCellWithIndexPath:path];
    attributes.size = CGSizeMake(ITEM_SIZE, ITEM_SIZE);
    attributes.center = CGPointMake(CGRectGetMidX(stackFrame), CGRectGetMidY(stackFrame));
    CGFloat angle = 0;
    if (path.item == 1)
        angle = 5;
    else if (path.item == 2)
        angle = -5;
    attributes.transform3D = CATransform3DMakeRotation(angle * M_PI / 180, 0, 0, 1);
    attributes.alpha = 1;
    if (path.item < VISIBLE_ITEMS_PER_STACK)
    {
        // use z-dimension (rather than z-Index) to stack photos in the correct order
        attributes.transform3D = CATransform3DTranslate(attributes.transform3D, 0, 0, VISIBLE_ITEMS_PER_STACK - path.item);
    }
    attributes.hidden = self.isCollapsing? NO : path.item >= VISIBLE_ITEMS_PER_STACK;
    attributes.shadowOpacity = path.item >= VISIBLE_ITEMS_PER_STACK? 0 : 0.5;
    
    if (self.isPinching)
    {
        // convert pinch scale to progress: 0 to 1
        CGFloat progress = MIN(MAX((self.pinchedStackScale - MIN_PINCH_SCALE) / (MAX_PINCH_SCALE - MIN_PINCH_SCALE), 0), 1);
        
        if (path.section == self.pinchedStackIndex)
        {
            int itemCount = self.itemFrames.count;
            if (path.item < itemCount)
            {
                CGRect itemFrame = [self.itemFrames[path.item] CGRectValue];
                CGFloat newX = attributes.center.x * (1 - progress) + CGRectGetMidX(itemFrame) * progress;
                CGFloat newY = attributes.center.y * (1 - progress) + CGRectGetMidY(itemFrame) * progress;
                attributes.center = CGPointMake(newX, newY);
                angle *= (1- progress);
                attributes.transform3D = CATransform3DMakeRotation(angle * M_PI / 180, 0, 0, 1);
                attributes.alpha = 1;
                // use z-dimension (rather than z-Index) to stack photos in the correct order
                attributes.transform3D = CATransform3DTranslate(attributes.transform3D, 0, 0, (itemCount + VISIBLE_ITEMS_PER_STACK) - path.item);

                attributes.hidden = NO;
                if (path.item >= VISIBLE_ITEMS_PER_STACK)
                    attributes.shadowOpacity = 0.5 * progress;
           }
        }
        else
        {
            if (!attributes.hidden)
            {
                if (progress >= FADE_PROGRESS)
                    attributes.alpha = 0;
                else
                    attributes.alpha = 1 - (progress/FADE_PROGRESS);
            }
         }
    }
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (![kind isEqualToString:[SmallConferenceHeader kind]])
        return nil;
    
    UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kind withIndexPath:indexPath];

    attributes.size = CGSizeMake(STACK_WIDTH, STACK_FOOTER_HEIGHT);
    CGRect stackFrame = [self.stackFrames[indexPath.section] CGRectValue];
    attributes.center = CGPointMake(CGRectGetMidX(stackFrame), CGRectGetMaxY(stackFrame) + STACK_FOOTER_GAP + (STACK_FOOTER_HEIGHT/2));
    //attributes.alpha = 1;
    
    if (self.isPinching)
    {
        // convert pinch scale to progress: 0 to 1
        CGFloat progress = MIN(MAX((self.pinchedStackScale - MIN_PINCH_SCALE) / (MAX_PINCH_SCALE - MIN_PINCH_SCALE), 0), 1);
        
        if (progress >= FADE_PROGRESS)
            attributes.alpha = 0;
        else
            attributes.alpha = 1 - (progress/FADE_PROGRESS);
    }
    
    return attributes;
}

-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray* attributes = [NSMutableArray array];
    for (int stack = 0; stack < self.numberOfStacks; stack++)
    {
        CGRect stackFrame = [self.stackFrames[stack] CGRectValue];
        stackFrame.size.height += (STACK_FOOTER_GAP + STACK_FOOTER_HEIGHT);
        if (CGRectIntersectsRect(stackFrame, rect))
        {
            NSInteger itemCount = [self.collectionView numberOfItemsInSection:stack];
            for (int item = 0; item < itemCount; item++)
            {
                NSIndexPath* indexPath = [NSIndexPath indexPathForItem:item inSection:stack];
                [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
            }
            
            // add small label as footer
            [attributes addObject:[self layoutAttributesForSupplementaryViewOfKind:[SmallConferenceHeader kind] atIndexPath:[NSIndexPath indexPathForItem:0 inSection:stack]]];
        }
    }
    
    return attributes;
}

#pragma mark - Properties

-(void)setPinchedStackScale:(CGFloat)pinchedStackScale
{
    _pinchedStackScale = pinchedStackScale;
    [self invalidateLayout];
}

- (void)setPinchedStackCenter:(CGPoint)pinchedStackCenter
{
    _pinchedStackCenter = pinchedStackCenter;
    [self invalidateLayout];
}

- (void)setPinchedStackIndex:(NSInteger)pinchedStackIndex
{
    _pinchedStackIndex = pinchedStackIndex;
    BOOL wasPinching = self.isPinching;
    [self setPinching:pinchedStackIndex >= 0];
    if (self.isPinching != wasPinching)
    {
        if (self.isPinching)
            self.gridLayout = [[GridLayout alloc] init];
        else
            self.gridLayout = nil;
    }
    [self invalidateLayout];
}

#pragma mark - Private Instance Methods

- (void)prepareStacksLayout
{
    self.numberOfStacks = [self.collectionView numberOfSections];
    self.pageSize = self.collectionView.bounds.size;
    
    CGFloat availableWidth = self.pageSize.width - (self.stacksInsets.left + self.stacksInsets.right);
    self.numberOfStacksAcross = floorf((availableWidth + self.minimumInterStackSpacing) / (self.stackSize.width + self.minimumInterStackSpacing));
    CGFloat spacing = floorf((availableWidth - (self.numberOfStacksAcross * self.stackSize.width)) / (self.numberOfStacksAcross - 1));
    self.numberOfStackRows = ceilf(self.numberOfStacks / (float)self.numberOfStacksAcross);
    
    self.stackFrames = [NSMutableArray array];
    int stackColumn = 0;
    int stackRow = 0;
    CGFloat left = self.stacksInsets.left;
    CGFloat top = self.stacksInsets.top;
    
    for (int stack = 0; stack < self.numberOfStacks; stack++)
    {
        CGRect stackFrame = (CGRect){{left, top}, self.stackSize};
        [self.stackFrames addObject:[NSValue valueWithCGRect:stackFrame]];
        
        left += self.stackSize.width + spacing;
        stackColumn += 1;
        
        if (stackColumn >= self.numberOfStacksAcross)
        {
            left = self.stacksInsets.left;
            top += self.stackSize.height + STACK_FOOTER_GAP + STACK_FOOTER_HEIGHT + self.minimumLineSpacing;
            stackColumn = 0;
            stackRow += 1;
        }
    }
    
    self.contentSize = CGSizeMake(self.pageSize.width, MAX(self.pageSize.height, self.stacksInsets.top + (self.numberOfStackRows * (self.stackSize.height + STACK_FOOTER_GAP + STACK_FOOTER_HEIGHT)) + ((self.numberOfStackRows - 1) * self.minimumLineSpacing) + self.stacksInsets.bottom));
}

- (void)prepareItemsLayout
{
    self.itemFrames = [NSMutableArray array];
    
    int numberOfItems = [self.collectionView numberOfItemsInSection:self.pinchedStackIndex];
    CGFloat availableWidth = self.pageSize.width - (self.gridLayout.sectionInset.left + self.gridLayout.sectionInset.right);
    int numberOfItemsAcross = floorf((availableWidth + self.gridLayout.minimumInteritemSpacing) / (self.gridLayout.itemSize.width + self.gridLayout.minimumInteritemSpacing));
    CGFloat spacing = floorf((availableWidth - (numberOfItemsAcross * self.gridLayout.itemSize.width)) / (numberOfItemsAcross - 1));
    
    int column = 0;
    int row = 0;
    CGFloat left = self.gridLayout.sectionInset.left;
    CGFloat top = self.gridLayout.sectionInset.top;
    for (int item = 0; item < numberOfItems; item++)
    {
        CGRect itemFrame = (CGRect){{left, top + self.collectionView.contentOffset.y}, self.gridLayout.itemSize};
        [self.itemFrames addObject:[NSValue valueWithCGRect:itemFrame]];
        
        left += self.gridLayout.itemSize.width + spacing;
        column += 1;
        
        if (column >= numberOfItemsAcross)
        {
            left = self.gridLayout.sectionInset.left;
            top += self.gridLayout.itemSize.height + self.gridLayout.minimumLineSpacing;
            column = 0;
            row += 1;
        }
        
        if (top >= self.pageSize.height)
            break;
    }
    
    int numberOfItemRows = ceilf(self.itemFrames.count / (CGFloat)numberOfItemsAcross);
    
    CGSize itemContentSize = CGSizeMake(self.pageSize.width, self.gridLayout.sectionInset.top + (numberOfItemRows * self.gridLayout.itemSize.height) + ((numberOfItemRows - 1) * self.gridLayout.minimumLineSpacing) + self.gridLayout.sectionInset.bottom);
    CGSize stackContentSize = self.contentSize;
    self.contentSize = CGSizeMake(MAX(itemContentSize.width, stackContentSize.width), MAX(itemContentSize.height, stackContentSize.height));
}


@end
