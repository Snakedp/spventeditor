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
    
    NSArray * params;
    
    if ( shadow ) {
        
        self.layer.masksToBounds = NO;
        
        params = @[@(-3),@2,@3, @0.5];

    } else {
       params = @[@0,@0,@0, @0];
    }
    
    [self customShadow: params ];
}

-(BOOL)shadow {
    return self.layer.shadowRadius != 0;
}

-(void) customShadow:(NSArray *) params {
    
    //params = @[ offSetX, offSetY, radus, alpha ]
    
    self.layer.shadowOffset = CGSizeMake( [params[0] floatValue] ,  [params[1] floatValue] );
    self.layer.shadowRadius = [params[2]  floatValue];
    self.layer.shadowOpacity = [params[3] floatValue];

}

-(void) moveByDeltaX:(CGFloat ) x andY:(CGFloat) y  comletion:(void (^)(BOOL finished))completion{
    
    CGRect frm = self.frame;
    
    frm.origin.x += x;
    frm.origin.y += y;
    
    if(completion == nil)
     self.frame = frm;
    
    else
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.frame = frm;
                     } completion: completion];

    
}


-(void) resizeByDeltaW:(CGFloat ) w andH:(CGFloat) h  comletion:(void (^)(BOOL finished))completion{
    
    CGRect frm = self.frame;
    
    frm.size.width += w;
    frm.size.height += h;
    
    if(completion == nil)
        self.frame = frm;
    
    else
        [UIView animateWithDuration:0.2
                         animations:^{
                             self.frame = frm;
                         } completion: completion];
    
    
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
