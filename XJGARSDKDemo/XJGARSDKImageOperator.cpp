

#include "XJGARSDKImageOperator.h"

using namespace GPUImgLuo;

//用指定的宽度、高度及像素值创建，并初始化一个图像类
XJGARSDKImageOperator* XJGARSDKImageOperator::create(int width, int height, const void* pixels) {
    XJGARSDKImageOperator* imgObj = new XJGARSDKImageOperator();
    imgObj->setImage(width, width, pixels);
    return imgObj;
}

//用指定的宽度、高度及像素值初始化当前的图像类
XJGARSDKImageOperator* XJGARSDKImageOperator::setImage(int width, int height, const void* pixels) {

    _framebuffer2 = 0;
    static  XJGARSDKFramebuffer* framebuffer2  = NULL;
    if(framebuffer2==NULL)
        framebuffer2 = new XJGARSDKFramebuffer(width, height, false);
    _framebuffer2 = framebuffer2;

    CHECK_GL(glBindTexture(GL_TEXTURE_2D, _framebuffer2->GetAttachedTexture()));
    CHECK_GL(glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, pixels));
    CHECK_GL(glBindTexture(GL_TEXTURE_2D, 0));
    return this;
}


//从图像url中创建新的XJGARSDKImageOperator对象，并初始化
XJGARSDKImageOperator* XJGARSDKImageOperator::create(NSURL* imageUrl) {
    XJGARSDKImageOperator* imgObj = new XJGARSDKImageOperator();
    imgObj->setImage(imageUrl);
    return imgObj;
}

//用指定url的图像数据初始化当前类对象
XJGARSDKImageOperator* XJGARSDKImageOperator::setImage(NSURL* imageUrl) {
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:imageUrl];
    setImage(imageData);
    return this;
}

//用指定的图像数据创建新的XJGARSDKImageOperator对象，并初始化
XJGARSDKImageOperator* XJGARSDKImageOperator::create(NSData* imageData) {
    XJGARSDKImageOperator* imgObj = new XJGARSDKImageOperator();
    imgObj->setImage(imageData);
    return imgObj;
}

//用指定的图像数据初始化当前类对象
XJGARSDKImageOperator* XJGARSDKImageOperator::setImage(NSData* imageData) {
    UIImage* inputImage = [[UIImage alloc] initWithData:imageData];
    setImage(inputImage);
    return this;
}

//用指定的图像数据创建新的XJGARSDKImageOperator对象，并初始化，UIImage是系统提供的图像管理类
XJGARSDKImageOperator* XJGARSDKImageOperator::create(UIImage* image) {
    XJGARSDKImageOperator* imgObj = new XJGARSDKImageOperator();
    imgObj->setImage(image);
    return imgObj;
}

//用指定的图像数据初始化当前类对象，UIImage是系统提供的图像管理类
XJGARSDKImageOperator* XJGARSDKImageOperator::setImage(UIImage* image) {
    UIImage* img = _adjustImageOrientation(image);
    setImage([img CGImage]);
    return this;
}

//用指定的图像数据创建新的XJGARSDKImageOperator对象，并初始化，CGImageRef是系统提供的位图对象类，或掩码图像类
XJGARSDKImageOperator* XJGARSDKImageOperator::create(CGImageRef image) {
    XJGARSDKImageOperator* imgObj = new XJGARSDKImageOperator();
    imgObj->setImage(image);
    return imgObj;
}

//用指定的图像数据初始化当前类对象，CGImageRef是系统提供的图像管理类
XJGARSDKImageOperator* XJGARSDKImageOperator::setImage(CGImageRef image) {
    GLubyte *imageData = NULL;
    CFDataRef dataFromImageDataProvider = CGDataProviderCopyData(CGImageGetDataProvider(image));
    imageData = (GLubyte *)CFDataGetBytePtr(dataFromImageDataProvider);
    int width = (int)CGImageGetWidth(image);
    int height = (int)CGImageGetHeight(image);
    assert((width > 0 && height > 0) && "image can not be empty");
    
    setImage(width, height, imageData);
    
    CFRelease(dataFromImageDataProvider);
    
    return this;

}

//给定一张UIImage对象，根据图像的朝向重新调整图像朝向
UIImage* XJGARSDKImageOperator::_adjustImageOrientation(UIImage* image)
{
    if (image.imageOrientation == UIImageOrientationUp)
        return image;
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    //先对变换矩阵的朝向进行变换设置
    switch (image.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, image.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    //然后根据设置的图像朝向，设置图像变换的尺度因子（缩放）
    switch (image.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    //创建位图上下文，指定图像高宽、颜色空间、及其他信息
    CGContextRef ctx = CGBitmapContextCreate(NULL, image.size.width, image.size.height,
                                             CGImageGetBitsPerComponent(image.CGImage), 0,
                                             CGImageGetColorSpace(image.CGImage),
                                             CGImageGetBitmapInfo(image.CGImage));
    //用指定的变换矩阵设置位图上下文的坐标系统，（位图进行变换）
    CGContextConcatCTM(ctx, transform);
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            //绘制位图到指定上下文
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.height,image.size.width), image.CGImage);
            break;
        default:
            //绘制位图到指定上下文
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.width,image.size.height), image.CGImage);
            break;
    }
    
    //获取指定位图上下文中的位图数据，斌创建新的UIImage类对象
    CGImageRef cgImage = CGBitmapContextCreateImage(ctx);
    UIImage* newImage = [UIImage imageWithCGImage:cgImage];
    CGContextRelease(ctx);
    CGImageRelease(cgImage);
    return newImage;
}



#define rotationSwapsSize(rotation) ((rotation) == GPUImgLuo::RotateLeft || (rotation) == GPUImgLuo::RotateRight || (rotation) == GPUImgLuo::RotateRightFlipVertical || (rotation) == GPUImgLuo::RotateRightFlipHorizontal)

//获取当前旋转模式下，实际图像的宽度
int XJGARSDKImageOperator::getRotatedFramebufferWidth() const {
    if (_framebuffer2)
        if (rotationSwapsSize(_outputRotation2))
            return _framebuffer2->GetFrameBufHeight();
        else
            return _framebuffer2->GetFrameBufWidth();
        else
            return 0;
}

//获取当前旋转模式下，实际图像的高度
int XJGARSDKImageOperator::getRotatedFramebufferHeight() const {
    if (_framebuffer2)
        if (rotationSwapsSize(_outputRotation2))
            return _framebuffer2->GetFrameBufWidth();
        else
            return _framebuffer2->GetFrameBufHeight();
        else
            return 0;
}

//用于捕获一帧，指定捕获的宽度与高度
unsigned char* XJGARSDKImageOperator::captureAProcessedFrameData( int width/* = 0*/, int height/* = 0*/) {

    //如果还没有取得高度宽度值，则从帧缓存中获取
    if (width <= 0 || height <= 0) {
        if (!_framebuffer2) return 0;
        width = getRotatedFramebufferWidth();
        height = getRotatedFramebufferHeight();
    }

    XJGARSDKFramebuffer* framebuffer =_framebuffer2;
    RotationMode rotationMode =_outputRotation2 = NoRotation;
    setInputFramebuffer(mLargeView,framebuffer,rotationMode,0);
    updateTargetview(mLargeView);

    
    unsigned char* processedFrameData = new unsigned char[width * height * 4];
    CHECK_GL(glReadPixels(0, 0, width, height, GL_RGBA, GL_UNSIGNED_BYTE, processedFrameData));

    return processedFrameData;
}


