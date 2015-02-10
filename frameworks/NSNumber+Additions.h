//
//  NSNumber+Additions.h
//  SPEventEditor
//
//  Created by Nikolay Ilin on 10.02.15.
//  Copyright (c) 2015 Soft-Artel.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (Additions)

-(NSArray *)  timeArrFromSeconds;
-(NSString *) timeFromSeconds;
-(NSString *) durationFromSeconds;
@end
