

#import "NCFilters.h"
#import "IFBrightContSatTemperFilter.h"
#import "PublicMethod.h"
//#import "UIImage+processing.h"
//#import "DataUtil.h"

@interface NCVideoCamera () <NCImageFilterDelegate>
{
    //滤镜处理完成之后的回调
    FilterCompletionBlock _filterCompletionBlock;
    NSInteger _index;
}

@property (nonatomic, strong) GPUImageFilter *filter;
@property (nonatomic, strong) GPUImagePicture *sourcePicture1;
@property (nonatomic, strong) GPUImagePicture *sourcePicture2;
@property (nonatomic, strong) GPUImagePicture *sourcePicture3;
@property (nonatomic, strong) GPUImagePicture *sourcePicture4;
@property (nonatomic, strong) GPUImagePicture *sourcePicture5;

@property (nonatomic, strong) GPUImageFilter *internalFilter;
@property (nonatomic, strong) GPUImagePicture *internalSourcePicture1;
@property (nonatomic, strong) GPUImagePicture *internalSourcePicture2;
@property (nonatomic, strong) GPUImagePicture *internalSourcePicture3;
@property (nonatomic, strong) GPUImagePicture *internalSourcePicture4;
@property (nonatomic, strong) GPUImagePicture *internalSourcePicture5;

@property (strong, readwrite) GPUImageView *gpuImageView_HD;
@property (strong, readwrite) GPUImageView *gpuImageView;

@property (nonatomic, strong) GPUImageFilter *rotationFilter;
@property (nonatomic, unsafe_unretained) NCFilterType currentFilterType;

@property (nonatomic, strong) GPUImagePicture *stillImageSource;
@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;

@property (nonatomic, strong) GPUImageMovieWriter *movieWriter;
@property (nonatomic, unsafe_unretained, readwrite) BOOL isRecordingMovie;
@property (nonatomic, strong) AVAudioRecorder *soundRecorder;
@property (nonatomic, strong) AVMutableComposition *mutableComposition;
@property (nonatomic, strong) AVAssetExportSession *assetExportSession;
@property (nonatomic, strong) NSMutableDictionary *progressConfigDic;

@property (nonatomic, strong) NSArray *oriImages;
@property (nonatomic ,strong) UIImage *resultImage;

@end

@implementation NCVideoCamera

@synthesize filter;
@synthesize sourcePicture1;
@synthesize sourcePicture2;
@synthesize sourcePicture3;
@synthesize sourcePicture4;
@synthesize sourcePicture5;

@synthesize internalFilter;
@synthesize internalSourcePicture1;
@synthesize internalSourcePicture2;
@synthesize internalSourcePicture3;
@synthesize internalSourcePicture4;
@synthesize internalSourcePicture5;

@synthesize gpuImageView;
@synthesize gpuImageView_HD;
@synthesize rotationFilter;
@synthesize currentFilterType;
@synthesize rawImage;
@synthesize stillImageSource;

@synthesize stillImageOutput;

@synthesize delegate;
@synthesize multiDelegate;

@synthesize movieWriter;
@synthesize isRecordingMovie;
@synthesize soundRecorder;
@synthesize mutableComposition;
@synthesize assetExportSession;



