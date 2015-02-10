//
//  SPEventResize.m
//  SPEventEditor
//
//  Created by Nikolay Ilin on 04.02.15.
//  Copyright (c) 2015 Soft-Artel.com. All rights reserved.
//

#import "SPEventResize.h"

@implementation SPEventResize

+(SPEventResize*) eventResizeInPanel:(UIScrollView*) panel andNote:(NSDictionary *) note{
    
    SPEventResize *instance =  (SPEventResize*)[[[NSBundle mainBundle] loadNibNamed:@"SPEventResize" owner:panel options:nil] objectAtIndex:0];
    
    instance.scrollMode = NO;
    
    instance.frame = CGRectMake(0, 0, [panel contentSize].width, [panel contentSize].height);//CGRectMake(0, 0, [panel contentSize].width, [panel contentSize].height);// //
    
    instance.delegate = (UIScrollView<SPEventResizeDelegate>* )panel;
    
//    [instance setClipsToBounds:NO];
//
//    [panel addSubview: instance ];
    
    instance.note = note;

    UIPanGestureRecognizer * panNoteGR = [[UIPanGestureRecognizer alloc] initWithTarget:instance action:@selector( panNote: )];
    [instance.notePanel addGestureRecognizer: panNoteGR ];

    UIPanGestureRecognizer * panStartGR = [[UIPanGestureRecognizer alloc] initWithTarget:instance action:@selector( panStartTimeLabel: )];
    [instance.timeLineStartPanel addGestureRecognizer: panStartGR ];

    UIPanGestureRecognizer * panEndGR = [[UIPanGestureRecognizer alloc] initWithTarget:instance action:@selector( panEndTimeLabel: )];
    [instance.timeLineEndPanel addGestureRecognizer: panEndGR ];
    
    return instance;
}

//
//- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    // initialize translation offsets
//    tx = self.transform.tx;
//    ty = self.transform.ty;
//}
//
//- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    UITouch *touch = [touches anyObject];
//    if (touch.tapCount == 3)
//    {
//        // Reset geometry upon triple-tap
//        self.transform = CGAffineTransformIdentity;
//        tx = 0.0f; ty = 0.0f; scale = 1.0f; theta = 0.0f;
//    }
//}


-(void) panNote:(UIPanGestureRecognizer *)sender{
    
    if(!self.scrollMode) return;
    
    CGPoint translation = [sender translationInView:[self superview]];
    
    [sender setTranslation:CGPointMake(0, 0) inView: [self superview] ];
    
    [self moveByDeltaY: translation.y];
}


-(void) panStartTimeLabel:(UIPanGestureRecognizer *)sender{
    
    CGPoint translation = [sender translationInView:[self superview]];
    
    [sender setTranslation:CGPointMake(0, 0) inView: [self superview] ];
    
    [self moveStartByDeltaY: translation.y];
}


-(void) panEndTimeLabel:(UIPanGestureRecognizer *)sender{
    
    CGPoint translation = [sender translationInView:[self superview]];
    
    [sender setTranslation:CGPointMake(0, 0) inView: [self superview] ];
    
    [self moveEndByDeltaY: translation.y];
}



#pragma mark -
#pragma mark Common UI Methods

-(void) layout{

//    [self removeFromSuperview];
    if(!scrollMode)
     [self.delegate showTimeFrom:tS to:tE];   
    
    offsetStart = [self.delegate offsetByTime: tS];
    offsetEnd   = [self.delegate offsetByTime: tE];

    CGRect frm;
    CGFloat paddingOffset = 70;
    CGRect screenRect = self.bounds;//[[UIScreen mainScreen] bounds];
    
    frm.origin.x = paddingOffset;
    frm.origin.y = offsetStart;
    frm.size.width = screenRect.size.width - (paddingOffset*2);
    frm.size.height = offsetEnd - offsetStart;
    
    self.notePanel.frame = frm;
    self.notePanel.layer.masksToBounds = NO;
    
    frm.origin.y = offsetStart - 10 - 2;
    frm.origin.x = 3;
    frm.size.width = screenRect.size.width - paddingOffset;
    frm.size.height = 20;

    self.timeLineStartPanel.frame = frm;
    self.timeLineStartPanel.layer.masksToBounds = NO;

    
    frm.origin.y = offsetEnd - 10 - 1;
    frm.origin.x = paddingOffset-2;
    frm.size.width = screenRect.size.width - paddingOffset;
    frm.size.height = 20;
    
    self.timeLineEndPanel.frame = frm;
    self.timeLineEndPanel.layer.masksToBounds = NO;

    self.tlSLbl1.layer.cornerRadius  = self.tlSLbl2.layer.cornerRadius  = self.tlELbl1.layer.cornerRadius  = self.tlELbl2.layer.cornerRadius = self.durLbl.layer.cornerRadius = 5;
    self.tlSLbl1.layer.masksToBounds = self.tlSLbl2.layer.masksToBounds = self.tlELbl1.layer.masksToBounds = self.tlELbl2.layer.masksToBounds = self.durLbl.layer.masksToBounds =YES;
    
//    self.frame = CGRectMake(0, 0, [panel contentSize].width, 10); self.notePanel.frame;

    
//    self.scrollMode = self.scrollMode;
    
}


-(void) moveByDeltaY:(CGFloat)y{
    
    [self.timeLineStartPanel moveByDeltaX: 0 andY:y  comletion:nil];
    [self.notePanel          moveByDeltaX: 0 andY:y  comletion:nil];
    [self.timeLineEndPanel   moveByDeltaX: 0 andY:y  comletion:nil];
    
    [self updateTimeFromPosition];
}


