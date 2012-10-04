//
//  Cell.m
//  IntroducingCollectionViews
//
//  Created by Mark Pospesel on 10/4/12.
//  Copyright (c) 2012 Mark Pospesel. All rights reserved.
//

#import "Cell.h"

@interface Cell()

@property (weak, nonatomic) IBOutlet UIImageView *speakerImage;

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

- (void)setSpeakerName:(NSString *)speakerName
{
    if (![_speakerName isEqualToString:speakerName])
    {
        _speakerName = speakerName;
        self.speakerImage.image = [UIImage imageNamed:speakerName];
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
