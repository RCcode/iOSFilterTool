//
//  ViewController.m
//  RC_FilterDemo
//
//  Created by MAXToooNG on 15/2/3.
//  Copyright (c) 2015年 Chen.Liu. All rights reserved.
//

#import "ViewController.h"
#import "PublicMethod.h"
#import "SingleFilterViewController.h"


@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *singleButton;
@property (weak, nonatomic) IBOutlet UIButton *multiButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    getConfigFilterDic(2);
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)singleButtonOnClicked:(id)sender {
    SingleFilterViewController *single = [[SingleFilterViewController alloc] init];
    [self presentViewController:single animated:YES completion:nil];
}
- (IBAction)multiButtonOnClicked:(id)sender {
}

@end
