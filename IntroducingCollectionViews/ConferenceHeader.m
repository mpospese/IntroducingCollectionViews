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

#define ZIG_SIZE 3
#define MARGIN_HORIZONTAL_LARGE 20
#define MARGIN_HORIZONTAL_SMALL 10
#define MARGIN_VERTICAL_LARGE 5
#define MARGIN_VERTICAL_SMALL 3

@interface ConferenceHeader()

@property (strong, nonatomic) IBOutlet UILabel *conferenceNameLabel;
@property (nonatomic, assign, getter = isBackgroundSet) BOOL backgroundSet;
@property (nonatomic, assign, getter = isSmall) BOOL small;
@property (nonatomic, assign) BOOL centerText;
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
        //[self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Apple-Wood"]]];
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
    
    [self.conferenceNameLabel setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Aged-Paper"]]];
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
        
    // put a zig-zag edge like tap cut marks on left and right edges of label
    UIBezierPath *mask = [UIBezierPath bezierPath];
    [mask moveToPoint:CGPointZero];
    CGFloat y = 0;
    BOOL zig = YES;
    // zig-zag down the left edge
    while (y < self.conferenceNameLabel.bounds.size.height)
    {
        y+= ZIG_SIZE;
        [mask addLineToPoint:(CGPoint){zig? ZIG_SIZE : 0, y}];
        zig = !zig;
    }
    [mask addLineToPoint:CGPointMake(self.conferenceNameLabel.bounds.size.width, y)];
    // zig-zag back up the right edge
    while (y > 0)
    {
        y-= ZIG_SIZE;
        [mask addLineToPoint:(CGPoint){self.conferenceNameLabel.bounds.size.width - (zig? ZIG_SIZE : 0), y}];
        zig = !zig;
    }
    
    [mask addLineToPoint:CGPointZero];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = mask.CGPath;
    
    self.conferenceNameLabel.layer.mask = maskLayer;
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
