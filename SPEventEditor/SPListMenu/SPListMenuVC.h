//
//  SPListMenuVC.h
//  splistmenu.ios
//
//  Created by Aleksey Molokovich on 17.02.15.
//  Copyright (c) 2015 Aleksey Molokovich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPTableViewCell.h"
#import "UIImage+ImageEffects.h"

#define IDIOM    UI_USER_INTERFACE_IDIOM()
#define IPAD     UIUserInterfaceIdiomPad



#define MENU_ITEMS          @"items"
#define MENU_BUTTON_CANCEL  @"button_c"
#define MENU_TITLE          @"title"
#define MENU_DESCRIPTION    @"description"

#define ITEM_TYPE           @"type"
#define ITEM_TITLE          @"title"
#define ITEM_TITLE_SEL      @"selectedTitle"
#define ITEM_IMG            @"imgName"

#define ITEM_ACT            @"action"

#define ITEM_TYPE_LABEL         @(0)
#define ITEM_TYPE_IMGANDMARKER  @(1)

#define ITEM_ACT_ONLY_SEL       @(0)
#define ITEM_ACT_SEL_AND_CLOSE    @(1)

#define HEIGHT_TABLE_ROW    48
#define HEIGHT_TITLE        55
#define HEIGHT_DESCRIPTION  50
#define HEIGHT_BUTTON       62




@protocol SPListMenuVCDelegate;

@interface SPListMenuVC : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    float heightMenuTop;
    float heightMenuBottom;
    float heightMenu;
    float menuWidth;
    
    NSInteger directionAnimated;
    
    NSDictionary * config;
    NSMutableArray * state;
    
    CGPoint  touchPoint;
    CGRect  screenSize;
    CGRect  startPosition;
    CGRect  finishPosition;
    
    
    UIViewController * parentVC;
    
    
}

+(SPListMenuVC *)showMenu:(NSDictionary*)config withState:(NSArray*)state inParent:(UIViewController*)parent inPoint:(CGPoint)point;

@property (nonatomic, weak) id<SPListMenuVCDelegate> delegate;

@property(nonatomic, strong) NSArray * datasource;

@property (weak, nonatomic) IBOutlet UIView *vwContainerMenu;

@property (weak, nonatomic) IBOutlet UIImageView *imgWithoutBlur;
@property (weak, nonatomic) IBOutlet UIImageView *imgWithBlur;

@property (weak, nonatomic) IBOutlet UIView *vwTopMenu;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;

@property (weak, nonatomic) IBOutlet UIView *vwMenu;
@property (weak, nonatomic) IBOutlet UITableView *tblMenu;
@property (weak, nonatomic) IBOutlet UIView *vwTable;

@property (weak, nonatomic) IBOutlet UIView *vwButtons;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;

@end


@protocol SPListMenuVCDelegate <NSObject>
-(void) updateMenuListStates:(NSArray* ) states;
@end