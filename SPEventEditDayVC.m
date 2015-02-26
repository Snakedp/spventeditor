//
//  SPEventEditDayVC.m
//  SPEventEditor
//
//  Created by Nikolay Ilin on 12.12.14.
//  Copyright (c) 2014 Soft-Artel.com. All rights reserved.
//

#import "SPEventEditDayVC.h"
#import "SPEventEditDayCell.h"
#import "SPEventResize.h"
@interface SPEventEditDayVC ()

@end

@implementation SPEventEditDayVC
@synthesize grid, event;

static NSString * const reuseIdentifier = @"dayCell";



+ (SPEventEditDayVC *) daysCollectionViewIn: (UIView*) panel
                               withDelegate:(id <SPEventEditDayDelegate>) delegate
                                    andNote:(NSDictionary *) note {
    
    UICollectionViewFlowLayout *aFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    [aFlowLayout setItemSize:panel.bounds.size];
    [aFlowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    SPEventEditDayVC * instance = [[SPEventEditDayVC alloc] initWithCollectionViewLayout: aFlowLayout ];

    instance.delegate = delegate;
    
    instance->grid = [SPEventEditDayGrid dayGridIn: panel andZoomScale: 15 ];

    instance->grid.delegateUP = delegate;
    
    
    instance.collectionView.frame = CGRectMake(0, 0, panel.bounds.size.width, instance->grid.contentSize.height);
    
    [instance->grid addSubview: instance.collectionView];
    
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"]];
    instance.date = [dateFormatter dateFromString: note[@"event_startDate"]];


    
    instance.event = [SPEventResize eventResizeInPanel: instance->grid andNote: note ];
    

    UILongPressGestureRecognizer * longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:instance action:@selector( longPressHandle: )];
    [longPressGR setMinimumPressDuration:0.3];
    [instance.grid addGestureRecognizer: longPressGR ];

    
    
    return instance;
}


