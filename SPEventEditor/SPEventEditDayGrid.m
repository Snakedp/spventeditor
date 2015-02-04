//
//  SPEventEditDayGrid.m
//  SPEventEditor
//
//  Created by Nikolay Ilin on 12.12.14.
//  Copyright (c) 2014 Soft-Artel.com. All rights reserved.
//

#import "SPEventEditDayGrid.h"

@implementation SPEventEditDayGrid

+(SPEventEditDayGrid *) dayGridIn:(UIView *) panel andZoomScale:(CGFloat) zoomScale{
    
   SPEventEditDayGrid *dayGrid = [[SPEventEditDayGrid alloc] initWithFrame:panel.bounds];
    
    dayGrid->gridSize = panel.bounds.size;
    
    [dayGrid prepare];

    dayGrid.zoomScale = zoomScale;
    
    dayGrid.frame = panel.bounds;
    
    [panel addSubview: dayGrid ];

    return dayGrid;
}

-(void) prepare{

    self.drawParams =
    @{
      DRW_PARAMS_H:@{
              
              
              DRW_PARAMS_hAttr:@{
                      NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Light" size:12.0],
                      NSForegroundColorAttributeName:[UIColor colorWithRed:0.4 green:0.5 blue:0.7 alpha:1]
                      },
              
              
              DRW_PARAMS_hOffsetX: @(5.0),
              DRW_PARAMS_hOffsetY: @(-8.0),
              
              DRW_PARAMS_hLineW: @(1),
              DRW_PARAMS_hLineOffsetX: @(42.0),
              DRW_PARAMS_hLineColor: [UIColor colorWithRed:0.4 green:0.5 blue:0.7 alpha:1],
              },
      
      DRW_PARAMS_M:@{
              
              DRW_PARAMS_hAttr:@{
                      NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Light" size:10.0],
                      NSForegroundColorAttributeName:[UIColor colorWithRed:0.4 green:0.5 blue:0.7 alpha:0.2]
                      },
              
              DRW_PARAMS_hOffsetX: @(14.0),
              DRW_PARAMS_hOffsetY: @(-7.0),
              
              DRW_PARAMS_hLineW: @(1),
              DRW_PARAMS_hLineOffsetX: @(46.0),
              DRW_PARAMS_hLineColor: [UIColor colorWithRed:0.4 green:0.5 blue:0.7 alpha:0.2],
              },
      
      
      DRW_PARAMS_M2:@{
              
              DRW_PARAMS_hAttr:@{
                      NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Light" size:11.0],
                      NSForegroundColorAttributeName:[UIColor colorWithRed:0.4 green:0.5 blue:0.7 alpha:0.5]
                      },
              
              
              DRW_PARAMS_hOffsetX: @(9.0),
              DRW_PARAMS_hOffsetY: @(-8.0),
              
              DRW_PARAMS_hLineW: @(1),
              DRW_PARAMS_hLineOffsetX: @(46.0),
              DRW_PARAMS_hLineColor: [UIColor colorWithRed:0.4 green:0.5 blue:0.7 alpha:0.6],
              },
      
      };

    
    self.contentMode = UIViewContentModeRedraw;
    self.delegate = self;
    
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.bounces = YES;
    
    self.pagingEnabled = NO;
    
    self.backgroundColor = [UIColor clearColor];
    self.directionalLockEnabled = YES;
    
    self.autoresizingMask = UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

    
}


-(CGFloat) zoomScale{
    return zoomScale;
}


-(void) setZoomScale:(CGFloat)zS{
    
    if( zoomScale == zS )
        return;
    
    gridImage = nil;
    
    zoomScale = zS;
    
    if( zoomScale <10 || zoomScale>120)
        zoomScale = 15.0;
    
    
    [self makeGrid];
    
}



- (void) makeGrid{
    

    if( self.calendarGrid )
    {
        [self.calendarGrid removeFromSuperview];
        self.calendarGrid = nil;
    }
    
    
    self.calendarGrid = [[UIImageView alloc] initWithImage: self.gridImage ];
    
    
    CGRect frm = self.calendarGrid.frame;
    
    frm.origin.y = gridOffSet * -1 + CAL_BOUNDS_OFFSET;
//    frm.size.height = frm.size.height - gridOffSet;
  
    self.calendarGrid.frame = frm;
    

    frm.size.height = frm.size.height - (gridOffSet*2) + CAL_BOUNDS_OFFSET*2;
    
    gridSize = frm.size;
    
    [self setContentSize: gridSize];
    
    [self addSubview: self.calendarGrid];
    [self setBackgroundColor:[UIColor clearColor]];
    
    
    if(! self.curTimeView)
    {
        self.curTimeView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"redLine"]];
        
        [self addSubview: self.curTimeView];
    }
    
    [self setCurrentTime];
    
    
    [NSTimer scheduledTimerWithTimeInterval:60
                                     target:self
                                   selector:@selector(setCurrentTime)
                                   userInfo:nil
                                    repeats:YES];
    
    
}


