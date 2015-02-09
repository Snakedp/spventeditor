//
//  SPEventEditVC.h
//  SPEventEditor
//
//  Created by Nikolay Ilin on 12.12.14.
//  Copyright (c) 2014 Soft-Artel.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPEventEditDayVC.h"


@interface SPEventEditVC : UIViewController  <SPEventEditDayDelegate>
{
    SPEventEditDayVC    * dayVC;
    
    UIImageView * bgrSnapshot;
    UIImageView * bgrBlure;
    
    NSDate * date;
    
    CGFloat delta;
}


@property (nonatomic) NSDictionary * note;

@property (weak, nonatomic) IBOutlet UIView *panelBgr;
@property (weak, nonatomic) IBOutlet UIView *panelCalendar;
@property (weak, nonatomic) IBOutlet UIScrollView *panelUI;
@property (weak, nonatomic) IBOutlet UIButton * btnNext;
@property (weak, nonatomic) IBOutlet UIButton * btnPrev;

@property (weak, nonatomic) IBOutlet UILabel *lblDayDate;

+( SPEventEditVC* ) editEvent:(NSDictionary *) note
                  presentedBy:(UIViewController *) vc;

@end
