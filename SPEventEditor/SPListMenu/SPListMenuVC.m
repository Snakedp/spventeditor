//
//  SPListMenuVC.m
//  splistmenu.ios
//
//  Created by Aleksey Molokovich on 17.02.15.
//  Copyright (c) 2015 Aleksey Molokovich. All rights reserved.
//

#import "SPListMenuVC.h"

@interface SPListMenuVC ()

@end

@implementation SPListMenuVC

+(SPListMenuVC *)showMenu:(NSDictionary*)config withState:(NSArray*)state inParent:(id)parent inPoint:(CGPoint)point{
    
    SPListMenuVC * instanceMenu=[[SPListMenuVC alloc] initWithNibName:@"SPListMenuVC" bundle:nil];
    
    instanceMenu->_delegate=parent;
    
    instanceMenu->config=config;
    instanceMenu->parentVC=parent;
    instanceMenu->touchPoint=point;
    
    instanceMenu->state=[state mutableCopy];
    
    if( [config[MENU_ITEMS] count] > state.count ){
        
        for (int i = state.count; i < [config[MENU_ITEMS] count]; i++)
            [instanceMenu->state addObject:@(0)];
        
    }
    

    
    [parent presentViewController:instanceMenu animated:NO completion:nil];
    
    return instanceMenu;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getScreenShotAndBlur:parentVC];
    
    
    menuWidth=263;
    screenSize=[[UIScreen mainScreen] bounds];
    
    
    [self setupUIElements];
    
    
    
    

    
}

-(void)viewWillAppear:(BOOL)animated{
    
    
    [self setupSizeUIElements];
    //self.vwContainerMenu.center=self.view.center;
    
    [UIView animateWithDuration:0.5 animations:^{self.imgWithBlur.alpha=1;} completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{self.vwContainerMenu.frame=finishPosition;}];
    }];
    

    
}


#pragma mark -
#pragma mark UITableViewDelegate Methods

-(SPTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if( [config[MENU_ITEMS] count] < indexPath.row)
    {
        NSLog(@"ERROR");
        return nil;
    }
    
    NSDictionary * item = config[MENU_ITEMS][indexPath.row];
    
    
    NSString * typeCell=[NSString stringWithFormat:@"SPTableCellType%@",((item[ITEM_IMG])?ITEM_TYPE_IMGANDMARKER:ITEM_TYPE_LABEL)];

    SPTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:typeCell];

    
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:typeCell bundle:nil] forCellReuseIdentifier:typeCell];
        
        cell = [tableView dequeueReusableCellWithIdentifier:typeCell];
    }
    

    [cell setUpCellByItem: item withState: state[indexPath.row] ];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    state[indexPath.row]= @(![state[indexPath.row] boolValue]);
    
    
    if ([config[MENU_ITEMS][indexPath.row][ITEM_ACT] isEqualToNumber:ITEM_ACT_SEL_AND_CLOSE]){
        [self saveAndDismiss];
        return;
    }
    

    [tableView reloadData];
    
}

#pragma mark -
#pragma mark UITableViewDataSource Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [config[MENU_ITEMS] count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HEIGHT_TABLE_ROW;
}

#pragma mark -
#pragma mark UIAction Methods

- (IBAction)goBack:(id)sender {
    
    [self dismiss];
    
}

- (IBAction)cancelButtonPressed:(id)sender {

}

- (IBAction)doneButtonPressed:(id)sender {
    
    [self saveAndDismiss];

}


#pragma mark -
#pragma mark Setup UI Elements