#pragma mark - Switch Filter
- (void)switchToNewFilter {
    
    //    self.internalFilter.delegate = self;
    
    if (self.stillImageSource == nil) {
        //        [self.rotationFilter removeTarget:self.filter];
        self.filter = self.internalFilter;
        //        [self.rotationFilter addTarget:self.filter];
    } else {
        [self.stillImageSource removeTarget:self.filter];

        self.filter = self.internalFilter;

        [self.stillImageSource addTarget:self.filter];
    }
    
    if (self.internalSourcePicture1) {
        self.sourcePicture1 = self.internalSourcePicture1;
        [self.sourcePicture1 addTarget:self.filter];
        [self.sourcePicture1 processImage];
    }
    if (self.internalSourcePicture2) {
        self.sourcePicture2 = self.internalSourcePicture2;
        [self.sourcePicture2 addTarget:self.filter];
        [self.sourcePicture2 processImage];
    }
    if (self.internalSourcePicture3) {
        self.sourcePicture3 = self.internalSourcePicture3;
        [self.sourcePicture3 addTarget:self.filter];
        [self.sourcePicture3 processImage];
    }
    if (self.internalSourcePicture4) {
        self.sourcePicture4 = self.internalSourcePicture4;
        [self.sourcePicture4 addTarget:self.filter];
        [self.sourcePicture4 processImage];
    }
    if (self.internalSourcePicture5) {
        self.sourcePicture5 = self.internalSourcePicture5;
        [self.sourcePicture5 addTarget:self.filter];
        [self.sourcePicture5 processImage];
    }
        if (self.stillImageSource != nil) {
//        [[UIDevice currentModelVersion] isEqualToString:@"iPod5,1"] ||
//            if (!( [[UIDevice currentModelVersion] isEqualToString:@"iPhone3,1"] ||  [[UIDevice currentModelVersion] isEqualToString:@"iPod5,1"])) {
//                [self.filter addTarget:self.gpuImageView];
//                [self updateFilterParams:0 forUniformName:@""];
//                self.gpuImageView_HD.hidden = NO;
                //        [self.filter addTarget:self.gpuImageView_HD];
        [self.filter useNextFrameForImageCapture];
        [self.stillImageSource processImageWithCompletionHandler:^{
            @try {
                self.resultImage = [self.filter imageFromCurrentFramebuffer];
            }
            @catch (NSException *exception) {
                self.resultImage = nil;
            }
            @finally {
            
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.resultImage != nil) {
                    NSArray *resultArray = [NSArray arrayWithObjects:self.resultImage,[NSNumber numberWithInt:currentFilterType], nil];
                    NSLog(@"filtedImage.size = %@",NSStringFromCGSize(self.resultImage.size));
                    
                    if ([delegate respondsToSelector:@selector(videoCameraResultImage:)]) {
                        [delegate performSelector:@selector(videoCameraResultImage:) withObject:resultArray];
                    }else{
                        NSLog(@"eeeeend");
//                        [MBProgressHUD hideAllHUDsForView:[[[UIApplication sharedApplication] delegate] window] animated:YES];
                    }
                    if ([multiDelegate respondsToSelector:@selector(videoCameraResultImage:andIndex:)]) {
                        [multiDelegate videoCameraResultImage:self.resultImage andIndex:_index];
                        _index ++;
                        [self switchFilterType:currentFilterType withIndex:_index];
                    }
                    
                }
                else
                {
//                    [DataUtil defaultDateUtil].isFilter = NO;
                    NSArray *resultArray = [NSArray arrayWithObjects:self.rawImage,[NSNumber numberWithInt:currentFilterType], nil];
                    if ([delegate respondsToSelector:@selector(videoCameraResultImage:)]) {
                        [delegate performSelector:@selector(videoCameraResultImage:) withObject:resultArray];
                    }
//                    [MBProgressHUD hideAllHUDsForView:[[[UIApplication sharedApplication] delegate] window] animated:YES];
                    NSLog(@"-=====nil");
                }

            });
    }];
        
    } else {
//        [DataUtil defaultDateUtil].isFilter = NO;

        [self.filter addTarget:self.gpuImageView];
        
    }
}



