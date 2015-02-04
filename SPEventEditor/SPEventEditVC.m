//
//  SPEventEditVC.m
//  SPEventEditor
//
//  Created by Nikolay Ilin on 12.12.14.
//  Copyright (c) 2014 Soft-Artel.com. All rights reserved.
//

#import "SPEventEditVC.h"
#import "UIView+UIView_Additions.h"
#import "NSDate+Extention.h"

@interface SPEventEditVC ()

@end

@implementation SPEventEditVC

+( SPEventEditVC* ) editEvent:(NSDictionary *) note
                  presentedBy:(UIViewController *) vc{
    
    
    SPEventEditVC * instance = [[SPEventEditVC alloc] initWithNibName:@"SPEventEditVC" bundle:nil];
    
    instance->bgrSnapshot = [[UIImageView alloc] initWithImage: [vc.view snapshot]];
    instance->bgrBlure    = [[UIImageView alloc] initWithImage: [vc.view blure]];
    
    instance->date = [NSDate date];
    
    [vc presentViewController: instance animated:NO
                     completion:^{ }];
    
    return instance;
}



-(void) prepareToShow{
    
    bgrSnapshot.autoresizingMask = UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

    
    bgrBlure.autoresizingMask = UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

    bgrSnapshot.frame = self.view.bounds;
    bgrBlure.frame    = self.view.bounds;
    
    [self.panelBgr addSubview: bgrBlure ];
    [self.panelBgr addSubview: bgrSnapshot ];
    
    self.panelCalendar.alpha = 0;
    self.panelUI.alpha=0;
    
    if( !dayVC )
    {
        dayVC = [SPEventEditDayVC daysCollectionViewIn: self.panelCalendar
                                               andDate: date
                                          withDelegate: self ];
    }
    
}


-(void) show{
    

    
    [self.panelUI       setAnimatedAlpha:1 comletion:^(BOOL finished) {
        [self.panelCalendar setAnimatedAlpha:1];
        [self dayGridChangeDate: date ];
    }];
    
    
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self prepareToShow];
    
}


-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         [bgrSnapshot setAlpha:0];
                     } completion:^(BOOL finished) {
                         [self show];
                     }];


}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [dayVC.collectionView performBatchUpdates:nil completion:nil];
    [dayVC.collectionView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark IBAction Methods

- (IBAction)actEvntEnbl:(id)sender {

    NSLog(@"time:%@", [dayVC timeByGridY: 100 ]);
    
//    [dayVC updateTimeGridScale: 60 ];
    
}

#pragma mark - 
#pragma mark SPEventEditDayDelegate Methods

- (void) dayGridChangeDate:(NSDate*) newDate
{
    date = newDate;
    
    NSString * d = [date stringByFormat:@"d MMMM"];
    NSRange d1R = NSMakeRange(0, d.length);
    
    NSMutableAttributedString * attString  = [[NSMutableAttributedString alloc] initWithString: [[d stringByAppendingFormat:@", %@", [date stringByFormat:@"EEEE" ]] capitalizedString] ];
    
    [attString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:18.0f] range: d1R];

    self.lblDayDate.attributedText = [attString copy];
    
//    [self.lblDayDate setAnimatedAlpha:1];
    
}

- (void) dayGridScroll:(CGFloat) offset{
    
    if(offset>292) offset= 584-offset;
    if(offset<1)   offset=1;
    
    
    CGFloat a = offset/292.00;
    
//    NSLog(@"%.02f Day nyScroll: %.02f",a, offset);
    
    self.lblDayDate.alpha=a;
    
}


-(void) timeGridScroll:(CGFloat)offset{
    
    NSLog(@"%@", [dayVC timeByGridY: offset ] );
//    NSLog(@"Time Scroll: %.02f", offset);

}













@end