-(NSString *) timeTitleFor:(NSInteger) hrs andMin:(NSInteger) min{
    return [NSString stringWithFormat:@"%@:%@", [NSString stringWithFormat:((hrs>9)?@"%ld": @"0%ld"), (long)hrs ], [NSString stringWithFormat:((min>9)?@"%ld": @"0%ld"), (long)min ]];
}


- (UIImage *) gridImage{
    
    
    if( gridImage != nil)
        return  gridImage;
    

    if( !self.drawParams)
        [self prepare];
    

    UIImage *bgr = [UIImage imageNamed:@"bgr-grid.jpg"];


    CGFloat gHight = ( (1560/zoomScale)*CAL_ROW_HEIGHT ) + CAL_ROW_HEIGHT ;
    

    CGSize gSize = CGSizeMake( gridSize.width , gHight );
    
    if ([UIScreen instancesRespondToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] > 1.0f) {
        UIGraphicsBeginImageContextWithOptions(gSize, NO, [[UIScreen mainScreen] scale]);
    } else {
        UIGraphicsBeginImageContext(gSize);
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);

    CGContextDrawTiledImage(context,CGRectMake(0, 0, bgr.size.width, bgr.size.height) , [bgr CGImage]);
    

    CGFloat yRow = CAL_TOP_OFFSET;
    gridOffSet = -1;
    
    for (int row = -60; row <= 1500 ; row+= zoomScale ) {
        
        int x = row;
        
        int min = abs(floor( x % 60 ));  x /= 60;
        int hrs = abs(floor( x % 24 ));  x /= 24;
        

        NSString * type = DRW_PARAMS_M;
        
        if( min == 0)  type = DRW_PARAMS_H;
        if( min == 30) type = DRW_PARAMS_M2;
        
        NSDictionary * dP = self.drawParams[ type ];
        
        if( dP )
        {
            CGContextBeginPath(context);
            
            
            yRow += CAL_ROW_HEIGHT;// + [dP[ DRW_PARAMS_hLineW ] floatValue];
            
            
            //Draw Titles
            NSString * time = [self timeTitleFor:hrs andMin:min];
            
            [time drawAtPoint: CGPointMake([dP[DRW_PARAMS_hOffsetX] floatValue] , yRow + [dP[DRW_PARAMS_hOffsetY] floatValue])
               withAttributes: dP[DRW_PARAMS_hAttr]
             ];
            
            
            CGContextSetLineWidth(context,[dP[DRW_PARAMS_hLineW] integerValue]);
            CGContextSetStrokeColorWithColor(context, [dP[DRW_PARAMS_hLineColor] CGColor]);
            
            CGContextMoveToPoint(context, [dP[DRW_PARAMS_hLineOffsetX] floatValue], yRow);
            CGContextAddLineToPoint(context, gSize.width - [dP[DRW_PARAMS_hLineOffsetX] floatValue], yRow);

            [time drawAtPoint: CGPointMake(gSize.width - [dP[DRW_PARAMS_hLineOffsetX] floatValue] + 3 , yRow + [dP[DRW_PARAMS_hOffsetY] floatValue])
               withAttributes: dP[DRW_PARAMS_hAttr]
             ];
            
//            NSLog(@"yRow:%f hrs: %d   min: %d  %@", yRow, hrs, min, type);
            
            CGContextDrawPath(context, kCGPathStroke);
            
        }
        else
        {
            NSLog(@"ERROR!!!");
        }
        
        if( gridOffSet == -1 && row>=0 )
            gridOffSet = yRow;
        
    }



    UIGraphicsPopContext();

    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
    //    return [[UIImage alloc] initWithCGImage:[outputImage CGImage] scale:scale orientation:[outputImage imageOrientation]];
    return outputImage;
}



-(NSString *) timeByY:(CGFloat) y{
    
    y-=CAL_BOUNDS_OFFSET;
    
    int x = (y/CAL_ROW_HEIGHT)*zoomScale;

    int min = abs(floor( x % 60 ));  x /= 60;
    int hrs = abs(floor( x % 24 ));  x /= 24;

    return [self timeTitleFor:hrs andMin:min];
}





#pragma mark - Calendar View

-(void) gotoCurentTime{
//    CGFloat yPos = self.curTimeLine.floatValue - self.bounds.size.height/2 - self.cniTopOffset.floatValue*2;
//    if (yPos<0) {
//        yPos=0;
//    } else if (yPos > 2450 - self.frame.size.height/2) {
//        yPos = 2450 - self.frame.size.height;
//    }
//    
//    
//    [self setContentOffset:CGPointMake(0,yPos)  animated:YES];
    
}

