//
//  CocoaConf.m
//  IntroducingCollectionViews
//
//  Created by Mark Pospesel on 10/8/12.
//  Copyright (c) 2012 Mark Pospesel. All rights reserved.
//

#import "CocoaConf.h"
#import "Conference.h"
#import "SpeakerCell.h"
#import "ConferenceHeader.h"
#import "StarRatingFooter.h"

NSString *kConferenceHeaderID = @"ConferenceHeader";
NSString *kConferenceHeaderSmallID = @"ConferenceHeaderSmall";
NSString *kSpeakerCellID = @"SpeakerCell";
NSString *kStarRatingFooterID = @"StarRatingFooter";

@interface CocoaConf()

@property (nonatomic, strong) NSArray *conferences;

- (id)initWithConferences:(NSArray *)conferences;

@end

@implementation CocoaConf

- (id)initWithConferences:(NSArray *)conferences
{
    self = [super init];
    if (self)
    {
        _conferences = conferences;
    }
    return self;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.conferences count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section < 0 || section >= self.conferences.count)
        return 0;
    
    return [[self.conferences[section] speakers] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    
    SpeakerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSpeakerCellID forIndexPath:indexPath];
    
    cell.speakerName = [self.conferences[section] speakers][indexPath.item];
    
    return cell;
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;

    if ([kind isEqualToString:UICollectionElementKindSectionFooter])
    {
        StarRatingFooter *footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kStarRatingFooterID forIndexPath:indexPath];
        return footer;
    }
    
    BOOL isSmall = [kind isEqualToString:[SmallConferenceHeader kind]];
    ConferenceHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:isSmall? kConferenceHeaderSmallID : kConferenceHeaderID forIndexPath:indexPath];
    
    [header setConference:self.conferences[section]];
    
    return header;
}

#pragma mark - Private Class Methods

+ (Conference *)columbus2011
{
    return[ Conference conferenceWithName:@"CocoaConf Columbus 2011" startDate:[NSDate dateWithYear:2011 month:8 day:11] duration:3 speakers:@[@"Chris Adamson", @"Randy Beiter", @"Craig Castelaz", @"Mark Dalrymple", @"Bill Dudney", @"Mark Gilicinski", @"Chris Judd", @"Dave Koziol", @"Mac Liaw", @"Steve Madsen", @"Jonathan Penn", @"Doug Sjoquist", @"Josh Smith", @"Daniel Steinberg"]];
}

+ (Conference *)raleigh2011
{
    return [Conference conferenceWithName:@"CocoaConf Raleigh 2011" startDate:[NSDate dateWithYear:2011 month:12 day:1] duration:3 speakers:@[@"Chris Adamson", @"Jeff Biggus", @"Collin Donnell", @"Bill Dudney", @"Nathan Eror", @"Andy Hunt", @"Andria Jensen", @"Josh Johnson", @"Chris Judd", @"Saul Mora", @"Jonathan Penn", @"Jared Richardson", @"Josh Smith", @"Daniel Steinberg"]];
}

+ (Conference *)chicago2012
{
    return [Conference conferenceWithName:@"CocoaConf Chicago 2012" startDate:[NSDate dateWithYear:2012 month:3 day:15] duration:3 speakers:@[@"Chris Adamson", @"Randy Beiter", @"Jeff Biggus", @"Jonathan Blocksom", @"Heath Borders", @"Brian Coyner", @"Bill Dudney", @"Dave Koziol", @"Brad Larson", @"Eric Meyer", @"Jonathan Penn", @"Boisy Pitre", @"Mark Pospesel", @"Josh Smith", @"Daniel Steinberg", @"Whitney Young"]];
}

+ (Conference *)dc2012
{
    return [Conference conferenceWithName:@"CocoaConf DC 2012" startDate:[NSDate dateWithYear:2012 month:6 day:28] duration:3 speakers:@[@"Chris Adamson", @"Mike Ash", @"Jonathan Blocksom", @"Step Christopher", @"Mark Dalrymple", @"Jason Hunter", @"Chris Judd", @"Jonathan Lehr", @"Scott McAlister", @"Saul Mora", @"Jonathan Penn", @"Mark Pospesel", @"Jonathan Saggau", @"Chad Sellers", @"David Smith", @"Daniel Steinberg", @"Walter Tyree", @"Whitney Young"]];
}

+ (Conference *)columbus2012
{
    return [Conference conferenceWithName:@"CocoaConf Columbus 2012" startDate:[NSDate dateWithYear:2012 month:9 day:11] duration:3 speakers:@[@"Josh Abernathy", @"Chris Adamson", @"Randy Beiter", @"Brian Coyner", @"Mark Dalrymple", @"Bill Dudney", @"Jason Felice", @"Geoff Goetz", @"Chris Judd", @"Jeff Kelley", @"Dave Koziol", @"Steve Madsen", @"Kevin Munc", @"Jaimee Newberry", @"Jonathan Penn", @"Doug Sjoquist", @"Josh Smith", @"Daniel Steinberg", @"Mattt Thompson"]];
}

