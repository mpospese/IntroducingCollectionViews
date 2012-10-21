//
//  Cell.m
//  IntroducingCollectionViews
//
//  Created by Mark Pospesel on 10/4/12.
//  Copyright (c) 2012 Mark Pospesel. All rights reserved.
//

#import "Cell.h"
#import <QuartzCore/QuartzCore.h>
#import "MPAnimation.h"
#import "ConferenceLayoutAttributes.h"

@interface Cell()

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
        UIImage *speakerImage = [UIImage imageNamed:speakerName];
        self.speakerImage.image = [MPAnimation renderImage:speakerImage withMargin:10.0 color:[UIColor whiteColor]];
        self.nameLabel.text = speakerName;
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    if (newSuperview)
    {
        self.speakerImage.layer.shadowOpacity = 0.5;
        self.speakerImage.layer.shadowOffset = CGSizeMake(0, 3);
        self.speakerImage.layer.shadowPath = [[UIBezierPath bezierPathWithRect:CGRectInset(self.speakerImage.bounds,1,1)] CGPath];
    }
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    if ([layoutAttributes isKindOfClass:[ConferenceLayoutAttributes class]])
    {
        ConferenceLayoutAttributes *conferenceAttributes = (ConferenceLayoutAttributes *)layoutAttributes;
        self.speakerImage.layer.shadowOpacity = conferenceAttributes.shadowOpacity;
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
