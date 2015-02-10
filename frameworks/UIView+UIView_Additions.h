//
//  UIView+UIView_Additions.h
//  SPEventEditor
//
//  Created by Nikolay Ilin on 13.01.15.
//  Copyright (c) 2015 Soft-Artel.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (UIView_Additions)

@property (nonatomic, readwrite) BOOL shadow;
-(void) customShadow:(NSArray *) params;

-(void) moveByDeltaX:(CGFloat ) x andY:(CGFloat) y  comletion:(void (^)(BOOL finished))completion;
-(void) resizeByDeltaW:(CGFloat ) w andH:(CGFloat) h  comletion:(void (^)(BOOL finished))completion;

- (void)setAnimatedAlpha:(CGFloat)alpha;
- (void)setAnimatedAlpha:(CGFloat)alpha comletion:(void (^)(BOOL finished))completion;


-(UIImage *) snapshot;
-(UIImage *) blure;

- (void)scaleBackCompletion:(void (^)(BOOL finished))completion;


@end
