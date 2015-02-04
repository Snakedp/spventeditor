//
//  SPEventEditDayGrid.h
//  SPEventEditor
//
//  Created by Nikolay Ilin on 12.12.14.
//  Copyright (c) 2014 Soft-Artel.com. All rights reserved.
//
#define DRW_PARAMS_H   @"hour"
#define DRW_PARAMS_M2  @"min/2"
#define DRW_PARAMS_M   @"min"

#define DRW_PARAMS_hAttr    @"hFont"
#define DRW_PARAMS_hOffsetX   @"hOffsetX"
#define DRW_PARAMS_hOffsetY   @"hOffsetY"
#define DRW_PARAMS_hLineW   @"hLineW"
#define DRW_PARAMS_hLineOffsetX   @"hLineOffsetX"
#define DRW_PARAMS_hLineColor   @"hLineColor"

#define CAL_ROW_HEIGHT 30.0
#define CAL_TOP_OFFSET 0.0
#define CAL_BOUNDS_OFFSET 50


#import <UIKit/UIKit.h>
#import "SPEventEditDayVC.h"
#import "SPEventResize.h"

@interface SPEventEditDayGrid : UIScrollView <UIScrollViewDelegate, SPEventResizeDelegate>
{
    CGFloat zoomScale;
    
    CGSize    gridSize;
    UIImage * gridImage;
    
    CGFloat  gridOffSet;
    
}

@property (readonly, nonatomic) UIImage * gridImage;

@property (strong,nonatomic) NSDictionary * drawParams;

@property (strong,nonatomic) UIImageView  * calendarGrid;

@property (strong,nonatomic) UIImageView * curTimeView;

@property (nonatomic, strong) id delegateUP;

@property (nonatomic, readwrite) CGFloat zoomScale;

-(void) prepare;

-(NSString *) timeByY:(CGFloat) y;

-(void) setCurrentTimeBy: (NSDate *) date;
-(void) gotoCurentTime;
-(void) gotoTimeBy:(NSDate*) date  animated:(BOOL) animated;



+(SPEventEditDayGrid *) dayGridIn:(UIView *) panel andZoomScale:(CGFloat) zoomScale;

@end