-(void) longPressHandle: (UILongPressGestureRecognizer*) sender{
    
    if(sender.state == UIGestureRecognizerStateBegan)
    {
        CGPoint point = [sender locationInView:self.grid];
        CGFloat y = point.y - CAL_BOUNDS_OFFSET;
        
        NSArray * timeArr = [[self.grid timeByY: y ]  componentsSeparatedByString:@":"];
        
        NSInteger min = [timeArr[1] integerValue];

        min = (min%5 == 0)? min : (min%5 <= 2)? (min/5)*5: (min%5 >2 )? (min/5)*5 + 5: min;

        
        NSString * time= [NSString stringWithFormat:@"%@:%lu",timeArr[0],min ];
        
        y = [self.grid  offsetByTime: time];
        
        NSLog(@"%@:%@ -> %@", timeArr[0], timeArr[1], time );
        
        
        if( point.x<= 40 && point.y < self.event.timeLineEndPanel.frame.origin.y + CAL_ROW_HEIGHT )
        {
            
            [self.event moveStartByDeltaY: y - (self.event.timeLineStartPanel.frame.origin.y + self.event.timeLineStartPanel.frame.size.height/2) - 2 ];
        }
        
        if( point.x<= 40 && point.y > self.event.timeLineEndPanel.frame.origin.y )
        {
            [self.event moveByDeltaY: y - (self.event.timeLineStartPanel.frame.origin.y  + self.event.timeLineStartPanel.frame.size.height/2) - 2 ];
        }
    
        
        if( point.x>=200 && point.y > self.event.timeLineStartPanel.frame.origin.y + CAL_ROW_HEIGHT )
        {
            [self.event moveEndByDeltaY: y - (self.event.timeLineEndPanel.frame.origin.y + self.event.timeLineEndPanel.frame.size.height/2) - 2 ];
        }
        
        if( point.x>=200 && point.y < self.event.timeLineStartPanel.frame.origin.y )
        {
            [self.event moveByDeltaY: y - (self.event.timeLineEndPanel.frame.origin.y+ self.event.timeLineEndPanel.frame.size.height/2) - 2];
        }
    
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
     self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerNib:[UINib nibWithNibName:@"SPEventEditDayCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    [self setDate: [NSDate date] ];
    
    self.collectionView.delegate = self;
//    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.bounces = NO;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.directionalLockEnabled = NO;

    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    


    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.collectionView performBatchUpdates:nil completion:nil];
    [self.collectionView reloadData];
}


- (void) show{
    
    [event addToView: self.grid ];
    [event layout];

}


#pragma mark -
#pragma mark UICollectionViewDelegate


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
 
    return  SPNV_DATAP_RANGE *2 +1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    SPEventEditDayCell * cell = (SPEventEditDayCell*) [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    cell.lblTitle.text = [NSString stringWithFormat:@"%@", indexPath];
    
    return cell;
}

#pragma mark -
#pragma mark UICollectionViewDelegate

-(void) collectionView:(UICollectionView *)collectionView willDisplayCell:(SPEventEditDayCell *)cell forItemAtIndexPath:(NSIndexPath *)iP{
    
    NSTimeInterval timeOffSet = 3600*24*( iP.row - SPNV_DATAP_RANGE );
    
    NSDate * cellDate = [date dateByAddingTimeInterval: timeOffSet ];
    
    [[(SPEventEditDayCell*)cell  lblTitle] setText:[NSString stringWithFormat:@"%@",cellDate ]];
    
    //    NSDictionary * day = [[SPCalendarDS shared] getDay: @([cellDate dayKey]) ];
    //
    //    [cell fillWithDict: day ];
    //
    //    if (iP.row ==  index.row) {
    //        cell.lblDate.alpha = 1;
    //        cell.textLabel.font = SPNV_DP_ROWFONTSEL;
    //    } else {
    //        cell.lblDate.alpha = 0.5;
    //        cell.textLabel.font = SPNV_DP_ROWFONT;
    //    }
    //
    cell.indexPath = [NSIndexPath indexPathForRow: iP.row inSection:0];
    //
    //    if ([DATE_STRING_FROM_DATE(cellDate, @"yyyy-MM-dd") isEqual:DATE_STRING_FROM_DATE([NSDate date], @"yyyy-MM-dd")]) {
    //        cell.lblDate.textColor = [UIColor colorWithRed:151.0/255 green:40.0/255 blue:205.0/255 alpha:1];
    //        cell.homeIcon.alpha = 1;
    //    } else {
    //        cell.lblDate.textColor = [UIColor colorWithRed:0/255 green:102.0/255 blue:204.0/255 alpha:1];
    //        cell.homeIcon.alpha = 0;
    //    }
    
    
}


#pragma mark -
#pragma mark UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return grid.contentSize;
}


#pragma mark Scroll view methods

-(void) scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
//    NSLog(@"\n scrollViewDidEndScrollingAnimation \n%@\n\n", scrollView );

    [self scrollToTheSelectedCell];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
//    NSLog(@"pass scrollView:%@ own:%@", scrollView, self.collectionView );
    
    [self scrollToTheSelectedCell];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
//    NSLog(@"\n scrollViewDidEndDragging \n%@\n\n", scrollView );
    
    if (!decelerate) {
        [self scrollToTheSelectedCell];
    }
}


-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if(self.delegate)
        [self.delegate dayGridScroll: scrollView.contentOffset.x ];
}





#pragma mark -
#pragma mark WorkFlow Methods



-(void) setDate:(NSDate *)d{
    
    //Определяем - есть ли у нас она уже в диапазоне
    if(!cvSetUp)
        [self setCollectionView];
    
    date = d;
    
    
    NSTimeInterval diff =  [d timeIntervalSinceDate:date];
    
    NSTimeInterval dayDiff = diff / 60/ 60 / 24;
    
    
    
    if( round(abs(dayDiff)) <= SPNV_DATAP_RANGE && self.collectionView  )
    {
        
        int row = round( dayDiff ) + SPNV_DATAP_RANGE;
        index = [NSIndexPath indexPathForRow:row inSection:0];
        [self scrollToCurrent];
        
    }
    else
        [self updateTableByNewDate: d];
    
    [self.collectionView reloadData];
    self.eventOffset = 0;//DAYOFFSET_TS( @([d timeIntervalSince1970]) );
}


-(NSDate *) date{
    return date;
}


-(NSInteger) eventOffset{
    return eventOffset;
}

-(void) setEventOffset:(NSInteger) offSet{
    
    eventOffset = offSet;
    
    [self buzzyLineFrame];
    
}


-(NSInteger) eventDuration{
    return eventDuration;
}