- (void)forceSwitchToNewFilter:(NCFilterType)type {

    currentFilterType = type;
    self.internalSourcePicture1 = nil;
    self.internalSourcePicture2 = nil;
    self.internalSourcePicture3 = nil;
    self.internalSourcePicture4 = nil;
    self.internalSourcePicture5 = nil;
//    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *confDic = getConfigFilterDic(type);
        NSLog(@"confDic = %@",confDic);
        NSDictionary *textureConfig = [confDic objectForKey:@"textureConfig"];
        if (textureConfig) {
            NSString *pictureName1= [textureConfig objectForKey:@"inputImageTexture2"];
            NSString *pictureName2= [textureConfig objectForKey:@"inputImageTexture3"];
            NSString *pictureName3= [textureConfig objectForKey:@"inputImageTexture4"];
            NSString *pictureName4= [textureConfig objectForKey:@"inputImageTexture5"];
            NSString *pictureName5= [textureConfig objectForKey:@"inputImageTexture6"];
            if (pictureName1 != nil) {
                UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:pictureName1 ofType:@"png"]];
                if (!image) {
                    image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:pictureName1 ofType:@"jpg"]];
                }
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:image];
            }
            if (pictureName2 != nil) {
                UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:pictureName2 ofType:@"png"]];
                if (!image) {
                    image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:pictureName2 ofType:@"jpg"]];
                }
                self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:image];
            }
            if (pictureName3 != nil) {
                UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:pictureName3 ofType:@"png"]];
                if (!image) {
                    image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:pictureName3 ofType:@"jpg"]];
                }
                self.internalSourcePicture3 = [[GPUImagePicture alloc] initWithImage:image];
            }
            if (pictureName4 != nil) {
                UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:pictureName4 ofType:@"png"]];
                if (!image) {
                    image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:pictureName4 ofType:@"jpg"]];
                }
                self.internalSourcePicture4 = [[GPUImagePicture alloc] initWithImage:image];
            }
            if (pictureName5 != nil) {
                UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:pictureName5 ofType:@"png"]];
                if (!image) {
                    image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:pictureName5 ofType:@"jpg"]];
                }
                self.internalSourcePicture5 = [[GPUImagePicture alloc] initWithImage:image];
            }
        }
        
        NSString *filterClassName = [confDic objectForKey:@"filter"];
        
        self.internalFilter = [[NSClassFromString(filterClassName) alloc] init];
        [self.internalFilter setFloat:0.7 forUniformName:@"specIntensity"];
        NSDictionary *argumentConfig = [confDic objectForKey:@"argumentConfig"];
        if (argumentConfig) {
            [self.internalFilter setFloat:((NSNumber *)[argumentConfig objectForKey:@"specIntensity2"]).floatValue forUniformName:@"specIntensity2"];
            [self.internalFilter setFloat:((NSNumber *)[argumentConfig objectForKey:@"specIntensity3"]).floatValue forUniformName:@"specIntensity3"];
            [self.internalFilter setFloat:((NSNumber *)[argumentConfig objectForKey:@"specIntensity4"]).floatValue forUniformName:@"specIntensity4"];
            [self.internalFilter setFloat:((NSNumber *)[argumentConfig objectForKey:@"specIntensity5"]).floatValue forUniformName:@"specIntensity5"];
            [self.internalFilter setFloat:((NSNumber *)[argumentConfig objectForKey:@"specIntensity6"]).floatValue forUniformName:@"specIntensity6"];
            [self.internalFilter setFloat:((NSNumber *)[argumentConfig objectForKey:@"specIntensity7"]).floatValue forUniformName:@"specIntensity7"];
            [self.internalFilter setFloat:((NSNumber *)[argumentConfig objectForKey:@"specIntensity8"]).floatValue forUniformName:@"specIntensity8"];
            [self.internalFilter setFloat:((NSNumber *)[argumentConfig objectForKey:@"specIntensity9"]).floatValue forUniformName:@"specIntensity9"];
            [self.internalFilter setFloat:((NSNumber *)[argumentConfig objectForKey:@"specIntensity10"]).floatValue forUniformName:@"specIntensity10"];
            [self.internalFilter setFloat:((NSNumber *)[argumentConfig objectForKey:@"specIntensity11"]).floatValue forUniformName:@"specIntensity11"];
            [self.internalFilter setFloat:((NSNumber *)[argumentConfig objectForKey:@"specIntensity12"]).floatValue forUniformName:@"specIntensity12"];
        }
    NSDictionary *progressConfig = [confDic objectForKey:@"progressConfig"];
    if (progressConfig) {
        self.progressConfigDic = [[NSMutableDictionary alloc] initWithDictionary:progressConfig];
        NSNumber *configParam = [self.progressConfigDic objectForKey:@"defaultProgress"];
        CGFloat value = configParam.floatValue;
        value = value / 100.0f;
         [self.internalFilter setFloat:value forUniformName:@"specIntensity"];
    }
        [self performSelectorOnMainThread:@selector(switchToNewFilter) withObject:nil waitUntilDone:NO];
//    });
}

- (void)switchFilterType:(NCFilterType)type withImages:(NSArray *)images
{
    _index = 0;
    self.oriImages = images;
    [self switchFilterType:type withIndex:_index];
}

- (void)switchFilterType:(NCFilterType)type withIndex:(NSInteger)index
{
    if (index < self.oriImages.count && self.oriImages[index]) {
        if (self.stillImageSource) {
            [self.stillImageSource removeAllTargets];
            
        }
        self.stillImageSource = [[GPUImagePicture alloc] initWithImage:self.oriImages[index]];
        [self performSelector:@selector(forceSwitchToNewFilterAfterDelay:) withObject:[NSNumber numberWithInt:type] afterDelay:0.0f];
    }else{
        _index ++;
        if (_index < self.oriImages.count) {
            [self switchFilterType:type withIndex:_index];
        }
    }

}

