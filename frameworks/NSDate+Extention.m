//
//  NSDate+Extention.m
//  SPEventEditor
//
//  Created by Nikolay Ilin on 15.01.15.
//  Copyright (c) 2015 Soft-Artel.com. All rights reserved.
//

#import "NSDate+Extention.h"

@implementation NSDate (Extention)

- (NSString*) stringByFormat:(NSString*)format {
    
    NSDateFormatter* dF = [NSDateFormatter new];
    [dF setTimeStyle:NSDateFormatterMediumStyle];
    
    
    if ( [dF.dateFormat isEqualToString:@"h:mm:ss a"] ) {
        format = [format stringByReplacingOccurrencesOfString:@"HH:mm:ss" withString:@"h:mm:ss a"];
        format = [format stringByReplacingOccurrencesOfString:@"HH:mm" withString:@"h:mm a"];
        format = [format stringByReplacingOccurrencesOfString:@"HH mm" withString:@"h mm a"];
        format = [format stringByReplacingOccurrencesOfString:@"HH" withString:@"h a"];
    }
    
    [dF setDateFormat:format];
    return [dF stringFromDate: self ];
}


@end
