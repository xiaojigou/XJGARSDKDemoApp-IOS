
#import "ImageViewController.h"
#include "XJGARSDKGPUImage.h"
#include "XJGArSdk.h"


//定义图像视图控制器中相关变量
@interface ImageSampleViewController()
{
    GPUImgLuo::XJGARSDKImageOperator* XJGARSDKImageOperator;
    XJGARSDKFilterType curFilterType;
    XJGARSDKStickerType curStickerType;
    UITextField* textHint;
    XJGARSDKGPUImageView* XJGARSDKGPUImageView1;
    UITextField* filterHint;
    unsigned char* processedFrameDataForSave;
    
    
    UISlider* slider_skinsmooth;
    UISlider* slider_redface;
    UISlider* slider_skinwhiten;
    UISlider* slider_bigeye;
    UISlider* slider_chinsurgery;

}

@end

@implementation ImageSampleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //设置视图的标题
    self.title = @"Image Sample";
    //A structure that contains the location and dimensions of a rectangle.
    //获取主屏幕边界，保存在mainScreenFrame中
    CGRect mainScreenFrame = [[UIScreen mainScreen] bounds];
    
    //分配一个GPU图像视图对象，大小等于主屏幕边界大小
//    XJGARSDKGPUImageView = [[XJGARSDKGPUImageView alloc] initWithFrame:mainScreenFrame];
    XJGARSDKGPUImageView1 = [[XJGARSDKGPUImageView alloc] initWithFrame:mainScreenFrame];
    //[self.view addSubview:XJGARSDKGPUImageView];
    self.view = XJGARSDKGPUImageView1;
    
