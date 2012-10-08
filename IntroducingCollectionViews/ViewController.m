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

@interface ViewController ()

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
