//
//  NSNumber+Additions.m
//  SPEventEditor
//
//  Created by Nikolay Ilin on 10.02.15.
//  Copyright (c) 2015 Soft-Artel.com. All rights reserved.
//

#import "NSNumber+Additions.h"

@implementation NSNumber (Additions)

-(NSArray *) timeArrFromSeconds{
    
    NSMutableArray * tC = [@[
                             @0, // секунд
                             @0, // минут
                             @0, // часов
                             @0, // деней
                             @0, // недель
                             @0  // месяцов
                             
                             ] mutableCopy];
    
    NSInteger x = [self integerValue];
    
    tC[0] = @( floor( x % 60 ) );  x /= 60;
    tC[1] = @( floor( x % 60 ) );  x /= 60;
    tC[2] = @( floor( x % 24 ) );  x /= 24;
    tC[3] = @( floor( x % 7 )  );  x /= 7;
    tC[4] = @( floor( x % 30 ) );  x /= 30;
    tC[5] = @( floor( x % 12 ) );
    //    days = x
    
    return [tC copy];
}


-(NSString *) timeFromSeconds{
    
    long Minutes = self.integerValue / 60;
    
    long min = abs(floor( Minutes % 60 ));  Minutes /= 60;
    long hrs = abs(floor( Minutes % 24 ));  Minutes /= 24;
    
    NSString * format = (hrs>9)?@"%d":@"0%d";
    format = [format stringByAppendingString:((min>9)?@":%d":@":0%d") ];
    
    return [NSString stringWithFormat: format, hrs, min];
}


-(NSString *) durationFromSeconds{
    
    if(self.integerValue == -1)
        return  @"-";
    
    else if( self.integerValue == 0)
        return @"0";
    
    NSArray * tC = [self timeArrFromSeconds];
    
    NSMutableString * str = [NSMutableString string];
    
    if( [tC[5] integerValue] == 1)
        [str appendString:@" 1 месяц,"];
    
    if( [tC[5] integerValue] > 1 && [tC[5] integerValue] < 5 )
        [str appendFormat:@" %li месяца,", (long)[tC[5] integerValue] ];
    
    if( [tC[5] integerValue] >= 5 )
        [str appendFormat:@" %li месяцев,", (long)[tC[5] integerValue] ];
    
    
    
    if( [tC[4] integerValue] == 1)
        [str appendString:@" 1 неделю,"];
    
    if( [tC[4] integerValue] > 1 && [tC[4] integerValue] < 5 )
        [str appendFormat:@" %li недели,", (long)[tC[4] integerValue] ];
    
    if( [tC[4] integerValue] >= 5 )
        [str appendFormat:@" %li недель,", (long)[tC[4] integerValue] ];
    
    
    
    
    if( [tC[3] integerValue] == 1)
        [str appendString:@" 1 день,"];
    
    if( [tC[3] integerValue] > 1 && [tC[3] integerValue] < 5 )
        [str appendFormat:@" %li дня,", (long)[tC[3] integerValue] ];
    
    if( [tC[3] integerValue] >= 5 )
        [str appendFormat:@" %li дней,", (long)[tC[3] integerValue] ];
    
    
    
    if( [tC[2] integerValue] == 1)
        [str appendString:@" 1 час,"];
    
    if( [tC[2] integerValue] > 1 && [tC[2] integerValue] < 5 )
        [str appendFormat:@" %li часа,", (long)[tC[2] integerValue] ];
    
    if( [tC[2] integerValue] >= 5 )
        [str appendFormat:@" %li часов,", (long)[tC[2] integerValue] ];
    
    
    
    
    if( [tC[1] integerValue] == 1)
        [str appendString:@" 1 минуту,"];
    
    if( [tC[1] integerValue] > 1 && [tC[1] integerValue] < 5 )
        [str appendFormat:@" %li минуты,", (long)[tC[1] integerValue] ];
    
    if( [tC[1] integerValue] >= 5 )
        [str appendFormat:@" %li минут,", (long)[tC[1] integerValue] ];
    
    
    if( [tC[0] integerValue] == 1)
        [str appendString:@" 1 секунду,"];
    
    if( [tC[0] integerValue] > 1 && [tC[0] integerValue] < 5 )
        [str appendFormat:@" %li секунды,", (long)[tC[0] integerValue] ];
    
    if( [tC[0] integerValue] >= 5 )
        [str appendFormat:@" %li секунд,", (long)[tC[0] integerValue] ];
    
    
    
    if( str.length >3)
    {
        str = [NSMutableString stringWithFormat:@"%@",str];
        
        return [str substringWithRange:NSMakeRange( 0, str.length -1)];
    }
    else
        return nil;
}



@end