-(void) setEventDuration:(NSInteger) offSet{
    
    eventDuration = offSet;
    
    [self buzzyLineFrame];
    
    
}


-(void) scrollToCurrent{
    [self.collectionView scrollToItemAtIndexPath:index
                        atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                animated:YES];
    
}

-(void) buzzyLineFrame{
    
    //    CGFloat blW = (eventDuration / (60 * SPNV_DP_BUZZY_PANEL_SCALE) ) * ( self.bounds.size.width / ( 24 / SPNV_DP_BUZZY_PANEL_SCALE )  );
    //
    //    CGFloat xOffSet =   eventOffset * self.bounds.size.width / 86400 ;
    //
    //    eventViewFrame = CGRectMake( xOffSet , 0, blW , self.buzzyLineContainer.bounds.size.height );
    //
    //    buzzyLine.frame = eventViewFrame;
}



-(void) updateTableByNewDate:(NSDate *) d{
    
    date = d;
    index = [NSIndexPath indexPathForRow:SPNV_DATAP_RANGE inSection:0];
    
    if( self.collectionView )
    {
        [self.collectionView scrollToItemAtIndexPath:index
                            atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                    animated:NO];
        [self.collectionView reloadData];
    }
    
}




- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        cvSetUp = NO;
    }
    return self;
    
}



- (void) setCollectionView {
    
    cvSetUp = YES;
    
    date      = [NSDate date];
    
    eventOffset    = 0;//DAYOFFSET_TS( @([date timeIntervalSince1970]) );
    eventDuration  = 90;
    
    
    //    CGAffineTransform rotateTable = CGAffineTransformMakeRotation(-M_PI_2);
    //    self.table.transform = rotateTable;
    //    self.table.rowHeight = self.bounds.size.width;
    //
    //
    //
    //    //    buzzyLine = [[UIView alloc] initWithFrame: eventViewFrame];
    //    buzzyLine = [[UIView alloc] initWithFrame: eventViewFrame];
    //
    //    buzzyLine.tag = 110;
    //
    //    [buzzyLine setBackgroundColor: [UIColor colorWithHexString:@"1189fc"] ];
    //    [buzzyLine setAlpha: 1];
    //
    //
    //
    //    [self.buzzyLineContainer addSubview: buzzyLine  ];
}


-(IBAction) btnNextAction{
    //    if ([date timeIntervalSince1970] < NSIntegerMax) {
    //        [self.table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index.row+1 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    //    }
    //    LOG_EVENT(LOG_CAT_EDIT_EVENT, LOG_ACTION_NEXT_DAY, @"By button", nil);
    
}


-(IBAction) btnPrevAction{
    //    if ([date timeIntervalSince1970] > 0) {
    //        [self.table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index.row-1 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    //    }
    //    LOG_EVENT(LOG_CAT_EDIT_EVENT, LOG_ACTION_PREV_DAY, @"By button", nil);
    //
    
}




-(void) updateTimeGridScale:(CGFloat) scale{
    
    [self.delegate updateGridByScale: scale];
    [event layout];
}


-(NSString *) timeByGridY:(CGFloat) y{

//    y += CAL_BOUNDS_OFFSET;
//        UIView * tst = [[UIView alloc] initWithFrame: CGRectMake(0, y, 200, 1)];
//        tst.backgroundColor = [UIColor redColor];
//        [grid addSubview: tst];
//    y+= grid.contentOffset.y;

    return [grid timeByY: y ];
    
}


- (void)scrollToTheSelectedCell{
    
    NSArray * cells = [self.collectionView visibleCells];
    
    if( cells.count >0 )
    {
        [self didSelectRow:  [[[cells lastObject] indexPath] row]];
    }
}




-(void) didSelectRow:(NSInteger) row{
    
    NSInteger daysDiff = row -  SPNV_DATAP_RANGE;
    
    if( daysDiff !=0)
    {
        NSDate * d = [date dateByAddingTimeInterval:3600*24* (int)daysDiff ];
        
        [self updateTableByNewDate: d ];
    }
    else {
        
        [self.collectionView scrollToItemAtIndexPath:index
                            atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                    animated:NO];
        
    }
    
    if( self.delegate )
        [self.delegate dayGridChangeDate: date ];
    
}



@end
