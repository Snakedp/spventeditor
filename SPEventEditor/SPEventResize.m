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
    
    [instance layout];
    
    return instance;
    
}


-(void) layout{

    NSString * tS = @"10:00";
    NSString * tE = @"12:00";
    
    offsetStart = [self.delegate offsetByTime: tS];
    offsetEnd   = [self.delegate offsetByTime: tE];
    
    CGRect frm = self.timeLineStartPanel.frame;
    frm.origin.y = offsetStart - frm.size.height/2;
    frm.origin.x = 0;
    self.timeLineStartPanel.frame = frm;

            frm = self.timeLineEndPanel.frame;
    frm.origin.y = offsetEnd - frm.size.height/2;
    frm.origin.x = 0;
    self.timeLineEndPanel.frame = frm;

    
}


@end
