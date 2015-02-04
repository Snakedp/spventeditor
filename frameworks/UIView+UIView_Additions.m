//
//  UIView+UIView_Additions.m
//  SPEventEditor
//
//  Created by Nikolay Ilin on 13.01.15.
//  Copyright (c) 2015 Soft-Artel.com. All rights reserved.
//

#import "UIView+UIView_Additions.h"
#import "UIImage+ImageEffects.h"

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


@implementation UIView (UIView_Additions)

-(void)setShadow:(BOOL)shadow {
    if (shadow) {
        self.layer.masksToBounds = NO;
        //        self.layer.shadowOffset = CGSizeMake(-15, 20);
        self.layer.shadowRadius = 3;
        self.layer.shadowOpacity = 0.3;
    } else {
        self.layer.shadowRadius = 0;
        self.layer.shadowOpacity = 0;
    }
}

-(BOOL)shadow {
    return self.layer.shadowRadius != 0;
}

-(void)setAnimatedAlpha:(CGFloat)alpha {
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.alpha = alpha;
                     }];
}

- (void)setAnimatedAlpha:(CGFloat)alpha comletion:(void (^)(BOOL finished))completion{
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.alpha = alpha;
                     } completion: completion];
    
}


- (UIImage *) blure {

    UIImage * snapshot = [self snapshot];
    
    snapshot = [snapshot applyBlurWithCrop:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)) resize:CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)) blurRadius:2 tintColor:[UIColor colorWithWhite:0.2 alpha: SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")?.76:.87f] saturationDeltaFactor:1.8 maskImage:nil];
    
    
    return  snapshot;
}



- (UIImage *) snapshot {
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 1);
    
    //Snapshot finished in 0.051982 seconds.
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        [self drawViewHierarchyInRect:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)) afterScreenUpdates:NO];
        //        self.backgroundImage.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    __block UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return  snapshot;
}


-(void)scaleBackCompletion:(void (^)(BOOL))completion {
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.transform = CGAffineTransformMakeScale(0.7, 0.7);
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.2
                                          animations:^{
                                              self.transform = CGAffineTransformMakeScale(1, 1);
                                          } completion:^(BOOL finished) {
                                              completion(finished);
                                          }];
                     }];
}


@end
