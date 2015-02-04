//
//  SPEventEditDayVC.h
//  SPEventEditor
//
//  Created by Nikolay Ilin on 12.12.14.
//  Copyright (c) 2014 Soft-Artel.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPEventEditDayGrid.h"
#import "SPEventResize.h"

#define  SPNV_DATAP_RANGE 1

#define  SPNV_DATAP_BUZZY_PANEL_SCALE 0.25

#define  SPNV_DATAP_ROWFONT    [UIFont fontWithName:@"HelveticaNeue-UltraLight" size: 21.0f]
#define  SPNV_DATAP_ROWFONTSEL [UIFont fontWithName:@"HelveticaNeue-Light" size: 22.0f]

@protocol SPEventEditDayDelegate <NSObject>
@optional
 - (void) dayGridScroll:(CGFloat) offset;
 - (void) dayGridChangeDate:(NSDate*) date;

 - (void) timeGridScroll:(CGFloat ) offset;
@end

@class SPEventEditDayGrid;

@interface SPEventEditDayVC : UICollectionViewController<UIScrollViewDelegate>
{
    
    //    UITableView *tableView;
    
    NSIndexPath * index;
    
    NSDate * date;
    
    
    
    CGRect  eventViewFrame;
    
    NSInteger eventOffset;
    NSInteger eventDuration;
    
    UIView   * buzzyLine;
    
    BOOL cvSetUp;
    
    int oldRowNum;
    
    SPEventEditDayGrid  * grid;
    SPEventResize * event;
    
}

@property (weak, nonatomic) IBOutlet UIButton * btnNext;
@property (weak, nonatomic) IBOutlet UIButton * btnPrev;
@property (weak, nonatomic) IBOutlet UIView   * buzzyLineContainer;

@property (strong) NSDate * date;
@property (nonatomic) NSInteger eventDuration;
@property (nonatomic) NSInteger eventOffset;

@property (nonatomic, strong) id <SPEventEditDayDelegate> delegate;

//- (SPEventEditVC*)initWithDate:(NSDate*)date;
- (void) scrollToCurrent;

+ (SPEventEditDayVC *) daysCollectionViewIn: (UIView*) panel
                                    andDate:(NSDate *) date
                               withDelegate:(id <SPEventEditDayDelegate>) delegate;

-(void) updateTimeGridScale:(CGFloat) scale;
-(NSString *) timeByGridY:(CGFloat) y;
@end
