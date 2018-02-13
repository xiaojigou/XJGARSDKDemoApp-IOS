
#import "CameraViewController.h"
#include "XJGARSDKGPUImage.h"
#include "XJGArSdk.h"


@interface CameraSampleViewController()
{
    GPUImgLuo::XJGARSDKCameraOperator* camera;
    XJGARSDKGPUImageView* filteredView;
    XJGARSDKFilterType curFilterType;
    XJGARSDKStickerType curStickerType;
    UITextField* textHint;
    unsigned char* processedFrameDataForSave;
    
    UISlider* slider_skinsmooth;
    UISlider* slider_redface;
    UISlider* slider_skinwhiten;
    UISlider* slider_bigeye;
    UISlider* slider_chinsurgery;
    
}

@end

@implementation CameraSampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect mainScreenFrame = [[UIScreen mainScreen] bounds];
    
    //初始化过滤后的视图
    filteredView = [[XJGARSDKGPUImageView alloc] initWithFrame:mainScreenFrame];
    //创建一个纯视图，非过滤后的原始视图？？
    XJGARSDKGPUImageView* pureView = [[XJGARSDKGPUImageView alloc] initWithFrame:CGRectMake(mainScreenFrame.size.width - 110, 80.0, 100, 100)];
    [pureView setFillMode:GPUImagViewFillMode::PreserveAspectRatioAndFill];

    self.view = filteredView;
    [self.view addSubview:pureView];//dds a view to the end of the receiver’s list of subviews.
    
    CGFloat interval = 40;
    // 磨皮 创建参数调节的滚动条
    UISlider* slider = [[UISlider alloc] initWithFrame:CGRectMake(25.0, mainScreenFrame.size.height - interval * 3, mainScreenFrame.size.width - 50.0, 40.0)];
    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    slider.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    slider.minimumValue = 0.0;
    slider.maximumValue = 100.0;
    slider.value = 50.0;
    [self.view addSubview:slider];
    slider_skinsmooth = slider;
    //红润
    slider = [[UISlider alloc] initWithFrame:CGRectMake(25.0, mainScreenFrame.size.height - interval * 2, mainScreenFrame.size.width - 50.0, 40.0)];
    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    slider.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    slider.minimumValue = 0.0;
    slider.maximumValue = 100.0;
    slider.value = 50.0;
    [self.view addSubview:slider];
    slider_redface = slider;
    //美白
    slider = [[UISlider alloc] initWithFrame:CGRectMake(0.0, mainScreenFrame.size.height - interval * 1, mainScreenFrame.size.width - 50.0, 40.0)];
    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    slider.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    slider.minimumValue = 0.0;
    slider.maximumValue = 100.0;
    slider.value = 50.0;
    [self.view addSubview:slider];
    slider_skinwhiten = slider;
    //大眼
    slider = [[UISlider alloc] initWithFrame:CGRectMake(25.0, mainScreenFrame.size.height - interval * 4, mainScreenFrame.size.width - 50.0, 40.0)];
    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    slider.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    slider.minimumValue = 0.0;
    slider.maximumValue = 100.0;
    slider.value = 50.0;
    [self.view addSubview:slider];
    slider_bigeye = slider;
    //瘦脸
    slider = [[UISlider alloc] initWithFrame:CGRectMake(25.0, mainScreenFrame.size.height - interval * 5, mainScreenFrame.size.width - 50.0, 40.0)];
    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    slider.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    slider.minimumValue = 0.0;
    slider.maximumValue = 100.0;
    slider.value = 50.0;
    [self.view addSubview:slider];
    slider_chinsurgery = slider;
    
    
    // flip camera btn 相机切换的按钮
    UIButton* flipCameraBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 100, 150, 40)];
    [flipCameraBtn setTitle:@"Flip Camera" forState:UIControlStateNormal];
    [flipCameraBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [flipCameraBtn setBackgroundColor:[UIColor colorWithWhite:0.7 alpha:0.5]];
    [flipCameraBtn addTarget:self action:@selector(flipCameraBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:flipCameraBtn];
    
    // choose filter btn 滤镜选择按钮
    UIButton* chooseFilterBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 150, 150, 40)];
    [chooseFilterBtn setTitle:@"Choose Filter" forState:UIControlStateNormal];
    [chooseFilterBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [chooseFilterBtn setBackgroundColor:[UIColor colorWithWhite:0.7 alpha:0.5]];
    [chooseFilterBtn addTarget:self action:@selector(chooseFilterBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:chooseFilterBtn];
    
    
    // choose sticker papers 贴纸选择
    UIButton* stickerSelImageBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 200, 150, 40)];
    [stickerSelImageBtn setTitle:@"Chooose Sticker" forState:UIControlStateNormal];
    [stickerSelImageBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [stickerSelImageBtn setBackgroundColor:[UIColor colorWithWhite:0.7 alpha:0.5]];
    [stickerSelImageBtn addTarget:self action:@selector(chooseStickerPaperBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stickerSelImageBtn];

    
    // save image btn 保存图像按钮
    UIButton* saveImageBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 250, 150, 40)];
    [saveImageBtn setTitle:@"Save Image" forState:UIControlStateNormal];
    [saveImageBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [saveImageBtn setBackgroundColor:[UIColor colorWithWhite:0.7 alpha:0.5]];
    [saveImageBtn addTarget:self action:@selector(saveImageBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveImageBtn];
    processedFrameDataForSave = 0;
    
    // filter text field 过滤参数的文本显示
    textHint = [[UITextField alloc]initWithFrame:CGRectMake(10, 80.0, 400, 30)];
    [textHint setText:@"Filter: Brightness"];
    textHint.textColor = [UIColor yellowColor];
    [self.view addSubview:textHint];
    

    //XJGARSDKSetOptimizationMode(0);//optimizing for video
    
    XJGARSDKSetOptimizationMode(2);//optimizing for video using asychronized face detection thread,异步线程实现人脸对齐检测的视频模式
    //XJGARSDKSetOptimizationMode(0);//optimizing for video, default, 视频模式,默认
    //XJGARSDKSetOptimizationMode(1);//optimizing for image, 图片模式
    
    
    camera = GPUImgLuo::XJGARSDKCameraOperator::create();
    camera->setOutputImageOrientation(UIInterfaceOrientationPortrait);
//    camera->setHorizontallyMirrorFrontFacingCamera(true);
    camera->addTargetLarge( filteredView );//将直接显示相机内容的纯视图（不做其他操作）加入到相机的渲染目标中
    camera->addTargetSmall(pureView);//addTarget仍然会返回一个source对象
    camera->start();

}

- (void)sliderValueChanged:(id)sender
{
//    CGFloat value = [(UISlider *)sender value];
    
    
//    UISlider* slider_skinsmooth;
//    UISlider* slider_redface;
//    UISlider* slider_skinwhiten;
//    UISlider* slider_bigeye;
//    UISlider* slider_chinsurgery;

    XJGARSDKSetBigEyeParam([slider_bigeye value]);
    XJGARSDKSetRedFaceParam([slider_redface value]);
    XJGARSDKSetWhiteSkinParam([slider_skinwhiten value]);
    XJGARSDKSetSkinSmoothParam([slider_skinsmooth value]);
    XJGARSDKSetThinChinParam([slider_chinsurgery value]);
}

- (void)flipCameraBtnClicked
{
        camera->flip();
}

extern int g_actionType;
- (void)chooseFilterBtnClicked
{
    XJGARSDKResSelViewController* xjgarsdkResSelViewController
    = [[XJGARSDKResSelViewController alloc] initWithSetXJGARSDKChangeResDelegate:self actionType:0];
    [[self navigationController] pushViewController:xjgarsdkResSelViewController animated:true];
    
}

- (void)chooseStickerPaperBtnClicked
{
    
    XJGARSDKResSelViewController* xjgarsdkResSelViewController
    = [[XJGARSDKResSelViewController alloc] initWithSetXJGARSDKChangeResDelegate:self actionType:1];
    [[self navigationController] pushViewController:xjgarsdkResSelViewController animated:true];
}



- (void)saveImageBtnClicked
{
        int width = camera->getRotatedFramebufferWidth();
        int height = camera->getRotatedFramebufferHeight();
        if (processedFrameDataForSave != 0) {
            delete[] processedFrameDataForSave;
            processedFrameDataForSave = 0;
        }
        processedFrameDataForSave = camera->captureAProcessedFrameData( width, height);
        
        CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, processedFrameDataForSave, width * height * 4 * sizeof(unsigned char), nil);
        __block CGImageRef cgImageFromBytes = CGImageCreate(width, height, 8, 32, 4 * width, CGColorSpaceCreateDeviceRGB(), kCGBitmapByteOrderDefault | kCGImageAlphaLast, dataProvider, NULL, NO, kCGRenderingIntentDefault);
        
        UIImage* finalImage = [UIImage imageWithCGImage:cgImageFromBytes scale:1.0 orientation:UIImageOrientationUp];
        UIImageWriteToSavedPhotosAlbum(finalImage, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
        
        CGImageRelease(cgImageFromBytes);
        CGDataProviderRelease(dataProvider);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSLog(@"didFinishSaving image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
    
    delete[] processedFrameDataForSave;
    processedFrameDataForSave = 0;
}

- (void)dealloc
{
        if (camera) {
            camera = 0;
        }
}

#pragma mark - XJGARSDKChangeResDelegate
- (void)onFilterSelected:(XJGARSDKFilterType)filterIdx
{
    curFilterType = filterIdx;
    NSString* hint = [[NSString alloc] initWithFormat:@"Filter: %@", [XJGARSDKResInterface getFilterNameByFilterIdx:filterIdx]];
    [textHint setText:hint];
    
    XJGARSDKChangeFilter([[XJGARSDKResInterface getFilterNameByFilterIdx:filterIdx] UTF8String]);
    
}


- (void)onStickerPaperSelected: (XJGARSDKStickerType)stickerIdx;
{
    curStickerType = stickerIdx;
    NSString* hint = [[NSString alloc] initWithFormat:@"Sticker: %@", [XJGARSDKResInterface getStickerNameByStickerIdx:stickerIdx]];
    [textHint setText:hint];
    
    NSString*  stickerPaperName =[XJGARSDKResInterface getStickerNameByStickerIdx:stickerIdx];
    if([stickerPaperName isEqualToString:@"sticker_none"])
    {
        XJGARSDKSetShowStickerPapers(false);
    }
    else
    {
        XJGARSDKSetShowStickerPapers(true);
        XJGARSDKChangeStickpaper([stickerPaperName UTF8String]);

    }
}


@end