- (void)switchFilterType:(NCFilterType)type {
    
    if ((self.rawImage != nil) && (self.stillImageSource == nil)) {
        self.stillImageSource = [[GPUImagePicture alloc] initWithImage:self.rawImage];
    } else {
    }
    [self performSelector:@selector(forceSwitchToNewFilterAfterDelay:) withObject:[NSNumber numberWithInt:type] afterDelay:0.0f];
    
}

- (void)forceSwitchToNewFilterAfterDelay:(NSNumber *)type
{
    [self forceSwitchToNewFilter:(NCFilterType)type.intValue];
}



//#pragma mark - init
//- (id)initWithSessionPreset:(NSString *)sessionPreset cameraPosition:(AVCaptureDevicePosition)cameraPosition highVideoQuality:(BOOL)isHighQuality WithFrame:(CGRect)frame{
//	if (!(self = [super initWithSessionPreset:sessionPreset cameraPosition:cameraPosition]))
//    {
//		return nil;
//    }
//
//    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
//    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
//    [self.stillImageOutput setOutputSettings:outputSettings];
//    [self.captureSession addOutput:stillImageOutput];
//
//    rotationFilter = [[GPUImageFilter alloc] init];
//    [rotationFilter setInputRotation:kGPUImageRotateRight atIndex:0];
//    [self addTarget:rotationFilter];
//
//    self.filter = [[NCNormalFilter alloc] init];
//    self.internalFilter = self.filter;
//
//    [rotationFilter addTarget:filter];
//
//    gpuImageView = [[GPUImageView alloc] initWithFrame:frame];
//    if (isHighQuality == YES) {
//        gpuImageView.layer.contentsScale = 2.0f;
//    } else {
//        gpuImageView.layer.contentsScale = 1.0f;
//    }
//    [filter addTarget:gpuImageView];
//
//    gpuImageView_HD = [[GPUImageView alloc] initWithFrame:[gpuImageView bounds]];
//    gpuImageView_HD.hidden = YES;
//    [gpuImageView addSubview:gpuImageView_HD];
//
//    return self;
//}

- (id)initWIthFrame:(CGRect)frame
{
    if (!(self = [super init])) {
        return nil;
    }
    self.filter = [[NCNormalFilter alloc] init];
    self.internalFilter = self.filter;
    
    //    [rotationFilter addTarget:filter];
    
    gpuImageView = [[GPUImageView alloc] initWithFrame:frame];
    gpuImageView.layer.contentsScale = 2.0f;
    [filter addTarget:gpuImageView];
    
    return self;
}

- (id)initWithGPUImageView:(GPUImageView *)view
{
    if (!(self = [super init])) {
        return nil;
    }
    //circle blur
    self.excludeCircleRadius = 60.0/320.0;
    self.excludeCirclePoint = CGPointMake(0.5f, 0.5f);
    self.excludeBlurSize = 30.0/320.0;
    //rect blur
    self.topFocusLevel = 0.4;
    self.bottomFocusLevel = 0.6;
    self.focusFallOffRate = 0.2;
    self.angleRate = 0.0;
    //effect
    self.brightnessValue = 0;
    self.contrastValue = 1;
    self.saturationValue = 0;
    self.colorTemperatureValue = 0;
    self.vignetteValue = 0.3;
    
    self.filter = [[NCNormalFilter alloc] init];
    self.internalFilter = self.filter;

    self.gpuImageView = view;
    [self.filter addTarget:self.gpuImageView];
    return self;
}

- (id)init
{
    if(self = [super init]){
        _index = 0;
    
    }
    return self;
}

- (id)initWithImage:(UIImage *)newImageSource
{
    if (self = [super init]) {
        self.rawImage = newImageSource;
        self.gpuImageView = [[GPUImageView alloc] initWithFrame:CGRectMake(0, 0, newImageSource.size.width, newImageSource.size.height)];
        
    }
    return self;
}

+ (instancetype)videoCameraWithFrame:(CGRect)frame Image:(UIImage *)rawImage{
    //    NCVideoCamera *instance = [[[self class] alloc] initWithSessionPreset:AVCaptureSessionPresetPhoto cameraPosition:AVCaptureDevicePositionUnspecified highVideoQuality:YES WithFrame:frame];
    
    NCVideoCamera *instance = [[[self class] alloc]initWIthFrame:frame];
    
    instance.rawImage = rawImage;
    //    [instance switchFilterType:NC_NORMAL_FILTER];
    
    return instance;
}