-(void) gotoTimeBy:(NSDate*) date animated:(BOOL) animated{
    
//    NSDate * cniDate= date;
//    CGFloat rowInMinutes = 60/(1/self.cniTimeScale.floatValue);
//    
//    
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setTimeZone:[NSTimeZone localTimeZone]];
//    [formatter setDateFormat:@"HH"];
//    NSString *tstr = [formatter stringFromDate:cniDate];
//    
//    
//    
//    CGFloat numHours = [tstr floatValue];
//    
//    [formatter setDateFormat:@"mm"];
//    tstr= [formatter stringFromDate:cniDate];
//    
//    
//    CGFloat numMinut = [tstr  floatValue];
//    
//    CGFloat sumMinut = numHours * 60 + numMinut;
//    
//    CGFloat noteY =  _cniRowHigth.floatValue/rowInMinutes * sumMinut + _cniTopOffset.intValue/2;
//    
//    CGFloat yPos = noteY - self.bounds.size.height/2 - self.cniTopOffset.floatValue*2 + 150;
//    if (yPos < 0) {
//        yPos = 0;
//    }
//    else if (yPos > 2500 - self.frame.size.height) {
//        yPos = 2500 - self.frame.size.height-100;
//    }
//    
//    dispatch_sync(dispatch_get_main_queue(), ^{
//        [self setContentOffset:CGPointMake(0, yPos) animated:animated];
//    });
//    
}


-(void) setCurrentTime{
    
    [self setCurrentTimeBy:[NSDate date]];
    
}
-(void) setCurrentTimeBy: (NSDate *) date{
//    
//    NSDate * cniDate= date;
//    CGFloat rowInMinutes = 60/(1/self.cniTimeScale.floatValue);
//    
//    
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setTimeZone:[NSTimeZone localTimeZone]];
//    [formatter setDateFormat:@"HH"];
//    NSString *tstr = [formatter stringFromDate:cniDate];
//    
//    
//    
//    CGFloat numHours = [tstr floatValue];
//    
//    [formatter setDateFormat:@"mm"];
//    tstr= [formatter stringFromDate:cniDate];
//    
//    
//    CGFloat numMinut = [tstr  floatValue];
//    
//    CGFloat sumMinut = numHours * 60 + numMinut;
//    
//    //  if( sumMinut % rowInMinutes > rowInMinutes/2)
//    //  {
//    //      sumMinut = (sumMinut / rowInMinutes +1) * rowInMinutes;
//    //  }
//    
//    
//    
//    
//    CGFloat noteY =  _cniRowHigth.floatValue/rowInMinutes * sumMinut + _cniTopOffset.intValue/2;
//    
//    [self setCurTimeLine:[NSNumber numberWithFloat:noteY]];
//    
//    self.curTimeView.frame = CGRectMake(45, noteY-5, 1130,10);
//    [self bringSubviewToFront:self.curTimeView];
    
}





#pragma mark - Calendar View

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if( self.delegateUP )
        [self.delegateUP timeGridScroll: scrollView.contentOffset.y ];
    
    
//    [self endEditing:YES];
//    
//    CGPoint contOffset = scrollView.contentOffset;
//    
//    if( contOffset.y < 0 ) contOffset.y = 0;
//    
//    if( contOffset.y >= 0 )
//    {
    
//        CGRect lblRect;
//        NSArray * cells = [self.tableView visibleCells];
//        
//        for(int i=0; i< cells.count; i++)
//        {
//            
//            lblRect = [[[cells objectAtIndex:i] lblDate] frame];
//            lblRect.origin.y = contOffset.y+9;
//            [[[cells objectAtIndex:i] lblDate] setFrame:lblRect];
//            
//            lblRect = [[[cells objectAtIndex:i] lblDate2] frame];
//            lblRect.origin.y = contOffset.y+9;
//            [[[cells objectAtIndex:i] lblDate2] setFrame:lblRect];
//            
//            lblRect = [[[cells objectAtIndex:i] imvDatePanel] frame];
//            lblRect.origin.y = contOffset.y;
//            [[[cells objectAtIndex:i] imvDatePanel] setFrame:lblRect];    
//            
//        }
        
        //    NSLog(@"x:%f y:%f", contOffset.x, contOffset.x);
//    }
}






#pragma mark -
#pragma mark SPEventResizeDelegate

- (CGFloat)     offsetByTime:(NSString *) time{
    
    NSArray * t = [time componentsSeparatedByString:@":"];
    
    int hrs = [t[0] integerValue];
    int min = [t[1] integerValue];
    
    int minutes = hrs * 60 + min;
    
    return (minutes / self.zoomScale) * CAL_ROW_HEIGHT + CAL_BOUNDS_OFFSET;
}


- (NSString *)  timeByOffset:(CGFloat)    offset{
    return [self timeByY: offset];
}



@end
