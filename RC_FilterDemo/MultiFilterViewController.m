//
//  MultiFilterViewController.m
//  RC_FilterDemo
//
//  Created by MAXToooNG on 15/2/6.
//  Copyright (c) 2015年 Chen.Liu. All rights reserved.
//

#import "MultiFilterViewController.h"
#import "NCVideoCamera.h"
@interface MultiFilterViewController ()
{
    UIScrollView *_scrollVIew;
    NCVideoCamera *_videoCamera;
}
@property (nonatomic, strong) NSMutableArray *viewArray;
@property (nonatomic, strong) NSMutableArray *imageArray;

@end
#define kWindowHeight [UIScreen mainScreen].bounds.size.height
#define kWindowWidth [UIScreen mainScreen].bounds.size.width
@implementation MultiFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _videoCamera = [[NCVideoCamera alloc] init];
    _videoCamera.multiDelegate = self;
    self.view.backgroundColor = [UIColor blackColor];
    self.viewArray = [[NSMutableArray alloc] init];
    self.imageArray = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view.
    [self initViews];
}

- (void)initViews{
    _scrollVIew = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kWindowHeight - 100, kWindowWidth, 100)];
    [self.view addSubview:_scrollVIew];
    [_scrollVIew setContentOffset:CGPointMake(0, 0) animated:NO];
    for (int i  = 0; i < 9; i ++ ) {
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0 + i/3 *103, 50 + i%3 * 103, 103, 103)];
        NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%d",i] ofType:@"jpg"];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        [self.imageArray addObject:image];
        [imageview setImage:image];
        [self.view addSubview:imageview];
        [self.viewArray addObject:imageview];
    }
    for (int i = 0; i < NC_FILTER_TOTAL_NUMBER; i++) {
        
        UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(5 + i * 70, 5, 70, 90)];
        
        //        [button setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
        buttonView.tag = i + 100;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(switchFilter:)];
        [buttonView addGestureRecognizer:tap];
        //        [button addTarget:self action:@selector(switchAcvFilter:) forControlEvents:UIControlEventTouchUpInside];
        [buttonView setFrame:CGRectMake(5 + i * 70, 5, 70, 90)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 40, 40)];
        label.text = [NSString stringWithFormat:@"%d",i];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
        label.textColor = [UIColor blackColor];
        [buttonView addSubview:label];
        [_scrollVIew addSubview:buttonView];
    }
    [_scrollVIew setContentSize:CGSizeMake(NC_FILTER_TOTAL_NUMBER * 70 + 5, 1)];
}

- (void)switchFilter:(UITapGestureRecognizer *)tap
{
    [_videoCamera switchFilterType:(NCFilterType)(tap.view.tag - 100) withImages:self.imageArray];
//    [_videoCamera switchFilterType:(NCFilterType)(tap.view.tag - 100) ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)videoCameraResultImage:(UIImage *)image andIndex:(NSInteger)index
{
    if (index < self.viewArray.count) {
        UIImageView *imageview = self.viewArray[index];
        imageview.image = image;
    }

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
