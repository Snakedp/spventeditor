//
//  SPTableViewCell.h
//  splistmenu.ios
//
//  Created by Aleksey Molokovich on 17.02.15.
//  Copyright (c) 2015 Aleksey Molokovich. All rights reserved.
//

#import <UIKit/UIKit.h>


#define DEFAULT_IMG_INNACTIVE_ALPHA 0.3
#define DEFAULT_IMG_ACTIVE_POSTFIX  @"_act"


#define DEFAULT_TITLE_ACTIVE_FONT     [UIFont fontWithName:@"Helvetica-Light" size:18.0]
#define DEFAULT_TITLE_INNACTIVE_FONT  [UIFont fontWithName:@"Helvetica-Light" size:18.0]

#define DEFAULT_TITLE_ACTIVE_COLOR    [UIColor colorWithRed:0.3 green:0.5 blue:1 alpha:1]
#define DEFAULT_TITLE_INNACTIVE_COLOR [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5]

@interface SPTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblText;
@property (weak, nonatomic) IBOutlet UIImageView *imgImage;


-(void) setUpCellByItem:(NSDictionary *) itm withState:(NSNumber *) state;

@end
