//
//  ConferenceHeader.m
//  IntroducingCollectionViews
//
//  Created by Mark Pospesel on 10/8/12.
//  Copyright (c) 2012 Mark Pospesel. All rights reserved.
//

#import "ConferenceHeader.h"
#import "Conference.h"
#import <QuartzCore/QuartzCore.h>
#import "ConferenceLayoutAttributes.h"
#import "MaskingTapeView.h"

#define MARGIN_HORIZONTAL_LARGE 20
#define MARGIN_HORIZONTAL_SMALL 10
#define MARGIN_VERTICAL_LARGE 5
#define MARGIN_VERTICAL_SMALL 3

@interface ConferenceHeader()

@property (strong, nonatomic) IBOutlet UILabel *conferenceNameLabel;
@property (nonatomic, assign, getter = isBackgroundSet) BOOL backgroundSet;
@property (nonatomic, assign, getter = isSmall) BOOL small;
@property (nonatomic, assign) BOOL centerText;
@property (nonatomic, strong) MaskingTapeView *backgroundView;

@end

@implementation ConferenceHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _conferenceNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 6, frame.size.width, 13)];
        _conferenceNameLabel.font = [UIFont fontWithName:@"Courier-Bold" size:24];
        _conferenceNameLabel.textColor = [UIColor blackColor];
        _conferenceNameLabel.textAlignment = NSTextAlignmentCenter;
        [self setBackground];
        [self addSubview:_conferenceNameLabel];
        _small = NO;
        _centerText = NO;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        _small = NO;
        _centerText = NO;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    if ([layoutAttributes isKindOfClass:[ConferenceLayoutAttributes class]])
    {
        ConferenceLayoutAttributes *conferenceAttributes = (ConferenceLayoutAttributes *)layoutAttributes;
        self.centerText = conferenceAttributes.headerTextAlignment == NSTextAlignmentCenter;
    }    
}


- (void)setBackground
{
    if (self.isBackgroundSet)
        return;
    
    _backgroundView = [[MaskingTapeView alloc] initWithFrame:self.conferenceNameLabel.bounds];
    [self insertSubview:_backgroundView belowSubview:self.conferenceNameLabel];
    [self.conferenceNameLabel setBackgroundColor:[UIColor clearColor]];
    
    [self setBackgroundSet:YES];
}

- (CGFloat)horizontalMargin
{
    return self.isSmall? MARGIN_HORIZONTAL_SMALL : MARGIN_HORIZONTAL_LARGE;
}

- (CGFloat)verticalMargin
{
    return self.isSmall? MARGIN_VERTICAL_SMALL : MARGIN_VERTICAL_LARGE;
}

- (void)layoutSubviews
{
    [self.conferenceNameLabel sizeToFit];
    CGRect labelBounds = CGRectInset(self.conferenceNameLabel.bounds, -[self horizontalMargin], -[self verticalMargin]);
    
    if (self.centerText)
    {
        self.conferenceNameLabel.bounds = (CGRect){CGPointZero, labelBounds.size};
        self.conferenceNameLabel.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    }
    else
    {
        CGFloat leftMargin = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad? 20 : 5;
        self.conferenceNameLabel.frame = (CGRect){{leftMargin, roundf((self.bounds.size.height - labelBounds.size.height)/2)}, labelBounds.size};
    }
    
    [self.backgroundView setFrame:self.conferenceNameLabel.frame];
}

#pragma mark - Properties

- (void)setCenterText:(BOOL)centerText
{
    _centerText = centerText;
    [self setNeedsLayout];
}

- (void)setConference:(Conference *)conference
{
    [self setBackground];
    self.conferenceNameLabel.text = conference.name;
    [self layoutSubviews];        
}

@end

NSString *kSmallConferenceHeaderKind = @"ConferenceHeaderSmall";

@implementation SmallConferenceHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.conferenceNameLabel.font = [UIFont fontWithName:@"Courier-Bold" size:13];
        self.small = YES;
        self.centerText = YES;
    }
    return self;
}

+ (NSString *)kind
{
    return (NSString *)kSmallConferenceHeaderKind;
}

@end
