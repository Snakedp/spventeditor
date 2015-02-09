//
//  ViewController.m
//  SPEventEditor
//
//  Created by Nikolay Ilin on 12.12.14.
//  Copyright (c) 2014 Soft-Artel.com. All rights reserved.
//

#import "ViewController.h"



@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)actionOpenEditor:(id)sender {

    NSDictionary * note = @{
                            @"event_startTime":@"10:00",
                            @"event_duration":@"120",
                            @"event_startDate" : @"2015-02-09",
                            @"message": @"test! note!"};
    
    [SPEventEditVC editEvent:note presentedBy:self];

}


@end
