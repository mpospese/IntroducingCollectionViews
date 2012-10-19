//
//  ViewController.h
//  IntroducingCollectionViews
//
//  Created by Mark Pospesel on 10/4/12.
//  Copyright (c) 2012 Mark Pospesel. All rights reserved.
//

#import <UIKit/UIKit.h>

enum {
    SpeakerLayoutGrid,
    SpeakerLayoutLine,
    SpeakerLayoutCoverFlow,
    SpeakerLayoutStacks,
    
    SpeakerLayoutCount
}
typedef SpeakerLayout;

@interface ViewController : UICollectionViewController

@property (nonatomic, assign, readonly) SpeakerLayout layoutStyle;

@end
