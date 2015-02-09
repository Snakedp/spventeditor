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
    
    [instance setClipsToBounds:NO];

    [panel addSubview: instance ];
    
    instance.note = note;
    
    return instance;
}


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
    
    
    frm.origin.y = offsetStart - 10 - 2;
    frm.origin.x = 0;
    frm.size.width = screenRect.size.width - paddingOffset;
    frm.size.height = 20;

    self.timeLineStartPanel.frame = frm;

    
    frm.origin.y = offsetEnd - 10 - 1;
    frm.origin.x = paddingOffset-2;
    frm.size.width = screenRect.size.width - paddingOffset;
    frm.size.height = 20;
    
    self.timeLineEndPanel.frame = frm;


    self.tlSLbl1.text = self.tlSLbl2.text = tS;
    self.tlELbl1.text = self.tlELbl2.text = tE;
    
    
    self.tlSLbl1.layer.cornerRadius  = self.tlSLbl2.layer.cornerRadius  = self.tlELbl1.layer.cornerRadius  = self.tlELbl2.layer.cornerRadius = 5;
    self.tlSLbl1.layer.masksToBounds = self.tlSLbl2.layer.masksToBounds = self.tlELbl1.layer.masksToBounds = self.tlELbl2.layer.masksToBounds = YES;
    
//    self.frame = CGRectMake(0, 0, [panel contentSize].width, 10); self.notePanel.frame;

    
//    self.scrollMode = self.scrollMode;
    
}

- (IBAction)actToggleScrollMode:(id)sender {
    
    self.scrollMode = !self.scrollMode;
    
}


#pragma mark -
#pragma mark Castom Setters And Getters



-(BOOL) scrollMode{
    return scrollMode;
}
-(void) setScrollMode:(BOOL)sM{
    scrollMode = sM;
    
    CGRect frm = self.frame;
    
    if(!scrollMode)
    {
        self.layer.masksToBounds = NO;
        self.layer.cornerRadius = 8; // if you like rounded corners
        self.layer.shadowOffset = CGSizeMake(-3, 5);
        self.layer.shadowRadius = 7;
        self.layer.shadowOpacity = 0.6;
        
        frm.origin.x = 0;
    }
    
    else{
        self.layer.masksToBounds = NO;
        self.layer.cornerRadius = 16; // if you like rounded corners
        self.layer.shadowOffset = CGSizeMake(-10, 20);
        self.layer.shadowRadius = 12;
        self.layer.shadowOpacity = 0.4;
        
        frm.origin.x = 3;
    }
    
    self.frame = frm;
}



-(NSDictionary *) note{
    return  note;
}


-(void) setNote:(NSDictionary *)n{
    
    if( !n[@"event_startTime"] || !n[@"event_duration"] ) return;
    
    
    tS = n[@"event_startTime"];
    
    int tEndH = [[n[@"event_startTime"] componentsSeparatedByString:@":"][0] integerValue]*60;
    int tEndM = [[n[@"event_startTime"] componentsSeparatedByString:@":"][1] integerValue];
    
    int x = tEndH + tEndM + [n[@"event_duration"] integerValue];
    
    int min = abs(floor( x % 60 ));  x /= 60;
    int hrs = abs(floor( x % 24 ));  x /= 24;

    tE = [NSString stringWithFormat:@"%d:%d",hrs,min ];
    
//    [self layout];
    
}


@end
