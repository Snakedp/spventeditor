//
//  SPEventResize.h
//  SPEventEditor
//
//  Created by Nikolay Ilin on 04.02.15.
//  Copyright (c) 2015 Soft-Artel.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SPEventResizeDelegate <NSObject>

- (CGFloat)     offsetByTime:(NSString *) time;
- (NSString *)  timeByOffset:(CGFloat)    offset;
- (void)        showTimeFrom:(NSString*) start to:(NSString *) end;

@optional

@end


@interface SPEventResize : UIView{
    
    CGFloat offsetStart;
    CGFloat offsetEnd;
    
    
}
@property (weak, nonatomic) IBOutlet UIView *timeLineStartPanel;
@property (weak, nonatomic) IBOutlet UILabel *tlSLbl2;
@property (weak, nonatomic) IBOutlet UILabel *tlSLbl1;

@property (weak, nonatomic) IBOutlet UIView *timeLineEndPanel;
@property (weak, nonatomic) IBOutlet UILabel *tlELbl2;
@property (weak, nonatomic) IBOutlet UILabel *tlELbl1;

@property (weak, nonatomic) IBOutlet UIView *notePanel;

@property (nonatomic) id<SPEventResizeDelegate> delegate;


+(SPEventResize*) eventResizeInPanel:(UIScrollView*) panel andNote:(NSDictionary *) note;
-(void) layout;

@end