+ (instancetype)videoCameraWithGPUImageView:(GPUImageView *)gpuImageView Image:(UIImage *)rawImage andFilterModel:(FilterModel *)filterModel
{
    //    NCVideoCamera *instance = [[[self class] alloc] initWithSessionPreset:AVCaptureSessionPresetPhoto cameraPosition:AVCaptureDevicePositionUnspecified highVideoQuality:YES WithFrame:frame];
    UIImage *subImage = nil;
//    if (CGRectEqualToRect(CGRectMake(0, 0, 1, 1), filterModel.clipRect)) {
        subImage = rawImage;
//    }else{
//        CGRect clipRect = CGRectMake(filterModel.clipRect.origin.x *rawImage.size.width, filterModel.clipRect.origin.y *rawImage.size.height, filterModel.clipRect.size.width *rawImage.size.width, filterModel.clipRect.size.height *rawImage.size.height);
//        subImage = [rawImage subImageWithRect:clipRect];
//    }
    
    
    
    
    if (gpuImageView == nil) {
        gpuImageView = [[GPUImageView alloc] initWithFrame:CGRectMake(0, 0, subImage.size.width, subImage.size.height)];
    }else{
    }
    gpuImageView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
    gpuImageView.backgroundColor = [UIColor clearColor];
    NCVideoCamera *instance = [[[self class] alloc]initWithGPUImageView:gpuImageView];
//    instance.brightnessValue = filterModel.brightnessValue;
//    instance.contrastValue = filterModel.contrastValue;
//    instance.saturationValue = filterModel.saturationValue;
//    instance.vignetteValue = filterModel.vignetteValue;
//    instance.colorTemperatureValue = filterModel.colorTemperatureValue;
//    instance.isUseRectangular = filterModel.isUseRectangular;
//    instance.isUseCircleBlur = filterModel.isUseCircleBlur;
//    instance.excludeCirclePoint = filterModel.excludeCirclePoint;
//    instance.excludeCircleRadius = filterModel.excludeCircleRadius;
//    instance.topFocusLevel = filterModel.topFocusLevel;
//    instance.bottomFocusLevel = filterModel.bottomFocusLevel;
//    instance.focusFallOffRate = filterModel.focusFallOffRate;
//    instance.angleRate = filterModel.angleRate;
    
    instance.rawImage = subImage;
    //    [instance switchFilterType:NC_NORMAL_FILTER];
    
    return instance;
}


- (void)switchFilter:(NCFilterType)type WithCompletionBlock:(FilterCompletionBlock)filterCompletionBlock{
    [self switchFilterType:type];
    _filterCompletionBlock = filterCompletionBlock;
}

#pragma mark - NCImageFilterDelegate
- (void)imageFilterdidFinishRender:(NCImageFilter *)imageFilter{
    //截图
    
    return;
}

- (void)updateFilterParams:(CGFloat)value forUniformName:(NSString *)uniformName
{
    
    if ([uniformName isEqualToString:@"specIntensity2"]) {
        self.brightnessValue = value;
         [self.effectFilter setFloat:value forUniformName:uniformName];
    }
    if([uniformName isEqualToString:@"specIntensity3"]){
        self.contrastValue = value;
         [self.effectFilter setFloat:value forUniformName:uniformName];
    }
    if ([uniformName isEqualToString:@"specIntensity4"]) {
        self.saturationValue = value;
         [self.effectFilter setFloat:value forUniformName:uniformName];
    }
    if ([uniformName isEqualToString:@"specIntensity5"]) {
        self.colorTemperatureValue = value;
         [self.effectFilter setFloat:value forUniformName:uniformName];
    }
    if([uniformName isEqualToString:@"specIntensity6"]){
        self.vignetteValue = value;
         [self.effectFilter setFloat:value forUniformName:uniformName];
    }
    
//    
//    if (_isUseCircleBlur) {
//        if ([uniformName isEqualToString:FILTER_CIRCLE_RADIUS]) {
//            if (value >= 1) {
//                value =1;
//            }
//            if (value <= 0) {
//                value = 0;
//            }
//            self.excludeCircleRadius = value;
//            [(FC_FogCircleFilter *)self.circleBlurFilter setExcludeCircleRadius: value];
//        }
//    }else if (_isUseRectangular){
//        if ([uniformName isEqualToString:FILTER_RECT_RATE]) {
//            [self.rectangularFilter setFocusFallOffRate:value];
//            self.focusFallOffRate = value;
//        }
//        if ([uniformName isEqualToString:FILTER_RECT_ANGLE]) {
//            [self.rectangularFilter setAngleRate:value];
//            self.angleRate = value;
//        }
//    }
    
    
    if (self.internalSourcePicture1) {
        [self.sourcePicture1 processImage];
    }
    if (self.internalSourcePicture2) {
        [self.sourcePicture2 processImage];
    }
    if (self.internalSourcePicture3) {
        [self.sourcePicture3 processImage];
    }
    if (self.internalSourcePicture4) {
        [self.sourcePicture4 processImage];
    }
    if (self.internalSourcePicture5) {
        [self.sourcePicture5 processImage];
    }
    
    [self.stillImageSource processImage];
}

