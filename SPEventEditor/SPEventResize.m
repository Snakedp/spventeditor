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
    
    instance.frame = CGRectMake(0, 0, [panel contentSize].width, [panel contentSize].height);
    
    [panel addSubview: instance ];
    
    instance.delegate = (UIScrollView<SPEventResizeDelegate>* )panel;
    
    return instance;
}


-(void) layout{

    NSString * tS = @"10:00";
    NSString * tE = @"16:15";
    
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
    

    
}


@end
