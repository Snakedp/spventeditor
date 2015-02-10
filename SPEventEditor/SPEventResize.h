//
//  SPEventResize.h
//  SPEventEditor
//
//  Created by Nikolay Ilin on 04.02.15.
//  Copyright (c) 2015 Soft-Artel.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+UIView_Additions.h"
#import "NSNumber+Additions.h"

#define EVENT_SCROLL_X_OFFSET 3
#define EVENT_SCROLL_Y_OFFSET -5
#define EVENT_MIN_DURATION 15
#define EVENT_MAX_DURATION 1200

@protocol SPEventResizeDelegate <NSObject>

- (CGFloat)     offsetByTime:(NSString *) time;
- (NSString *)  timeByOffset:(CGFloat)    offset;
- (void)        showTimeFrom:(NSString*) start to:(NSString *) end;

@optional

@end


@interface SPEventResize : UIView <UIGestureRecognizerDelegate>{
    
    CGFloat offsetStart;
    CGFloat offsetEnd;
    NSDictionary * note;
    BOOL scrollMode;
    
    NSString * tS;
    NSString * tE;
    
    CGFloat oldPanPosition;
}

@property (nonatomic) NSDictionary * note;

@property (nonatomic) BOOL scrollMode;

@property (weak, nonatomic) IBOutlet UIView *timeLineStartPanel;
@property (weak, nonatomic) IBOutlet UILabel *tlSLbl2;
@property (weak, nonatomic) IBOutlet UILabel *tlSLbl1;

@property (weak, nonatomic) IBOutlet UIView *timeLineEndPanel;
@property (weak, nonatomic) IBOutlet UILabel *tlELbl2;
@property (weak, nonatomic) IBOutlet UILabel *tlELbl1;

@property (weak, nonatomic) IBOutlet UIView *notePanel;
@property (weak, nonatomic) IBOutlet UITextView *noteMsg;
@property (weak, nonatomic) IBOutlet UILabel *durLbl;

@property (nonatomic) id<SPEventResizeDelegate> delegate;


+(SPEventResize*) eventResizeInPanel:(UIScrollView*) panel andNote:(NSDictionary *) note;
-(void) layout;
-(void) moveByDeltaY:(CGFloat)y;

@end
