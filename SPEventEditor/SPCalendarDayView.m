//
//  SPCalendarDayView.m
//  SPEventEditor
//
//  Created by Nikolay Ilin on 19.02.15.
//  Copyright (c) 2015 Soft-Artel.com. All rights reserved.
//

#import "SPCalendarDayView.h"

@implementation SPCalendarDayView


- (void)drawRect:(CGRect)rect
{
    // Получим context
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect); // Очистим context
    
    CGContextSetRGBFillColor(context, 255, 0, 0, 1);
    CGContextFillRect(context, CGRectMake(20, 20, 100, 100));
}


@end