- (void)setupUIElements {
 
    
    self.imgWithBlur.alpha=0;
    self.imgWithoutBlur.alpha=1;
 
    self.lblTitle.text = @"";
    self.lblDescription.text = @"";
    
    if([config[MENU_TITLE] length]>1)
    {
        if( [config[MENU_TITLE] isKindOfClass:[NSAttributedString class]] )
            [self.lblTitle setAttributedText:config[MENU_TITLE]];
        else
            self.lblTitle.text = [config[MENU_TITLE] description];
        
    self.lblTitle.layer.cornerRadius=4;
    self.lblTitle.layer.masksToBounds = YES;
    }
    
    if([config[MENU_DESCRIPTION] length]>1)
    {
        if( [config[MENU_DESCRIPTION] isKindOfClass:[NSAttributedString class]] )
                 [self.lblDescription setAttributedText:config[MENU_DESCRIPTION]];
        else
            self.lblDescription.text = [config[MENU_DESCRIPTION] description];

    self.lblDescription.layer.cornerRadius=4;
    self.lblDescription.layer.masksToBounds = YES;
    }
    
    self.tblMenu.layer.cornerRadius=4;
    
    //[self.btnCancel setTitle:@"Отмена" forState:UIControlStateNormal];
    [self.btnCancel addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.btnCancel.titleLabel.font = [UIFont systemFontOfSize:[UIFont buttonFontSize]];
    self.btnCancel.layer.cornerRadius = 4;

    
    //[self.btnSave setTitle:@"Сохранить!" forState:UIControlStateNormal];
    [self.btnSave addTarget:self action:@selector(doneButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.btnSave.titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont buttonFontSize]];
    self.btnSave.layer.cornerRadius = 4;
    
    
    self.vwContainerMenu.backgroundColor=[UIColor clearColor];
    self.vwTopMenu.backgroundColor=[UIColor clearColor];
    self.vwButtons.backgroundColor=[UIColor clearColor];
    //self.vwContainerMenu.frame=CGRectMake(0, screenSize.size.height, menuWidth, 0);
    
 
}

-(void) setupSizeUIElements{
    
    heightMenuTop=0;
    heightMenuBottom=0;
    
    if([config[MENU_TITLE] length]>1)
        heightMenuTop=heightMenuTop+HEIGHT_TITLE;
    
    
    if ([config[MENU_DESCRIPTION] length]>1)
        heightMenuTop=heightMenuTop+HEIGHT_DESCRIPTION;
        

    CGRect rec=self.vwTopMenu.frame;
    rec.size.height=heightMenuTop;
    self.vwTopMenu.frame=rec;
    
    
    
    heightMenuBottom=([config[MENU_BUTTON_CANCEL] integerValue]+1)*HEIGHT_BUTTON;
    heightMenu=heightMenuTop+heightMenuBottom+[config[MENU_ITEMS] count]*HEIGHT_TABLE_ROW;
    
    if (heightMenu>screenSize.size.height){
        heightMenu=screenSize.size.height;
        self.tblMenu.scrollEnabled=YES;
    }else{
        self.tblMenu.scrollEnabled=NO;
    }
    
    if ( IDIOM == IPAD ) {
        /* do something specifically for iPad. */
    } else {
        
        startPosition=CGRectMake(screenSize.size.width/2-menuWidth/2, screenSize.size.height+heightMenu, menuWidth , heightMenu);
        finishPosition=CGRectMake(screenSize.size.width/2-menuWidth/2, screenSize.size.height/2-heightMenu/2, menuWidth , heightMenu);
        self.vwContainerMenu.frame=startPosition;
        
    }
    
    rec=self.vwButtons.frame;
    rec.origin.y=heightMenu-heightMenuBottom;
    self.vwButtons.frame=rec;
    
    
    self.vwTable.frame=CGRectMake(self.tblMenu.frame.origin.x, heightMenuTop, self.tblMenu.frame.size.width, heightMenu-heightMenuTop-heightMenuBottom);
    
    
}



-(void)getScreenShotAndBlur:(UIViewController*)fromVC{
    

    //        if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
    //            UIGraphicsBeginImageContextWithOptions(self.window.bounds.size, NO, [UIScreen mainScreen].scale);
    //        else
    //            UIGraphicsBeginImageContext(self.window.bounds.size);
    
    UIGraphicsBeginImageContext(fromVC.view.bounds.size);
    [fromVC.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.imgWithoutBlur.image=image;
    
    //        //Blur finished in 0.004884 seconds.
    image = [image applyBlurWithCrop:fromVC.view.bounds resize:fromVC.view.bounds.size blurRadius:1 tintColor:[UIColor colorWithWhite:0.1 alpha:0.6] saturationDeltaFactor:1.8 maskImage:nil];
    
    self.imgWithBlur.image=image;
    

}
#pragma mark -
#pragma mark Other Methods
-(void)dismiss{
    [UIView animateWithDuration:0.5 animations:^{self.vwContainerMenu.frame=startPosition;} completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{self.imgWithBlur.alpha=0;} completion:^(BOOL finished) {
            [self dismissViewControllerAnimated:NO completion:nil];
        }];
    }];
}

-(void)saveAndDismiss{
    [self sendDataToParent];
    [self dismiss];
}

#pragma mark -
#pragma mark Delegates

-(void)sendDataToParent{
    id<SPListMenuVCDelegate> strongDelegate = self.delegate;
    
    // Our delegate method is optional, so we should
    // check that the delegate implements it
    if ([strongDelegate respondsToSelector:@selector(updateMenuListStates:)]) {
        [strongDelegate updateMenuListStates:state];
    }
}


@end
