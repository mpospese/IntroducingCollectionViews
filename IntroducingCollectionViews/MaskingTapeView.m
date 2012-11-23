
//
//  MaskingTapeView.m
//  IntroducingCollectionViews
//
//  Created by Mark Pospesel on 11/23/12.
//  Copyright (c) 2012 Mark Pospesel. All rights reserved.
//

#import "MaskingTapeView.h"

#define ZIG_SIZE 3

@interface MaskingTapeView()

@property (nonatomic, strong) UIColor *tapeColor;

@end

@implementation MaskingTapeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        _tapeColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Aged-Paper"]];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    UIBezierPath *mask = [UIBezierPath bezierPath];
    [mask moveToPoint:CGPointZero];
    CGFloat y = 0;
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    BOOL zig = YES;
    // zig-zag down the left edge
    while (y < height)
    {
        y+= ZIG_SIZE;
        [mask addLineToPoint:(CGPoint){zig? ZIG_SIZE : 0, y}];
        zig = !zig;
    }
    [mask addLineToPoint:CGPointMake(width, y)];
    // zig-zag back up the right edge
    while (y > 0)
    {
        y-= ZIG_SIZE;
        [mask addLineToPoint:(CGPoint){width - (zig? ZIG_SIZE : 0), y}];
        zig = !zig;
    }
    
    [mask addLineToPoint:CGPointZero];
    [self.tapeColor set];
    [mask fill];
}


@end