+ (Conference *)portland2012
{
    // reduces list for screenshots
    //return [Conference conferenceWithName:@"CocoaConf Portland 2012" startDate:[NSDate dateWithYear:2012 month:10 day:25] duration:3 speakers:@[@"Josh Abernathy", @"Tim Burks", @"James Dempsey", @"Collin Donnell", @"Andria Jensen", @"Justin Miller", @"Jaimee Newberry", @"Janine Ohmer", @"Elizabeth Taylor"]];
    return [Conference conferenceWithName:@"CocoaConf Portland 2012" startDate:[NSDate dateWithYear:2012 month:10 day:25] duration:3 speakers:@[@"Josh Abernathy", @"Chris Adamson", @"Tim Burks", @"James Dempsey", @"Collin Donnell", @"Pete Hodgson", @"Andria Jensen", @"Justin Miller", @"Saul Mora", @"Jaimee Newberry", @"Janine Ohmer", @"Daniel Pasco", @"Jonathan Penn", @"Mark Pospesel", @"Ben Scheirman", @"Brent Simmons", @"Josh Smith", @"Daniel Steinberg", @"Elizabeth Taylor", @"Mattt Thompson"]];
}

+ (Conference *)raleigh2012
{
    // reduces list for screenshots
    //return [Conference conferenceWithName:@"CocoaConf Raleigh 2012" startDate:[NSDate dateWithYear:2012 month:11 day:29] duration:3 speakers:@[@"Ameir Al-Zoubi", @"Ken Auer", @"Kevin Conner", @"Jack Cox", @"Josh Johnson", @"Scott McAlister", @"Rob Napier", @"Josh Nozzi", @"Jay Thrash", @"Walter Tyree"]];
    return [Conference conferenceWithName:@"CocoaConf Raleigh 2012" startDate:[NSDate dateWithYear:2012 month:11 day:29] duration:3 speakers:@[@"Chris Adamson", @"Ameir Al-Zoubi", @"Ken Auer", @"Jonathan Blocksom", @"Kevin Conner", @"Jack Cox", @"Mark Dalrymple", @"Bill Dudney", @"Aaron Hillegass", @"Josh Johnson", @"Chris Judd", @"Scott McAlister", @"Rob Napier", @"Josh Nozzi", @"Jonathan Penn", @"Mark Pospesel", @"Daniel Steinberg", @"Jay Thrash", @"Walter Tyree"]];
}

+ (Conference *)chicago2013
{
    return [Conference conferenceWithName:@"CocoaConf Chicago 2013" startDate:[NSDate dateWithYear:2013 month:3 day:7] duration:3 speakers:@[@"Chris Adamson", @"Brandon Alexander", @"Randy Beiter", @"Jeff Biggus", @"James Dempsey", @"Aaron Douglas", @"Nathan Eror", @"Chris Judd", @"Peter Kananen", @"Dave Koziol", @"Ben Lachman", @"Jaimee Newberry", @"Jonathan Penn", @"Charles Perry", @"Boisy Pitre", @"Ben Scheirman", @"Josh Smith", @"Daniel Steinberg", @"Brittany Tarvin", @"Elizabeth Taylor", @"Josh Twist", @"Whitney Young"]];
}

+ (Conference *)dc2013
{
    // reduces list for screenshots
    //return [Conference conferenceWithName:@"CocoaConf DC 2013" startDate:[NSDate dateWithYear:2012 month:6 day:28] duration:3 speakers:@[@"Ken Auer", @"Jack Cox", @"Kevin Kim", @"Bob McCune", @"Rob Napier", @"Jaimee Newberry", @"Chris Risner", @"Chad Sellers", @"Doug Sjoquist", @"Walter Tyree", @"TJ Usiyan"]];
    return [Conference conferenceWithName:@"CocoaConf DC 2013" startDate:[NSDate dateWithYear:2013 month:3 day:21] duration:3 speakers:@[@"Chris Adamson", @"Ken Auer", @"Jonathan Blocksom", @"Jack Cox", @"Mark Dalrymple", @"Bill Dudney", @"Kevin Kim", @"Jeff LaMarche", @"Bob McCune", @"Rob Napier", @"Jaimee Newberry", @"Mark Pospesel", @"Chris Risner", @"Chad Sellers", @"Doug Sjoquist", @"Daniel Steinberg", @"Walter Tyree", @"TJ Usiyan", @"Ray Wenderlich"]];
}

+ (Conference *)dallas2013
{
    return [Conference conferenceWithName:@"CocoaConf Dallas 2013" startDate:[NSDate dateWithYear:2013 month:4 day:4] duration:3 speakers:@[@"Patrick Burleson", @"Rene Cacheaux", @"James Dempsey", @"Bill Dudney", @"Nathan Eror", @"Kevin Harwood", @"Kevin Kim", @"Sean McMains", @"Saul Mora", @"Daniel Pasco", @"Jonathan Penn", @"Manton Reece", @"Kyle Richter", @"Cesare Rocchi", @"Ben Scheirman", @"Doug Sjoquist", @"Daniel Steinberg", @"Conrad Stoll", @"Josh Twist", @"Walter Tyree"]];
}

