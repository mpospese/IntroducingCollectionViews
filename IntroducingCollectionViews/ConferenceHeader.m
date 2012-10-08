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

#define ZIG_SIZE 3

@interface ConferenceHeader()

@property (weak, nonatomic) IBOutlet UILabel *conferenceNameLabel;

@end

@implementation ConferenceHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        //[self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Apple-Wood"]]];
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

- (void)setConference:(Conference *)conference
{
    [self.conferenceNameLabel setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Aged-Paper"]]];
    self.conferenceNameLabel.text = conference.name;
    [self.conferenceNameLabel sizeToFit];
    CGRect labelBounds = CGRectInset(self.conferenceNameLabel.bounds, -20, -5);
    CGRect labelFrame = (CGRect){{20, roundf((self.bounds.size.height - labelBounds.size.height)/2)}, labelBounds.size};
    
    self.conferenceNameLabel.frame = labelFrame;
    
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