- (void)updateBlurFilterWithTopLevelValue:(CGFloat)topValue bottomValue:(CGFloat)bottomValue Type:(NSString *)typeString
{
    if (!_isUseRectangular) {
        return;
    }
//    if ([typeString isEqualToString:FILTER_RECT_SCALE]) {
        if (topValue > bottomValue) {
            return;
        }
//    }
        [(FC_FogRectangularFilter *)self.rectangularFilter setTopFocusLevel :topValue];
    self.topFocusLevel = topValue;
    self.bottomFocusLevel = bottomValue;
        [(FC_FogRectangularFilter *)self.rectangularFilter setBottomFocusLevel :bottomValue];
    NSLog(@"topValue = %f",topValue);
    NSLog(@"bottomValue = %f",bottomValue);
    if (self.internalSourcePicture1) {
        [self.sourcePicture1 processImage];
    }
    if (self.internalSourcePicture2) {
        [self.sourcePicture2 processImage];
    }
    if (self.internalSourcePicture3) {
        [self.sourcePicture3 processImage];
    }
    if (self.internalSourcePicture4) {
        [self.sourcePicture4 processImage];
    }
    if (self.internalSourcePicture5) {
        [self.sourcePicture5 processImage];
    }
    
    [self.stillImageSource processImage];
}

- (void)updateFilterWithBlurCenter:(CGPoint )point{
    if (!_isUseCircleBlur) {
        return;
    }
    if (point.x >= 1) {
        point.x = 1;
    }
    if (point.y >= 1) {
        point.y = 1;
    }
    if (point.x <= 0) {
        point.x = 0;
    }
    if (point.y >= 1) {
        point.y = 1;
    }
    self.excludeCirclePoint = point;
    [(FC_FogCircleFilter *)self.circleBlurFilter setExcludeCirclePoint:point];
    if (self.internalSourcePicture1) {
        [self.sourcePicture1 processImage];
    }
    if (self.internalSourcePicture2) {
        [self.sourcePicture2 processImage];
    }
    if (self.internalSourcePicture3) {
        [self.sourcePicture3 processImage];
    }
    if (self.internalSourcePicture4) {
        [self.sourcePicture4 processImage];
    }
    if (self.internalSourcePicture5) {
        [self.sourcePicture5 processImage];
    }
    
    [self.stillImageSource processImage];
}

- (void)updateFilter
{
    if (self.internalSourcePicture1) {
        [self.sourcePicture1 processImage];
    }
    if (self.internalSourcePicture2) {
        [self.sourcePicture2 processImage];
    }
    if (self.internalSourcePicture3) {
        [self.sourcePicture3 processImage];
    }
    if (self.internalSourcePicture4) {
        [self.sourcePicture4 processImage];
    }
    if (self.internalSourcePicture5) {
        [self.sourcePicture5 processImage];
    }
}

- (id)initWithThumbnailImage:(UIImage *)thumbImage
{
    if (self = [super init]) {
        self.stillImageSource = [[GPUImagePicture alloc] initWithImage:thumbImage];
        self.filter = [[NCNormalFilter alloc] init];
    }
    return self;
}

