//
//  ViewController.m
//  IntroducingCollectionViews
//
//  Created by Mark Pospesel on 10/4/12.
//  Copyright (c) 2012 Mark Pospesel. All rights reserved.
//

#import "ViewController.h"
#import "Cell.h"

@interface ViewController ()

@property (nonatomic, strong) NSArray *speakers;

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
    _speakers = @[@"Josh Abernathy", @"Chris Adamson", @"Ameir Al-Zoubi", @"Mike Ash", @"Janine Ohmer", @"Daniel Pasco", @"Mark Pospesel"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
//    [self.collectionView registerClass:[Cell class] forCellWithReuseIdentifier:@"SpeakerCell"];
    [self.collectionView reloadData];
    self.collectionView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    return [self.speakers count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    Cell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"SpeakerCell" forIndexPath:indexPath];
    cell.speakerName = self.speakers[indexPath.row];
    //cell.label.text = [NSString stringWithFormat:@"%d",indexPath.item];
    return cell;
}

@end
