//
//  Cell.m
//  IntroducingCollectionViews
//
//  Created by Mark Pospesel on 10/4/12.
//  Copyright (c) 2012 Mark Pospesel. All rights reserved.
//

#import "Cell.h"
#import <QuartzCore/QuartzCore.h>

@interface Cell()

@property (weak, nonatomic) IBOutlet UIView *photoBorder;
@property (weak, nonatomic) IBOutlet UIImageView *speakerImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation Cell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor = [UIColor underPageBackgroundColor];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        //self.contentView.backgroundColor = [UIColor underPageBackgroundColor];
    }
    return self;
}

- (void)setSpeakerName:(NSString *)speakerName
{
    if (![_speakerName isEqualToString:speakerName])
    {
        _speakerName = speakerName;
        self.speakerImage.image = [UIImage imageNamed:speakerName];
        self.nameLabel.text = speakerName;
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    if (newSuperview)
    {
        self.photoBorder.layer.shadowOpacity = 0.75;
        self.photoBorder.layer.shadowOffset = CGSizeMake(0, 3);
        self.photoBorder.layer.shadowPath = [[UIBezierPath bezierPathWithRect:_photoBorder.bounds] CGPath];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
