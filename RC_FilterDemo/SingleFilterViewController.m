//
//  SingleFilterViewController.m
//  RC_FilterDemo
//
//  Created by MAXToooNG on 15/2/6.
//  Copyright (c) 2015年 Chen.Liu. All rights reserved.
//

#import "SingleFilterViewController.h"
#import "UIImage+Utility.h"

@interface SingleFilterViewController ()
{
    UIScrollView *_scrollVIew;
//    FantasyView *_tableview;
    UIButton *_albumButton;
    UIImage *_oriImage;
    NCVideoCamera *_videoCamera;
    NCVideoCamera *_thumbnailsVideoCamera;
    NSMutableArray *_dataArray;
}
@property (nonatomic,strong) UIImagePickerController *picker;
@property (nonatomic, strong) UIImageView *imageView;
@end
#define kWindowHeight [UIScreen mainScreen].bounds.size.height
#define kWindowWidth [UIScreen mainScreen].bounds.size.width

@implementation SingleFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _scrollVIew = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kWindowHeight - 100, kWindowWidth, 100)];
    [self.view addSubview:_scrollVIew];

    
    _albumButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [_albumButton addTarget:self action:@selector(selectedImage:) forControlEvents:UIControlEventTouchUpInside];
    [_albumButton setFrame:CGRectMake(0, 20, 40, 40)];
    
    //    NSArray *imageArray = @[@"原图1.jpg",@"复古1.jpg",@"美白1.jpg",@"清凉1.jpg",@"FA_Curves1.jpg",@"Old Magenta by jaejunggim1.jpg",@"Pink Gleam by jaejunggim1.jpg",@"Warm Pink by jaejunggim1.jpg",@"Cold Blue by jaejunggim.jpg",@"Cold Pink by jaejunggim.jpg",@"curve 2 by addy-ack.jpg",@"mothernature.jpg",@"Night by jaejunggim.jpg",@"oldhue.jpg",@"RJ1.jpg",@"RJ2.jpg",@"RJ23.jpg",@"RJ26.jpg",@"RJ30.jpg",@"Underwater.jpg",@"Warm Embrace.jpg",@"Breeze.jpg"];
    
    
    [self.view addSubview:_albumButton];
    self.picker = [[UIImagePickerController alloc] init];
    self.picker.delegate = self;
    self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, kWindowWidth, kWindowHeight - 60 - 100)];
    //    self.imageView.backgroundColor = [UIColor blueColor];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.imageView];
}

- (void)selectedImage:(UIButton *)btn
{
    [self presentViewController:self.picker animated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    _oriImage = image;
    self.imageView.image = image;
     UIImage *thumbImage = [image setMaxResolution:120 imageOri:image.imageOrientation];
    for (NSObject *obj in _scrollVIew.subviews) {
        if ([obj isKindOfClass:[GPUImageView class]]) {
            [((GPUImageView*)obj) removeFromSuperview];
        }
    }
    [_scrollVIew setContentOffset:CGPointMake(0, 0) animated:NO];
    [picker dismissViewControllerAnimated:YES completion:^{
        //    [_scrollVIew removeFromSuperview];
        [_scrollVIew setContentSize:CGSizeMake(NC_FILTER_TOTAL_NUMBER * 70 + 5, 1)];
        for (int i = 0; i < NC_FILTER_TOTAL_NUMBER; i++) {
            
            GPUImageView *buttonView = [[GPUImageView alloc] initWithFrame:CGRectMake(5 + i * 70, 5, 70, 90)];
            buttonView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
            
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
        _videoCamera = [[NCVideoCamera alloc] initWithImage:image];
        _videoCamera.delegate = self;
        //        [_tableview reloadData];
        for (NSObject *obj in _scrollVIew.subviews) {
            @autoreleasepool {
                if ([obj isKindOfClass:[GPUImageView class]]) {
                    ((GPUImageView *)obj).fillMode = kGPUImageFillModeStretch;
                    ((GPUImageView *)obj).contentMode = UIViewContentModeScaleAspectFit;
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        NCVideoCamera *thumbVC = [[NCVideoCamera alloc] initWithThumbnailImage:thumbImage];
                        [thumbVC addNewGPUImageViewTarget:(GPUImageView *)obj andFilterType:(NCFilterType)(((GPUImageView *)obj).tag - 100)];
                        thumbVC = nil;
                        
                    });
                    
                }
            }
        }
    }];
    
}

- (void)videoCameraResultImage:(NSArray *)array
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.imageView.image = array[0];
        
    });
}

- (void)switchFilter:(UITapGestureRecognizer *)tap
{
    [_videoCamera switchFilterType:(NCFilterType)(tap.view.tag - 100)];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
