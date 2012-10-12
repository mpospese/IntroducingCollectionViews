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
    [self.collectionView reloadData];
    self.collectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Wood-Planks"]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tap.numberOfTouchesRequired = 2;
    [self.view addGestureRecognizer:tap];
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
    switch (layoutStyle)
    {
        case SpeakerLayoutGrid:
            newLayout = [[GridLayout alloc] init];
            break;
            
        case SpeakerLayoutLine:
            newLayout = [[LineLayout alloc] init];
            break;
            
        case SpeakerLayoutCoverFlow:
            newLayout = [[CoverFlowLayout alloc] init];
            
        default:
            break;
    }
    
    if (!newLayout)
        return;
    
    self.layoutStyle = layoutStyle;
    [self.collectionView setCollectionViewLayout:newLayout animated:animated];
}

#pragma mark - Touch gesture

- (void)handleTap:(UITapGestureRecognizer *)gestureRecognizer
{
    SpeakerLayout newLayout = self.layoutStyle + 1;
    if (newLayout >= SpeakerLayoutCount)
        newLayout = 0;
    [self setLayoutStyle:newLayout animated:YES];
}

@end