-(void) moveStartByDeltaY:(CGFloat)y{
    
    [self.timeLineStartPanel moveByDeltaX: 0 andY:y  comletion:nil];
    [self.notePanel          moveByDeltaX: 0 andY:y  comletion:nil];
    [self.notePanel          resizeByDeltaW:0 andH:y*-1 comletion:nil];
    [self updateTimeFromPosition];
}

-(void) moveEndByDeltaY:(CGFloat)y{
    
    [self.timeLineEndPanel moveByDeltaX: 0 andY:y  comletion:nil];
    [self.notePanel        resizeByDeltaW:0 andH:y comletion:nil];
    [self updateTimeFromPosition];
    
}



-(void) updateTimeFromPosition{

    tS =  [self.delegate timeByOffset: self.timeLineStartPanel.frame.origin.y - self.timeLineStartPanel.frame.size.height/2];
    tE =  [self.delegate timeByOffset: self.timeLineEndPanel.frame.origin.y   - self.timeLineEndPanel.frame.size.height/2];
    
    
    long sMin = [[tS componentsSeparatedByString:@":"][0] integerValue]*60 + [[tS componentsSeparatedByString:@":"][1] integerValue];
    long eMin = [[tE componentsSeparatedByString:@":"][0] integerValue]*60 + [[tE componentsSeparatedByString:@":"][1] integerValue];
    
    long dur = (sMin<eMin && eMin - sMin >= EVENT_MIN_DURATION )?eMin - sMin:(sMin>eMin)? (1440 - sMin) + eMin: 15 ;
    
//    dur = abs(floor( eMin % 5 )) * 5;
    
    if(dur> EVENT_MAX_DURATION)
    {
        dur  = EVENT_MAX_DURATION;
        eMin = sMin + EVENT_MAX_DURATION;

        int min = abs(floor( eMin % 60 ));  eMin /= 60;
        int hrs = abs(floor( eMin % 24 ));  eMin /= 24;
        
        tE = [NSString stringWithFormat:@"%d:%d",hrs,min ];
        [self layout];
    }
    
    NSMutableDictionary * newNote = [self.note mutableCopy];
    newNote[@"event_startTime"] = tS;
    newNote[@"event_duration"]  = @(dur);
    self.note = [newNote copy];
}

#pragma mark -
#pragma mark Castom Setters And Getters


-(BOOL) scrollMode{
    return scrollMode;
}

-(void) setScrollMode:(BOOL)sM{
    
    if(!sM)
    {
        
        self.notePanel.shadow = YES;
        self.timeLineStartPanel.shadow = YES;
        self.timeLineEndPanel.shadow = YES;
        
        if(sM != scrollMode ){
            [self.timeLineStartPanel moveByDeltaX: EVENT_SCROLL_X_OFFSET*-1 andY:EVENT_SCROLL_Y_OFFSET*-1  comletion:nil];
            [self.notePanel          moveByDeltaX: EVENT_SCROLL_X_OFFSET*-1 andY:EVENT_SCROLL_Y_OFFSET*-1  comletion:nil];
            [self.timeLineEndPanel   moveByDeltaX: EVENT_SCROLL_X_OFFSET*-1 andY:EVENT_SCROLL_Y_OFFSET*-1  comletion:nil];
        }
    }
    
    else{
        
        
        
        if(sM != scrollMode ){
            
            [self.timeLineStartPanel moveByDeltaX: EVENT_SCROLL_X_OFFSET andY:EVENT_SCROLL_Y_OFFSET comletion:^(BOOL finished) {
                [self.timeLineStartPanel customShadow:@[@-6, @10, @7, @0.3]];
            }];
            [self.notePanel moveByDeltaX: EVENT_SCROLL_X_OFFSET andY:EVENT_SCROLL_Y_OFFSET comletion:^(BOOL finished) {
                [self.notePanel customShadow:@[@-6, @10, @7, @0.3]];
            }];
            [self.timeLineEndPanel moveByDeltaX: EVENT_SCROLL_X_OFFSET andY:EVENT_SCROLL_Y_OFFSET comletion:^(BOOL finished) {
                [self.timeLineEndPanel customShadow:@[@-6, @10, @7, @0.3]];
            }];
        }
        
        
        
    }
    
    scrollMode = sM;
    
    //    self.notePanel.frame = frm;
}


-(NSDictionary *) note{
    return  note;
}

-(void) setNote:(NSDictionary *)n{
    
    if( !n[@"event_startTime"] || !n[@"event_duration"] ) return;
    
    
    tS = n[@"event_startTime"];
    
    tE = [@( ([[n[@"event_startTime"] componentsSeparatedByString:@":"][0] integerValue]*60 + [[n[@"event_startTime"] componentsSeparatedByString:@":"][1] integerValue]+ [n[@"event_duration"] integerValue]) * 60  ) timeFromSeconds];
    
    self.tlSLbl1.text = self.tlSLbl2.text = tS;
    self.tlELbl1.text = self.tlELbl2.text = tE;
    self.durLbl.text =  [@([n[@"event_duration"] integerValue]*60) timeFromSeconds];

    note = n;
    //    [self layout];
    
}



#pragma mark -
#pragma mark Actions


- (IBAction)actToggleScrollMode:(id)sender {
    
    self.scrollMode = !self.scrollMode;
    
}





#pragma mark -
#pragma mark Tools Methods


@end