//    // slider
//    //定义滑动条，并放置到屏幕的底部
//    UISlider* slider = [[UISlider alloc] initWithFrame:CGRectMake(25.0, mainScreenFrame.size.height - 50.0, mainScreenFrame.size.width - 50.0, 40.0)];
//    
//    //Associates a target object and action method with the control.
//    //action:@selector(sliderValueChanged:)表示使用当前类的方法sliderValueChanged的指针给action赋值
//    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
//    slider.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
//    slider.minimumValue = 0.0;
//    slider.maximumValue = 1.0;
//    slider.value = 0.5;
//    [self.view addSubview:slider];
    
    CGFloat interval = 40;
    // 磨皮 创建参数调节的滚动条
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

    
    // select image btn 图像选择按钮
    UIButton* selectImageBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 100, 150, 40)];
    [selectImageBtn setTitle:@"Select Image" forState:UIControlStateNormal];
    [selectImageBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [selectImageBtn setBackgroundColor:[UIColor colorWithWhite:0.7 alpha:0.5]];
    [selectImageBtn addTarget:self action:@selector(selectImageBtnBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectImageBtn];
    
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
    filterHint = [[UITextField alloc]initWithFrame:CGRectMake(10, 80.0, 400, 30)];
    [filterHint setText:@"Filter: Brightness"];
    filterHint.textColor = [UIColor yellowColor];
    [self.view addSubview:filterHint];
    
    
    //XJGARSDKSetOptimizationMode(2);//optimizing for video using asychronized face detection thread,异步线程实现人脸对齐检测的视频模式
    //XJGARSDKSetOptimizationMode(0);//optimizing for video, default, 视频模式,默认
    XJGARSDKSetOptimizationMode(1);//optimizing for image, 图片模式
    
    // proceed
    UIImage *inputImage = [UIImage imageNamed:@"test.jpg"];
    GPUImgLuo::XJGARSDKGLESContextManager::Instance()->CallGLFuncSynch([&]{
        XJGARSDKImageOperator = GPUImgLuo::XJGARSDKImageOperator::create(inputImage);
        
        XJGARSDKImageOperator->addTargetLarge(XJGARSDKGPUImageView1);
        XJGARSDKImageOperator->proceed();
    });

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)orientationDidChange:(NSNotification *)notification
{
    //[&]为c++ 11种的匿名函数，或者叫lamda表达式
    GPUImgLuo::XJGARSDKGLESContextManager::Instance()->CallGLFuncSynch([&]{
        XJGARSDKImageOperator->proceed();
    });
}

//Deallocates the memory occupied by the receiver.
- (void)dealloc
{
    GPUImgLuo::XJGARSDKGLESContextManager::Instance()->CallGLFuncSynch([&]{
        if (XJGARSDKImageOperator) {
//            XJGARSDKImageOperator->release();
            XJGARSDKImageOperator = 0;
        }
        
//        if (filter) {
//            filter->release();
//            filter = 0;
//        }
    });
//    GPUImgLuo::Context::getInstance()->purge();
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
    
    GPUImgLuo::XJGARSDKGLESContextManager::Instance()->CallGLFuncSynch([&]{
        XJGARSDKImageOperator->proceed();
    });

}


- (void)selectImageBtnBtnClicked
{
//    The UIImagePickerController class manages customizable, system-supplied user interfaces
//    for taking pictures and movies on supported devices, and for choosing saved images and
//    movies for use in your app. An image picker controller manages user interactions and delivers t
//    he results of those interactions to a delegate object.
    //UIImagePickerControllerSourceTypePhotoLibrary: 用于Specifies the device’s photo library as
//    the source for the image picker controller.
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController* imagePickerController = [[UIImagePickerController alloc]init];
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerController.delegate = self;
        //Presents a view controller modally.以模态的方式呈现视图控制器对象
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
}


- (void)chooseFilterBtnClicked
{
    XJGARSDKResSelViewController* xjgarsdkResSelViewController
    = [[XJGARSDKResSelViewController alloc] initWithSetXJGARSDKChangeResDelegate:self actionType:0];
    [[self navigationController] pushViewController:xjgarsdkResSelViewController animated:true];
    
    
    GPUImgLuo::XJGARSDKGLESContextManager::Instance()->CallGLFuncSynch([&]{
        XJGARSDKImageOperator->proceed();
    });

}

- (void)chooseStickerPaperBtnClicked
{
    XJGARSDKResSelViewController* xjgarsdkResSelViewController
    = [[XJGARSDKResSelViewController alloc] initWithSetXJGARSDKChangeResDelegate:self actionType:1];
    [[self navigationController] pushViewController:xjgarsdkResSelViewController animated:true];
    
    
    GPUImgLuo::XJGARSDKGLESContextManager::Instance()->CallGLFuncSynch([&]{
        XJGARSDKImageOperator->proceed();
    });

}




- (void)saveImageBtnClicked
{
    GPUImgLuo::XJGARSDKGLESContextManager::Instance()->CallGLFuncSynch([&]{
        int width = XJGARSDKImageOperator->getRotatedFramebufferWidth();
        int heigh = XJGARSDKImageOperator->getRotatedFramebufferHeight();
        if (processedFrameDataForSave != 0) {
            delete[] processedFrameDataForSave;
            processedFrameDataForSave = 0;
        }
        processedFrameDataForSave = XJGARSDKImageOperator->captureAProcessedFrameData( width, heigh);

//        CGDataProviderRef CGDataProviderCreateWithData(void *info, const void *data, size_t size, CGDataProviderReleaseDataCallback releaseData);
//        Description
//        Creates a direct-access data provider that uses data your program supplies.
//        You use this function to create a direct-access data provider that uses callback functions to read data from your program an entire block at one time.
//        Parameters
//        info
//        A pointer to data of any type, or NULL. When Core Graphics calls the function specified in the releaseData parameter, it sends this pointer as its first argument.
//        data
//        A pointer to the array of data that the provider contains.
//        size
//        A value that specifies the number of bytes that the data provider contains.
//        releaseData
//        A pointer to a release callback for the data provider, or NULL. Your release function is called when Core Graphics frees the data provider. For more information, see CGDataProviderReleaseDataCallback.
//
//       CGDataProviderRef: An abstraction for data-reading tasks that eliminates the need to manage a raw memory buffer.
        CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, processedFrameDataForSave, width * heigh * 4 * sizeof(unsigned char), nil);
        
//        CGDataProviderRef: A bitmap image or image mask.
//        CGImageCreate : Creates a bitmap image from data supplied by a data provider.
//        CGColorSpaceCreateDeviceRGB() : Creates a device-dependent RGB color space.
        __block CGImageRef cgImageFromBytes = CGImageCreate(width, heigh, 8, 32, 4 * width, CGColorSpaceCreateDeviceRGB(), kCGBitmapByteOrderDefault | kCGImageAlphaLast, dataProvider, NULL, NO, kCGRenderingIntentDefault);
        
//        UIImage.imageWithCGImage : Creates and returns an image object with the specified scale and orientation factors.
//        UIImageOrientationUp: The default orientation of images. The image is drawn right-side up, as shown here.
        UIImage* finalImage = [UIImage imageWithCGImage:cgImageFromBytes scale:1.0 orientation:UIImageOrientationUp];
        
//        __bridge 使用注意
//        前奏
//        在平常开发中,我们可能遇到 CoreFoundation(CF) 框架的对象和 OC 对象之间的类型转换,这时候我们需要 __bridge 来帮忙
//        注意 : 如果是使用 CF
//        __bridge
//        
//        CF -> OC (只完成类型转换)
//        - (void)bridgeCF2OC{
//            CFStringRef aCFString = CFStringCreateWithCString(NULL, "bridge", kCFStringEncodingASCII);
//            self.myString = (__bridge NSString *)(aCFString);
//            
//            (void)aCFString;
//            
//            NSLog(@"bridge--%@",self.myString);
//            /*
//             __bridge 关键字只负责 CF 到 OC 之间的对象类型转换,并没有把内存管理的权限交给 ARC,因此不管 ARC 还是 MRC 我们都需要管理 CF 对象的内存
//             */
//            CFRelease(aCFString);
//        }
//        OC -> CF (只完成类型转换)
//        NSString *aString = [NSString stringWithFormat:@"test"];
//        CFStringRef cString = (__bridge CFStringRef)(aString);
//        /*
//         现在 String 的生命在 OC 手上,CF无法干预内存管理
//         */
//        // CFRelease(cString);
//        NSLog(@"%@",cString);
//        __bridge_transfer 或者 CFBridgingRelease()
//        
//        CF -> OC (完成类型转换的同时,赋予了ARC管理内存的权限,CF还是有权限的)
//        NSString *aNSString = [[NSString alloc]initWithFormat:@"test"];
//        CFStringRef aCFString = (__bridge_retained CFStringRef) aNSString;
//        // 赋予ARC 管理内存的权利
//        aNSString = (__bridge_transfer NSString *)aCFString;
//        aNSString = nil;
//        // 这里已经把权限交给了 ARC 了,如果ARC已经释放了内存,那么CF对象还是无法读取内存
//        // NSLog(@"%@",aCFString);
//        // CFRelease(aCFString);
//        // NSLog(@"%@",aNSString);
//        __bridge_retained 或者 CFBridgingRetain()
//        
//        OC -> CF (完成类型转换的同时,剥夺了ARC管理内存的权限,CF还是有权限的)
//        NSString *aString = [NSString stringWithFormat:@"test"];
//        // 这时候对象的生命 周期管理责任交给 CF 了
//        CFStringRef cString = (__bridge_retained CFStringRef)(aString);
//        // 原对象的内存并不会因此而销毁
//        aString = nil;
//        NSLog(@"%@",cString);
//        // 正确的释放方法 :
//        CFRelease(cString);
        
//    UIImageWriteToSavedPhotosAlbum:  Adds the specified image to the user’s Camera Roll album.
        UIImageWriteToSavedPhotosAlbum(finalImage, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
        
        //保存完图像后释放资源，减少引用计数，decrements the retain count of a bitmap image.
        CGImageRelease(cgImageFromBytes);
        //decrements the retain count of a bitmap image.
        CGDataProviderRelease(dataProvider);
    });
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSLog(@"didFinishSaving image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
    
    //内存释放回调函数
    delete[] processedFrameDataForSave;
    processedFrameDataForSave = 0;
}

//图像挑选控制器对象
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSString* mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"])
    {
        UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
//        GPUImgLuo::Context::getInstance()->purge(); // purge the cache if you want
        GPUImgLuo::XJGARSDKGLESContextManager::Instance()->CallGLFuncSynch([&]{
            XJGARSDKImageOperator->setImage(image)->proceed();
            
        });
    }
    
//    void (^animations)(void) = ^{ }；
//    这是一个block代码块，表示一个变量名为animations，无参数，无返回值的函数。
//    {}这里面放的是回调执行的代码，至于回调是什么意思，你去cocoachina看下基础知识就可以了。
    [picker dismissViewControllerAnimated:false completion:nil];
}


#pragma mark - FilterListView delegate
//- (void)filterSelected:(XJGARSDKFilterType)filterIdx
//{
//    curFilterType = filterIdx;
//    NSString* hint = [[NSString alloc] initWithFormat:@"Filter: %@", [XJGARSDKResInterface getFilterNameByFilterIdx:filterIdx]];
//    [filterHint setText:hint];
//
//    
//}

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
    
    XJGARSDKChangeStickpaper([[XJGARSDKResInterface getStickerNameByStickerIdx:stickerIdx] UTF8String]);
    
}

@end