+ (Conference *)sanJose2013
{
    // reduces list for screenshots
    //return [Conference conferenceWithName:@"CocoaConf San Jose 2013" startDate:[NSDate dateWithYear:2013 month:4 day:21] duration:3 speakers:@[@"Matt Drance", @"Bill Dudney", @"Bob McCune", @"Kyle Richter", @"Michael Simmons", @"Michele Titolo", @"Marcus Zarra", @"Daniel Pasco", @"Jaimee Newberry", @"James Dempsey"]];
    return [Conference conferenceWithName:@"CocoaConf San Jose 2013" startDate:[NSDate dateWithYear:2013 month:4 day:21] duration:3 speakers:@[@"Chris Adamson", @"James Dempsey", @"Matt Drance", @"Bill Dudney", @"Nathan Eror", @"Mattieu Gamache-Asselin", @"Pete Hodgson", @"Jeff LaMarche", @"Ben Lachman", @"Bob McCune", @"Saul Mora", @"Jaimee Newberry", @"Daniel Pasco", @"Jonathan Penn", @"Mark Pospesel", @"Kyle Richter", @"Michael Simmons", @"Josh Smith", @"Daniel Steinberg", @"Elizabeth Taylor", @"Michele Titolo", @"Marcus Zarra"]];
}

#pragma mark - Class Methods

+ (CocoaConf *)combined
{
    static dispatch_once_t once;
    static id combinedCocoaConfs;
    dispatch_once(&once, ^{
        combinedCocoaConfs = [[self alloc] initWithConferences:@[[Conference conferenceWithName:@"CocoaConf" startDate:[NSDate dateWithYear:2011 month:8 day:11] duration:3 speakers:@[@"Josh Abernathy", @"Chris Adamson", @"Ameir Al-Zoubi", @"Mike Ash", @"Ken Auer", @"Randy Beiter", @"Jeff Biggus", @"Jonathan Blocksom", @"Heath Borders", @"Tim Burks", @"Craig Castelaz", @"Step Christopher", @"Kevin Conner", @"Jack Cox", @"Brian Coyner", @"Mark Dalrymple", @"James Dempsey", @"Collin Donnell", @"Bill Dudney", @"Nathan Eror", @"Jason Felice", @"Mark Gilicinski", @"Geoff Goetz", @"Aaron Hillegass", @"Pete Hodgson", @"Andy Hunt", @"Jason Hunter", @"Andria Jensen", @"Josh Johnson", @"Chris Judd", @"Jeff Kelley", @"Dave Koziol", @"Brad Larson", @"Jonathan Lehr", @"Mac Liaw", @"Steve Madsen", @"Scott McAlister", @"Eric Meyer", @"Justin Miller", @"Saul Mora", @"Kevin Munc", @"Rob Napier", @"Jaimee Newberry", @"Josh Nozzi", @"Janine Ohmer", @"Daniel Pasco", @"Jonathan Penn", @"Boisy Pitre", @"Mark Pospesel", @"Jared Richardson", @"Jonathan Saggau", @"Ben Scheirman", @"Chad Sellers", @"Brent Simmons", @"Doug Sjoquist", @"Josh Smith", @"David Smith", @"Daniel Steinberg", @"Elizabeth Taylor", @"Mattt Thompson", @"Jay Thrash", @"Walter Tyree", @"Whitney Young"]]]];
    });
    
    return combinedCocoaConfs;
}

+ (CocoaConf *)all
{
    static dispatch_once_t once;
    static id allCocoaConfs;
    dispatch_once(&once, ^{
        allCocoaConfs = [[self alloc] initWithConferences:@[[self sanJose2013], [self dallas2013], [self dc2013], [self chicago2013], [self raleigh2012], [self portland2012], [self columbus2012], [self dc2012], [self chicago2012], [self raleigh2011], [self columbus2011]]];
    });
    
    return allCocoaConfs;
}

+ (CocoaConf *)currentCocoaConf
{
    static dispatch_once_t once;
    static id current;
    dispatch_once(&once, ^{
        current = [[self alloc] initWithConferences:@[[self dc2013]]];
    });
    
    return current;
}

+ (CocoaConf *)recent
{
    static dispatch_once_t once;
    static id recentCocoaConfs;
    dispatch_once(&once, ^{
        recentCocoaConfs = [[self alloc] initWithConferences:@[[self dc2013], [self chicago2013]]];
    });
    
    return recentCocoaConfs;
}

+ (NSString *)smallHeaderReuseID
{
    return kConferenceHeaderSmallID;
}

- (BOOL)deleteSpeakerAtPath:(NSIndexPath *)indexPath
{
    if (indexPath.section < 0 || indexPath.section >= self.conferences.count)
        return NO;

    Conference* conference = self.conferences[indexPath.section];
    return [conference deleteSpeakerAtIndex:indexPath.item];
}

- (BOOL)restoreSpeakerInSection:(int)section
{
    if (section < 0 || section >= self.conferences.count)
        return NO;
    
    Conference* conference = self.conferences[section];
    return [conference restoreSpeaker];
}

@end