//- (void)updateFilterWithParamsDict:(NSDictionary *)dict
//{
//    self.saturationValue = ((NSNumber *)[dict objectForKey:@"saturation"]).floatValue;
//    self.brightnessValue = ((NSNumber *)[dict objectForKey:@"brightness"]).floatValue;
//    self.contrastValue = ((NSNumber *)[dict objectForKey:@"contrast"]).floatValue;
//    self.colorTemperatureValue = ((NSNumber *)[dict objectForKey:@"colorTemperature"]).floatValue;
//    self.vignetteValue = ((NSNumber *)[dict objectForKey:@"vignette"]).floatValue;
//    CGFloat excludeCircleRadius = ((NSNumber *)[dict objectForKey:@"excludeCircleRadius"]).floatValue;
//    CGPoint excludeCirclePoint = CGPointFromString((NSString *)[dict objectForKey:@"excludeCirclePoint"]);
//    CGFloat topFocusLevel = ((NSNumber *)[dict objectForKey:@"topFocusLevel"]).floatValue;
//    CGFloat bottomFocusLevel = ((NSNumber *)[dict objectForKey:@"bottomFocusLevel"]).floatValue;
//    CGFloat angleRate = ((NSNumber *)[dict objectForKey:@"angleRate"]).floatValue;
//    self.isUseCircleBlur = ((NSNumber *)[dict objectForKey:@"isUseCircle"]).boolValue;
//    self.isUseRectangular = ((NSNumber *)[dict objectForKey:@"isUseRect"]).boolValue;
//    
//    [self.effectFilter setFloat:self.brightnessValue forUniformName:@"specIntensity2"];
//    [self.effectFilter setFloat:self.contrastValue forUniformName:@"specIntensity3"];
//    [self.effectFilter setFloat:self.saturationValue forUniformName:@"specIntensity4"];
//    [self.effectFilter setFloat:self.colorTemperatureValue forUniformName:@"specIntensity5"];
//    [self.effectFilter setFloat:self.vignetteValue forUniformName:@"specIntensity6"];
//    
//    if (self.isUseCircleBlur) {
//    
//        if (excludeCirclePoint.x >= 1) {
//            excludeCirclePoint.x = 1;
//        }
//        if (excludeCirclePoint.y >= 1) {
//            excludeCirclePoint.y = 1;
//        }
//        if (excludeCirclePoint.x <= 0) {
//            excludeCirclePoint.x = 0;
//        }
//        if (excludeCirclePoint.y >= 1) {
//            excludeCirclePoint.y = 1;
//        }
//        [(FC_FogCircleFilter *)self.circleBlurFilter setExcludeCirclePoint:excludeCirclePoint];
//        if (excludeCircleRadius >= 1) {
//            excludeCircleRadius =1;
//        }
//        if (excludeCircleRadius <= 0) {
//            excludeCircleRadius = 0;
//        }
//        [(FC_FogCircleFilter *)self.circleBlurFilter setExcludeCircleRadius: excludeCircleRadius];
//        
//    }else if (self.isUseRectangular){
//        if (topFocusLevel < bottomFocusLevel) {
//            [(FC_FogRectangularFilter *)self.rectangularFilter setTopFocusLevel :topFocusLevel];
//            [(FC_FogRectangularFilter *)self.rectangularFilter setBottomFocusLevel :bottomFocusLevel];
//        }
//    }
//    [self.stillImageSource processImage];
//}


