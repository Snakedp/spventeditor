//
//  SPTableViewCell.m
//  splistmenu.ios
//
//  Created by Aleksey Molokovich on 17.02.15.
//  Copyright (c) 2015 Aleksey Molokovich. All rights reserved.
//

#import "SPTableViewCell.h"
#import "SPListMenuVC.h"

@implementation SPTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


-(void) setUpCellByItem:(NSDictionary *) itm withState:(NSNumber *) state{
    
    NSString * key = (state.boolValue && itm[ ITEM_TITLE_SEL] )? ITEM_TITLE_SEL: ITEM_TITLE;
    
    if( itm[ key ] && [itm[ key ] isKindOfClass:[NSAttributedString class]] ){
        
        self.lblText.attributedText = itm[ key ];
        
    }
    else{
        self.lblText.text = [itm[ key ] description];
        
        [self.lblText setFont: state.boolValue?DEFAULT_TITLE_ACTIVE_FONT:DEFAULT_TITLE_INNACTIVE_FONT ];
        [self.lblText setTextColor: state.boolValue?DEFAULT_TITLE_ACTIVE_COLOR:DEFAULT_TITLE_INNACTIVE_COLOR ];

    }
    
    
    if( !itm[ ITEM_IMG] )
        return;

    
    UIImage * actImg = [UIImage imageNamed: [NSString stringWithFormat:@"%@%@",itm[ ITEM_IMG], DEFAULT_IMG_ACTIVE_POSTFIX ] ];
    UIImage * img =    [UIImage imageNamed: itm[ ITEM_IMG] ];
    
    
    if( state.boolValue){
        self.imgImage.alpha = 1;
        

        
        self.imgImage.image = (actImg)?actImg:img;
        
    }
    else{
        
        self.imgImage.alpha = ( actImg )?1: DEFAULT_IMG_INNACTIVE_ALPHA ;
        self.imgImage.image = img;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:NO];

    // Configure the view for the selected state
}

@end
