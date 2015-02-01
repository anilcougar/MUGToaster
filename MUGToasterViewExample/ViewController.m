//
//  ViewController.m
//  MUGToasterViewExample
//
//  Created by Anil Ardahanli on 2/2/15.
//  Copyright (c) 2015 Anil Ardahanli. All rights reserved.
//

#import "ViewController.h"

#import "MUGToasterView.h"

@interface ViewController ()

@property (nonatomic, strong) MUGToasterView *toasterView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _toasterView = [[MUGToasterView alloc] init];
    
    [_toasterView setTitleTextColor:[UIColor whiteColor]];
    [_toasterView setSubTitleTextColor:[UIColor whiteColor]];
    
    [_toasterView showToasterAtView:self.view
                      leftSideImage:[UIImage imageNamed:@"high_priority-50"]
                    backgroundColor:[UIColor redColor]
                          titleText:@"Yout title text here"
                       subTitleText:@"Your subtitle text in here. Hede hodo huhu"
                           duration:5
                         toastStyle:kMUGCustom
                      animationType:SlideVertical
                          withBlock:^(NSString *statusString, BOOL finished) {
                              //^^if you need a block, you have it here. read status string for debugging purposes.
                              if (finished)
                                  NSLog(@"[block]here!");
                              
                          }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
