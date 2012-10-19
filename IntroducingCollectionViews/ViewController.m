//
//  ViewController.m
//  IntroducingCollectionViews
//
//  Created by Mark Pospesel on 10/4/12.
//  Copyright (c) 2012 Mark Pospesel. All rights reserved.
//

#import "ViewController.h"
#import "Cell.h"
#import "GridLayout.h"
#import "LineLayout.h"
#import "CocoaConf.h"
#import "CoverFlowLayout.h"
#import "StacksLayout.h"
#import "ConferenceHeader.h"

@interface ViewController ()

@property (nonatomic, assign) SpeakerLayout layoutStyle;

@end

@implementation ViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        [self doInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self doInit];
    }
    return self;
}

- (id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithCollectionViewLayout:layout];
    if (self)
    {
        [self doInit];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [self doInit];
    }
    return self;
}

- (void)doInit
{
    _layoutStyle = SpeakerLayoutGrid;
}

- (void)viewDidLoad
{
    [self.collectionView setCollectionViewLayout:[[GridLayout alloc] init]];
    [self.collectionView setDataSource:[CocoaConf all]];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
//    [self.collectionView registerClass:[Cell class] forCellWithReuseIdentifier:@"SpeakerCell"];
    [self.collectionView registerClass:[ConferenceHeader class] forSupplementaryViewOfKind:[CocoaConf smallHeaderKind] withReuseIdentifier:[CocoaConf smallHeaderKind]];
    [self.collectionView reloadData];
    self.collectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Wood-Planks"]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tap.numberOfTouchesRequired = 2;
    [self.view addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handle3FingerTap:)];
    tap3.numberOfTouchesRequired = 3;
    [self.view addGestureRecognizer:tap3];
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    [self.collectionView addGestureRecognizer:pinch];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setLayoutStyle:(SpeakerLayout)layoutStyle animated:(BOOL)animated
{
    if (layoutStyle == self.layoutStyle)
        return;
    
    UICollectionViewLayout *newLayout = nil;
    BOOL reloadData = NO;
    BOOL delayedReload = NO;
    
    switch (layoutStyle)
    {
        case SpeakerLayoutGrid:
            newLayout = [[GridLayout alloc] init];
            break;
            
        case SpeakerLayoutLine:
            newLayout = [[LineLayout alloc] init];
            delayedReload = YES;
            break;
            
        case SpeakerLayoutCoverFlow:
            newLayout = [[CoverFlowLayout alloc] init];
            delayedReload = YES;
            break;
            
        case SpeakerLayoutStacks:
            newLayout = [[StacksLayout alloc] init];
            reloadData = YES;
            break;
            
        default:
            break;
    }
    
    if (!newLayout)
        return;
    
    [newLayout invalidateLayout];
    self.layoutStyle = layoutStyle;
    [self.collectionView setCollectionViewLayout:newLayout animated:(animated && !reloadData)];
    
    if (reloadData)
    {
        [self.collectionView reloadData];
    }
    else if (delayedReload)
    {
        [self.collectionView performSelector:@selector(reloadData) withObject:nil afterDelay:0.5];
    }
}

#pragma mark - Touch gesture

- (void)handleTap:(UITapGestureRecognizer *)gestureRecognizer
{
    SpeakerLayout newLayout = self.layoutStyle + 1;
    if (newLayout >= SpeakerLayoutCount)
        newLayout = 0;
    [self setLayoutStyle:newLayout animated:YES];
}

- (void)handle3FingerTap:(UITapGestureRecognizer *)gestureRecognizer
{
    SpeakerLayout newLayout = self.layoutStyle - 1;
    if ((int)newLayout < 0)
        newLayout = SpeakerLayoutCount - 1;
    [self setLayoutStyle:newLayout animated:YES];
}

- (void)handlePinch:(UIPinchGestureRecognizer *)gestureRecognizer
{
    if (self.layoutStyle != SpeakerLayoutStacks)
        return;
    
    StacksLayout *stacksLayout = (StacksLayout *)self.collectionView.collectionViewLayout;
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        CGPoint initialPinchPoint = [gestureRecognizer locationInView:self.collectionView];
        NSIndexPath* pinchedCellPath = [self.collectionView indexPathForItemAtPoint:initialPinchPoint];
        if (pinchedCellPath)
            [stacksLayout setPinchedStackIndex:pinchedCellPath.section];
    }
    
    else if (gestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        stacksLayout.pinchedStackScale = gestureRecognizer.scale;
        stacksLayout.pinchedStackCenter = [gestureRecognizer locationInView:self.collectionView];
    }
    
    else
    {
        if (stacksLayout.pinchedStackScale > 2.5)
        {
            [self setLayoutStyle:SpeakerLayoutGrid animated:YES];
        }
        else
        {
            [self.collectionView performBatchUpdates:^{
                stacksLayout.pinchedStackIndex = -1;
               stacksLayout.pinchedStackScale = 1.0;
             } completion:^(BOOL finished) {
                 [self.collectionView reloadData];
             }];
        }
    }
}

@end