- (void)addNewGPUImageViewTarget:(GPUImageView *)view andFilterType:(NCFilterType)type{
    __block GPUImageFilter *thumFilter = [[GPUImageFilter alloc] init];
    
    __block GPUImagePicture *iSP1 = nil;
    __block GPUImagePicture *iSP2 = nil;
    __block GPUImagePicture *iSP3 = nil;
    __block GPUImagePicture *iSP4 = nil;
    __block GPUImagePicture *iSP5 = nil;
    //读取配置文件进行配置
//    NSDictionary *confDic = getConfigFilterDic(type);
//    NSLog(@"confDic = %@",confDic);
//    NSDictionary *textureConfig = [confDic objectForKey:@"textureConfig"];
//    if (textureConfig) {
//        NSString *pictureName1= [textureConfig objectForKey:@"inputImageTexture2"];
//        NSString *pictureName2= [textureConfig objectForKey:@"inputImageTexture3"];
//        NSString *pictureName3= [textureConfig objectForKey:@"inputImageTexture4"];
//        NSString *pictureName4= [textureConfig objectForKey:@"inputImageTexture5"];
//        NSString *pictureName5= [textureConfig objectForKey:@"inputImageTexture6"];
//        if (pictureName1 != nil) {
//            UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:pictureName1 ofType:@"png"]];
//            if (!image) {
//                image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:pictureName1 ofType:@"jpg"]];
//            }
//            iSP1 = [[GPUImagePicture alloc] initWithImage:image];
//        }
//        if (pictureName2 != nil) {
//            UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:pictureName2 ofType:@"png"]];
//            if (!image) {
//                image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:pictureName2 ofType:@"jpg"]];
//            }
//            iSP2 = [[GPUImagePicture alloc] initWithImage:image];
//        }
//        if (pictureName3 != nil) {
//            UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:pictureName3 ofType:@"png"]];
//            if (!image) {
//                image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:pictureName3 ofType:@"jpg"]];
//            }
//            iSP3 = [[GPUImagePicture alloc] initWithImage:image];
//        }
//        if (pictureName4 != nil) {
//            UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:pictureName4 ofType:@"png"]];
//            if (!image) {
//                image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:pictureName4 ofType:@"jpg"]];
//            }
//            iSP4 = [[GPUImagePicture alloc] initWithImage:image];
//        }
//        if (pictureName5 != nil) {
//            UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:pictureName5 ofType:@"png"]];
//            if (!image) {
//                image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:pictureName5 ofType:@"jpg"]];
//            }
//            iSP5 = [[GPUImagePicture alloc] initWithImage:image];
//        }
//    }
//    
//    NSString *filterClassName = [confDic objectForKey:@"filter"];
//    
//    thumFilter = [[NSClassFromString(filterClassName) alloc] init];
//    [thumFilter setFloat:0.7 forUniformName:@"specIntensity"];
//    NSDictionary *argumentConfig = [confDic objectForKey:@"argumentConfig"];
//    if (argumentConfig) {
//        [thumFilter setFloat:((NSNumber *)[argumentConfig objectForKey:@"specIntensity2"]).floatValue forUniformName:@"specIntensity2"];
//        [thumFilter setFloat:((NSNumber *)[argumentConfig objectForKey:@"specIntensity3"]).floatValue forUniformName:@"specIntensity3"];
//        [thumFilter setFloat:((NSNumber *)[argumentConfig objectForKey:@"specIntensity4"]).floatValue forUniformName:@"specIntensity4"];
//        [thumFilter setFloat:((NSNumber *)[argumentConfig objectForKey:@"specIntensity5"]).floatValue forUniformName:@"specIntensity5"];
//        [thumFilter setFloat:((NSNumber *)[argumentConfig objectForKey:@"specIntensity6"]).floatValue forUniformName:@"specIntensity6"];
//        [thumFilter setFloat:((NSNumber *)[argumentConfig objectForKey:@"specIntensity7"]).floatValue forUniformName:@"specIntensity7"];
//        [thumFilter setFloat:((NSNumber *)[argumentConfig objectForKey:@"specIntensity8"]).floatValue forUniformName:@"specIntensity8"];
//        [thumFilter setFloat:((NSNumber *)[argumentConfig objectForKey:@"specIntensity9"]).floatValue forUniformName:@"specIntensity9"];
//        [thumFilter setFloat:((NSNumber *)[argumentConfig objectForKey:@"specIntensity10"]).floatValue forUniformName:@"specIntensity10"];
//        [thumFilter setFloat:((NSNumber *)[argumentConfig objectForKey:@"specIntensity11"]).floatValue forUniformName:@"specIntensity11"];
//        [thumFilter setFloat:((NSNumber *)[argumentConfig objectForKey:@"specIntensity12"]).floatValue forUniformName:@"specIntensity12"];
//        
//    }
    
    [thumFilter forceProcessingAtSize:view.sizeInPixels];
    [self.stillImageSource addTarget:thumFilter];
    [thumFilter addTarget:view];
    if (iSP1) {
        [iSP1 addTarget:thumFilter];
        [iSP1 processImage];
    }
    if (iSP2) {
        [iSP2 addTarget:thumFilter];
        [iSP2 processImage];
    }
    if (iSP3) {
        [iSP3 addTarget:thumFilter];
        [iSP3 processImage];
    }
    if (iSP4) {
        [iSP4 addTarget:thumFilter];
        [iSP4 processImage];
    }
    if (iSP5) {
        
        [iSP5 addTarget:thumFilter];
        [iSP5 processImage];
    }
    [self.stillImageSource processImage];
    
}

- (void)setIsUseCircleBlur:(BOOL)isUseCircleBlur
{
    if (isUseCircleBlur) {
        _isUseCircleBlur = YES;
        _isUseRectangular = NO;
    }else{
        _isUseCircleBlur = NO;
    }
}

- (void)setIsUseRectangular:(BOOL)isUseRectangular
{
    if (isUseRectangular) {
        _isUseRectangular = YES;
        _isUseCircleBlur = NO;
    }else{
        _isUseRectangular = NO;
    }
}

@end
