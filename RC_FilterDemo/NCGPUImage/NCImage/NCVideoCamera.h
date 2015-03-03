
#import "GPUImage.h"
#import "NCFilters.h"
#import "NCImageFilter.h"
#import "IFBrightContSatTemperFilter.h"
#import "FC_FogCircleFilter.h"
#import "FC_FogRectangularFilter.h"

@class FilterModel;
@class NCVideoCamera;

typedef void(^FilterCompletionBlock) (UIImage *filterImage);

@protocol IFVideoCameraDelegate <NSObject>
@optional
- (void)IFVideoCameraWillStartCaptureStillImage:(NCVideoCamera *)videoCamera;
- (void)IFVideoCameraDidFinishCaptureStillImage:(NCVideoCamera *)videoCamera;
- (void)IFVideoCameraDidSaveStillImage:(NCVideoCamera *)videoCamera;
- (BOOL)canIFVideoCameraStartRecordingMovie:(NCVideoCamera *)videoCamera;
- (void)IFVideoCameraWillStartProcessingMovie:(NCVideoCamera *)videoCamera;
- (void)IFVideoCameraDidFinishProcessingMovie:(NCVideoCamera *)videoCamera;

- (void)videoCameraResultImage:(NSArray *)array;
- (void)videoCameraType:(NSNumber *)type;
@end

@protocol NCMultiFilterDelegate <NSObject>

- (void)videoCameraResultImage:(UIImage *)image andIndex:(NSInteger)index;

@end

@interface NCVideoCamera : NSObject

@property (strong, readonly) GPUImageView *gpuImageView;
@property (strong, readonly) GPUImageView *gpuImageView_HD;
@property (nonatomic, strong) UIImage *rawImage;                                                 
@property (nonatomic, assign) id<NCMultiFilterDelegate> multiDelegate;
@property (nonatomic, assign) id<IFVideoCameraDelegate> delegate;
@property (nonatomic, unsafe_unretained, readonly) BOOL isRecordingMovie;
@property (nonatomic, strong) GPUImageFilter *effectFilter;
@property (nonatomic, strong) FC_FogCircleFilter *circleBlurFilter;
@property (nonatomic, strong) FC_FogRectangularFilter *rectangularFilter;
@property (nonatomic, strong) GPUImageBrightnessFilter *briFilter;

//effect
@property (nonatomic, assign) CGFloat brightnessValue;
@property (nonatomic, assign) CGFloat saturationValue;
@property (nonatomic, assign) CGFloat contrastValue;
@property (nonatomic, assign) CGFloat colorTemperatureValue;
@property (nonatomic, assign) CGFloat vignetteValue;

//rect blur
@property (nonatomic, assign) CGFloat topFocusLevel;
@property (nonatomic, assign) CGFloat bottomFocusLevel;
@property (nonatomic, assign) CGFloat focusFallOffRate;
@property (nonatomic, assign) CGFloat angleRate;

//circle blur
@property (nonatomic, assign) CGPoint excludeCirclePoint;
@property (nonatomic, assign) CGFloat excludeBlurSize;
@property (nonatomic, assign) CGFloat excludeCircleRadius;


@property (nonatomic, assign) BOOL isUseCircleBlur;
@property (nonatomic, assign) BOOL isUseRectangular;
@property (nonatomic, assign) BOOL isResultImage;
@property (nonatomic, assign) CGFloat multiple;
/**
 *  addSubView展示即可
 */
//@property (strong, nonatomic) GPUImageView *gpuImageView;

//- (id)initWithSessionPreset:(NSString *)sessionPreset cameraPosition:(AVCaptureDevicePosition)cameraPosition highVideoQuality:(BOOL)isHighQuality WithFrame:(CGRect)frame;

- (id)initWIthFrame:(CGRect )frame;

- (id)initWithImage:(UIImage *)newImageSource;

- (id)initWithThumbnailImage:(UIImage *)thumbImage;


/**
 *  选择不同的滤镜类型
 */
- (void)switchFilterType:(NCFilterType)type;

- (void)switchFilterType:(NCFilterType)type withImages:(NSArray *)images;

/**
 *	添加预览缩略图
 *
 *	@param	缩略图对象
 *	@param	滤镜类型    
 */
- (void)addNewGPUImageViewTarget:(GPUImageView *)view andFilterType:(NCFilterType)type;

/**
 *  快速实例化对象
 *
 *  @param frame    gpuImageView的frame
 *  @param rawImage 需要进行滤镜处理的image对象
 */
- (id)init;
+ (instancetype)videoCameraWithFrame:(CGRect)frame Image:(UIImage *)rawImage;
+ (instancetype)videoCameraWithGPUImageView:(GPUImageView *)gpuImageView Image:(UIImage *)rawImage andFilterModel:(FilterModel *)model;
- (void)switchFilter:(NCFilterType)type WithCompletionBlock:(FilterCompletionBlock)completion;

- (void)updateFilterParams:(CGFloat)value forUniformName:(NSString *)uniformName;
- (void)updateFilterWithBlurCenter:(CGPoint )center;
- (void)updateBlurFilterWithTopLevelValue:(CGFloat)topValue bottomValue:(CGFloat)bottomValue Type:(NSString *)typeString;
@end
