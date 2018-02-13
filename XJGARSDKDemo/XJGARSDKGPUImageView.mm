
#import "XJGARSDKGPUImageView.h"
#include "XJGARSDKGLESContextManager.h"
#include "XJGARSDKShaderProgram.h"
#import <AVFoundation/AVFoundation.h>
#include "XJGArSdk.h"

#define STRINGIZE(x) #x
#define SHADER_STRING(text) STRINGIZE(text)

// Hardcode the vertex shader for standard filters, but this can be overridden
const std::string kDefaultVertexShader = SHADER_STRING
(
 attribute vec4 position;
 attribute vec4 texCoord;
 
 varying vec2 vTexCoord;
 
 void main()
 {
     gl_Position = position;
     vTexCoord = texCoord.xy;
 }
 );

const std::string kDefaultFragmentShader = SHADER_STRING
(
 varying highp vec2 vTexCoord;
 uniform sampler2D colorMap;
 
 void main()
 {
     gl_FragColor = texture2D(colorMap, vTexCoord);
 }
 );




@interface XJGARSDKGPUImageView()
{
    
    GPUImgLuo::XJGARSDKFramebuffer* framebuffer_ForSDKInput_Video;
    GPUImgLuo::XJGARSDKFramebuffer* framebuffer_ForSDKInput_Image;
    GPUImgLuo::XJGARSDKFramebuffer* inputFramebuffer;
    GPUImgLuo::RotationMode inputRotation;
    GLuint displayFramebuffer;
    GLuint displayRenderbuffer;
    GPUImgLuo::XJGARSDKShaderProgram* displayProgram;
    GLuint positionAttribLocation;
    GLuint texCoordAttribLocation;
    GLuint colorMapUniformLocation;
    
    GLfloat displayVertices[8];
    GLint framebufferWidth, framebufferHeight;
    CGSize lastBoundsSize;
    
    GLfloat backgroundColorRed, backgroundColorGreen, backgroundColorBlue, backgroundColorAlpha;
    
    
    EAGLContext* _eglContext;

    
//    GPUImagViewFillMode fillMode;
    
    
    
    
    
    GLuint          _frameBuffer1;
    GLuint          _vbo1;
    GLuint          _texture1;
    int             _vertCount;

    
}

@end


@implementation XJGARSDKGPUImageView

+ (Class)layerClass
{
//    A layer that supports drawing OpenGL content in iOS and tvOS applications.
//    If you plan to use OpenGL for your rendering, use this class as the backing layer for your views by returning it from your view’s layerClass class method. The returned CAEAGLLayer object is a wrapper for a Core Animation surface that is fully compatible with OpenGL ES function calls.
    return [CAEAGLLayer class];
}
//指定帧区域进行初始化操作
- (id)initWithFrame:(CGRect)frame
{
    framebuffer_ForSDKInput_Image = NULL;
    framebuffer_ForSDKInput_Video = NULL;
    
    //初始化并返回新创建的帧视图对象
    if (!(self = [super initWithFrame:frame]))
    {
        return nil;
    }
    //调用公共初始化函数进行初始化
    [self commonInit];
    
    return self;
}
//公共初始化函数，包含设置Opengl颜色格式，双缓冲等
- (void)commonInit;
{
    inputRotation = GPUImgLuo::NoRotation;//默认不对坐标进行选择操作
    self.opaque = YES;
    self.hidden = NO;
    CAEAGLLayer* eaglLayer = (CAEAGLLayer*)self.layer;
    eaglLayer.opaque = YES;
//    NSNumber is a subclass of NSValue that offers a value as any C scalar (numeric) type.
//    NSNumber.numberWithBool :Creates and returns an NSNumber object containing a given value, treating it as a BOOL.
//    NSDictionary.dictionaryWithObjectsAndKeys: Creates and returns a dictionary containing entries
//    constructed from the specified set of values and keys.
//    This method is similar to dictionaryWithObjects:forKeys:, differing only in the way key-value pairs
//    are specified.
//    For example:
//    Listing 1
//    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
//                          @"value1", @"key1", @"value2", @"key2", nil];
    //设置绘制的层属性，为字典集合对象。创建的字典集合对象指定颜色格式（kEAGLDrawablePropertyColorFormat）为
//    8bitRGBA（kEAGLColorFormatRGBA8）；保留背面属性（kEAGLDrawablePropertyRetainedBacking）为
//    false（[NSNumber numberWithBool:NO]）
    eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
    
    
//    C++11 lambda 表达式解析//    [a,&b] a变量以值的方式呗捕获，b以引用的方式被捕获。
//    [this] 以值的方式捕获 this 指针。
//    [&] 以引用的方式捕获所有的外部自动变量。
//    [=] 以值的方式捕获所有的外部自动变量。
//    [] 不捕获外部的任何变量。
    
    //这里使用引用的方式，引用外部变量的值，在lamda函数种改变的值，外部变量也会改变,
    //lamda表达式的函数，将会在渲染的函数种被自动调用
    GPUImgLuo::XJGARSDKGLESContextManager::Instance()->CallGLFuncSynch([&]{
        
        //
        displayProgram = GPUImgLuo::XJGARSDKShaderProgram::CreatShaderProgramFromString(kDefaultVertexShader, kDefaultFragmentShader);

        positionAttribLocation = displayProgram->GetAttribLocation("position");
        texCoordAttribLocation = displayProgram->GetAttribLocation("texCoord");
        colorMapUniformLocation = displayProgram->GetUniformLocation("colorMap");
        
        
        displayProgram->UseThisProgram();
        glEnableVertexAttribArray(positionAttribLocation);
        glEnableVertexAttribArray(texCoordAttribLocation);
        
        [self setBackgroundColorRed:0.0 green:0.0 blue:0.0 alpha:0.0];
        _fillMode = GPUImagViewFillMode::PreserveAspectRatio;//填充模式设置为保留高宽比
        [self createDisplayFramebuffer];
    });
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //判断两个size对象是否相等，相等返回YES，否则返回NO
    if (!CGSizeEqualToSize(self.bounds.size, lastBoundsSize) &&
        !CGSizeEqualToSize(self.bounds.size, CGSizeZero)) {
        [self destroyDisplayFramebuffer];//大小发生了变化，则要将之前创建的帧缓存销毁，然后重新创建
        [self createDisplayFramebuffer];
    }
}
//析构函数
- (void)dealloc
{
    [self destroyDisplayFramebuffer];
}



-(void) useAsCurrent;
{
 
    if ([EAGLContext currentContext] != _eglContext)
    {
        [EAGLContext setCurrentContext:_eglContext];
    }

}
-(void) presentBufferForDisplay;
{
    [_eglContext presentRenderbuffer:GL_RENDERBUFFER ];
}

//创建帧缓存对象，
- (void)createDisplayFramebuffer;
{
    GPUImgLuo::XJGARSDKGLESContextManager::Instance()->CallGLFuncSynch([&]{
        
        glGenRenderbuffers(1, &displayRenderbuffer);
        glBindRenderbuffer(GL_RENDERBUFFER, displayRenderbuffer);
        //设置Opengl上下文的渲染缓存存储属性及fromDrawable属性
        [GPUImgLuo::XJGARSDKGLESContextManager::Instance()->GetEGLContext() renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer*)self.layer];
        
        glGenFramebuffers(1, &displayFramebuffer);
        glBindFramebuffer(GL_FRAMEBUFFER, displayFramebuffer);
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0,
                                  GL_RENDERBUFFER, displayRenderbuffer);
        
        glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &framebufferWidth);
        glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &framebufferHeight);
        
        lastBoundsSize = self.bounds.size;
        [self updateDisplayVertices];
    });
}
//销毁帧缓存及渲染缓存对象
- (void)destroyDisplayFramebuffer;
{
    GPUImgLuo::XJGARSDKGLESContextManager::Instance()->CallGLFuncSynch([&]{
        
        if (displayFramebuffer)
        {
            glDeleteFramebuffers(1, &displayFramebuffer);
            displayFramebuffer = 0;
        }
        
        if (displayRenderbuffer)
        {
            glDeleteRenderbuffers(1, &displayRenderbuffer);
            displayRenderbuffer = 0;
        }
    });
}

//绑定帧缓存对象用于显示
- (void)setDisplayFramebuffer;
{
    if (!displayFramebuffer)
    {
        [self createDisplayFramebuffer];
    }
    
    GPUImgLuo::XJGARSDKGLESContextManager::Instance()->CallGLFuncSynch([&]{
        glBindFramebuffer(GL_FRAMEBUFFER, displayFramebuffer);
        glViewport(0, 0, framebufferWidth, framebufferHeight);
    });
}
//显示帧缓存对象
- (void)presentFramebuffer;
{
    GPUImgLuo::XJGARSDKGLESContextManager::Instance()->CallGLFuncAsync([&]{
        glBindRenderbuffer(GL_RENDERBUFFER, displayRenderbuffer);
        GPUImgLuo::XJGARSDKGLESContextManager::Instance()->SwapEGLBuffers();
    });
}
//设置背景红绿蓝颜色
- (void)setBackgroundColorRed:(GLfloat)redComponent green:(GLfloat)greenComponent blue:(GLfloat)blueComponent alpha:(GLfloat)alphaComponent;
{
    backgroundColorRed = redComponent;
    backgroundColorGreen = greenComponent;
    backgroundColorBlue = blueComponent;
    backgroundColorAlpha = alphaComponent;
}
//根据时间对场景及纹理进行更新，并绘制对象到帧缓存中
- (void)updateTargetView:(float)frameTime {
    
    GPUImgLuo::XJGARSDKGLESContextManager::Instance()->CallGLFuncSynch([&]{
        
        
        
        if(framebuffer_ForSDKInput_Image==NULL)
            framebuffer_ForSDKInput_Image = new GPUImgLuo::XJGARSDKFramebuffer(_rotatedFrameBufWidth,
                                                                         _rotatedFrameBufHeight, true);
        
        displayProgram->UseThisProgram();
        framebuffer_ForSDKInput_Image->BeginRenderFrameBuffer();
        glClearColor(backgroundColorRed, backgroundColorGreen, backgroundColorBlue, backgroundColorAlpha);
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
        glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_2D,  inputFramebuffer->GetAttachedTexture());
        glUniform1i(colorMapUniformLocation, 0);
        
        glVertexAttribPointer(positionAttribLocation, 2, GL_FLOAT, 0, 0, displayVertices);
        //需要将坐标上下翻转，
        const GLfloat * pTexCoords = [self textureCoordinatesForRotation:inputRotation];
        GLfloat pTexCoords2[8] = {
            pTexCoords[4],pTexCoords[5],
            pTexCoords[6],pTexCoords[7],
            pTexCoords[0],pTexCoords[1],
            pTexCoords[2],pTexCoords[3]
        };
        glVertexAttribPointer(texCoordAttribLocation, 2, GL_FLOAT, 0, 0,  pTexCoords2);
        
        glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
        framebuffer_ForSDKInput_Image->EndRenderFrameBuffer();
        
        
        int outPutTexId = 0;
        XJGARSDKRenderGLTexture( framebuffer_ForSDKInput_Image->GetAttachedTexture(),framebuffer_ForSDKInput_Image->GetFrameBufWidth(), framebuffer_ForSDKInput_Image->GetFrameBufHeight(), &outPutTexId);
        
        

        displayProgram->UseThisProgram();
        [self setDisplayFramebuffer];
        glClearColor(backgroundColorRed, backgroundColorGreen, backgroundColorBlue, backgroundColorAlpha);
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

        glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_2D, outPutTexId);
        glUniform1i(colorMapUniformLocation, 0);

        glVertexAttribPointer(positionAttribLocation, 2, GL_FLOAT, 0, 0, displayVertices);
        //需要将坐标上下翻转回来，
        GLfloat pTexCoords4[8] = {
            pTexCoords[4],pTexCoords[5],
            pTexCoords[6],pTexCoords[7],
            pTexCoords[0],pTexCoords[1],
            pTexCoords[2],pTexCoords[3]
        };
        glVertexAttribPointer(texCoordAttribLocation, 2, GL_FLOAT, 0, 0, pTexCoords4);

        glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
        
        
//        displayProgram->UseThisProgram();
//        [self setDisplayFramebuffer];
//        glClearColor(backgroundColorRed, backgroundColorGreen, backgroundColorBlue, backgroundColorAlpha);
//        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
//        
//        glActiveTexture(GL_TEXTURE0);
//        glBindTexture(GL_TEXTURE_2D, inputFramebuffer->GetAttachedTexture());
//        glUniform1i(colorMapUniformLocation, 0);
//        
//        glVertexAttribPointer(positionAttribLocation, 2, GL_FLOAT, 0, 0, displayVertices);
//        glVertexAttribPointer(texCoordAttribLocation, 2, GL_FLOAT, 0, 0, [self textureCoordinatesForRotation:inputRotation] );
//        
//        glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
        
        [self presentFramebuffer];
    });
}



///////////////////////////////////////////////////////////////////////////////////
//
//GLuint createVBO(GLenum target, int usage, int datSize, void *data)
//{
//    GLuint vbo;
//    glGenBuffers(1, &vbo);
//    glBindBuffer(target, vbo);
//    glBufferData(target, datSize, data, usage);
//    return vbo;
//}
//
//- (void)setupVBO1
//{
//    _vertCount = 6;
//    
//    GLfloat vertices[] = {
//        1.0f,  1.0f, 0.0f, 1.0f, 1.0f,   // 右上
//        1.0f, -1.0f, 0.0f, 1.0f, 0.0f,   // 右下
//        -1.0f, -1.0f, 0.0f, 0.0f, 0.0f,  // 左下
//        -1.0f,  1.0f, 0.0f, 0.0f, 1.0f   // 左上
//    };
//    
//    // 创建VBO
//    _vbo1 = createVBO(GL_ARRAY_BUFFER, GL_STATIC_DRAW, sizeof(vertices), vertices);
//    //    glEnableVertexAttribArray(glGetAttribLocation(_program1, "position"));
//    //    glVertexAttribPointer(glGetAttribLocation(_program1, "position"), 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*5, NULL);
//    //
//    //    glEnableVertexAttribArray(glGetAttribLocation(_program1, "texcoord"));
//    //    glVertexAttribPointer(glGetAttribLocation(_program1, "texcoord"), 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*5, NULL+sizeof(GL_FLOAT)*3);
//}
//
//
//GLuint createTexture2D(GLenum format, int width, int height, void *data)
//{
//    GLuint texture;
//    glGenTextures(1, &texture);
//    glBindTexture(GL_TEXTURE_2D, texture);
//    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
//    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
//    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
//    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
//    glTexImage2D(GL_TEXTURE_2D, 0, format, width, height, 0, format, GL_UNSIGNED_BYTE, data);
//    glBindTexture(GL_TEXTURE_2D, 0);
//    return texture;
//}
//
//- (void)setupFrameBuffer1
//{
//    _texture1 = createTexture2D(GL_RGBA, self.frame.size.width, self.frame.size.height, NULL);
//    glGenFramebuffers(1, &_frameBuffer1);
//    // 设置为当前 framebuffer
//    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer1);
//    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, _texture1, 0);
//}


#include "XJGARSDKFramebuffer.h"

//根据时间对场景及纹理进行更新，并绘制对象到帧缓存中
- (void)renderAndUpdateTargetview:(float)frameTime {
    
    GPUImgLuo::XJGARSDKGLESContextManager::Instance()->CallGLFuncSynch([&]{
        
        if(framebuffer_ForSDKInput_Video==NULL)
            framebuffer_ForSDKInput_Video = new GPUImgLuo::XJGARSDKFramebuffer(_rotatedFrameBufWidth,
                                                              _rotatedFrameBufHeight, true);
        
        displayProgram->UseThisProgram();
        framebuffer_ForSDKInput_Video->BeginRenderFrameBuffer();
        glClearColor(backgroundColorRed, backgroundColorGreen, backgroundColorBlue, backgroundColorAlpha);
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
        glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_2D,  inputFramebuffer->GetAttachedTexture());
        glUniform1i(colorMapUniformLocation, 0);
        
        glVertexAttribPointer(positionAttribLocation, 2, GL_FLOAT, 0, 0, displayVertices);
        //需要将坐标上下翻转，
        const GLfloat * pTexCoords = [self textureCoordinatesForRotation:inputRotation];
        GLfloat pTexCoords2[8] = {
            pTexCoords[4],pTexCoords[5],
            pTexCoords[6],pTexCoords[7],
            pTexCoords[0],pTexCoords[1],
            pTexCoords[2],pTexCoords[3]
        };
        glVertexAttribPointer(texCoordAttribLocation, 2, GL_FLOAT, 0, 0,  pTexCoords2);
        
        glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
        framebuffer_ForSDKInput_Video->EndRenderFrameBuffer();

        
        int outPutTexId = 0;
        XJGARSDKRenderGLTexture( framebuffer_ForSDKInput_Video->GetAttachedTexture(),framebuffer_ForSDKInput_Video->GetFrameBufWidth(), framebuffer_ForSDKInput_Video->GetFrameBufHeight(), &outPutTexId);
        
        
        displayProgram->UseThisProgram();
        [self setDisplayFramebuffer];
        glClearColor(backgroundColorRed, backgroundColorGreen, backgroundColorBlue, backgroundColorAlpha);
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
        
        
        glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_2D,  outPutTexId);
        glUniform1i(colorMapUniformLocation, 0);
        
        
        float frameBufWidth  = 1.0;
        float frameBufHeight = 1.0;
        
        GLfloat displayVertices_NoRotation[8]={
            -frameBufWidth , -frameBufHeight,
            frameBufWidth , -frameBufHeight,
            -frameBufWidth ,  frameBufHeight,
            frameBufWidth ,  frameBufHeight
        };

        GLfloat noRotationTextureCoordinates[] = {
            0.0f, 0.0f,
            1.0f, 0.0f,
            0.0f, 1.0f,
            1.0f, 1.0f,
        };

        glVertexAttribPointer(positionAttribLocation, 2, GL_FLOAT, 0, 0, displayVertices_NoRotation);
        glVertexAttribPointer(texCoordAttribLocation, 2, GL_FLOAT, 0, 0, noRotationTextureCoordinates );
        
        glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);

        
        
        
//        int outPutTexId = 0;
//        XJGARSDKRenderGLTexture( inputFramebuffer->GetAttachedTexture(),inputFramebuffer->GetFrameBufWidth(), inputFramebuffer->GetFrameBufHeight(), &outPutTexId);
//        
//        displayProgram->UseThisProgram();
//        [self setDisplayFramebuffer];
//        glClearColor(backgroundColorRed, backgroundColorGreen, backgroundColorBlue, backgroundColorAlpha);
//        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
//        
//        
//        glActiveTexture(GL_TEXTURE0);
//        glBindTexture(GL_TEXTURE_2D,  outPutTexId);
//        glUniform1i(colorMapUniformLocation, 0);
//        
//        glVertexAttribPointer(positionAttribLocation, 2, GL_FLOAT, 0, 0, displayVertices);
//       glVertexAttribPointer(texCoordAttribLocation, 2, GL_FLOAT, 0, 0, [self textureCoordinatesForRotation:inputRotation] );
//        
//        glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
        
        [self presentFramebuffer];
    });
}


//设置帧缓存及纹理，如果帧缓存发生变化（如尺寸、旋转方向等），则更新显示的顶点对象
- (void)setInputFramebuffer:(GPUImgLuo::XJGARSDKFramebuffer*)newInputFramebuffer withRotation:(GPUImgLuo::RotationMode)rotation atIndex:(NSInteger)texIdx {
    GPUImgLuo::XJGARSDKFramebuffer* lastFramebuffer = inputFramebuffer;
    GPUImgLuo::RotationMode lastInputRotation = inputRotation;
    
    inputRotation = rotation;
    inputFramebuffer = newInputFramebuffer;
    
    if (lastFramebuffer != newInputFramebuffer && newInputFramebuffer &&
        ( !lastFramebuffer ||
          !(lastFramebuffer->GetFrameBufWidth() == newInputFramebuffer->GetFrameBufWidth() &&
            lastFramebuffer->GetFrameBufHeight() == newInputFramebuffer->GetFrameBufHeight() &&
            lastInputRotation == rotation)
        ))
    {
        [self updateDisplayVertices];
    }
}

//设置填充模式，并更新对应的顶点值
- (void)setFillMode:(GPUImagViewFillMode)newValue;
{
    if (_fillMode != newValue) {
        _fillMode = newValue;
        [self updateDisplayVertices];
    }
}


//设置相机旋转后的宽度与高度
- (void)setRotatedFrameBufWidth:(int)newValue;
{
    _rotatedFrameBufWidth = newValue;
}


//设置相机旋转后的宽度与高度
- (void)setRotatedFrameBufHeight:(int)newValue;
{
    _rotatedFrameBufHeight = newValue;
}



//更新显示的顶点对象
- (void)updateDisplayVertices;
{
    if (inputFramebuffer == 0) return;
    
    CGFloat scaledWidth = 1.0;
    CGFloat scaledHeight = 1.0;

    int rotatedFramebufferWidth = inputFramebuffer->GetFrameBufWidth();
    int rotatedFramebufferHeight = inputFramebuffer->GetFrameBufHeight();
    

    GPUImgLuo::RotationMode rotation = inputRotation;
    if (((rotation) == GPUImgLuo::RotateLeft || (rotation) == GPUImgLuo::RotateRight || (rotation) == GPUImgLuo::RotateRightFlipVertical || (rotation) == GPUImgLuo::RotateRightFlipHorizontal))//判断是否需要对输入帧对象进行旋转,
    {
        //翻转高宽比
        rotatedFramebufferWidth = inputFramebuffer->GetFrameBufHeight();
        rotatedFramebufferHeight = inputFramebuffer->GetFrameBufWidth();
    }
    //AVMakeRectWithAspectRatioInsideRect函数返回一个合适的矩形区域，该区域与输入的高宽比参数保持一致，同时也能填充指定的矩形区域
    CGRect insetRect = AVMakeRectWithAspectRatioInsideRect(CGSizeMake(rotatedFramebufferWidth, rotatedFramebufferHeight), self.bounds);
    
    //如果是保持高宽比，根据情况计算缩放比例，并计算
    if (_fillMode == GPUImagViewFillMode::PreserveAspectRatio) {
        scaledWidth = insetRect.size.width / self.bounds.size.width;
        scaledHeight = insetRect.size.height / self.bounds.size.height;
    } else if (_fillMode == GPUImagViewFillMode::PreserveAspectRatioAndFill) {
        scaledWidth = self.bounds.size.height / insetRect.size.height;
        scaledHeight = self.bounds.size.width / insetRect.size.width;
    }
    
    displayVertices[0] = -scaledWidth;
    displayVertices[1] = -scaledHeight;
    displayVertices[2] = scaledWidth;
    displayVertices[3] = -scaledHeight;
    displayVertices[4] = -scaledWidth;
    displayVertices[5] = scaledHeight;
    displayVertices[6] = scaledWidth;
    displayVertices[7] = scaledHeight;
}

//根据旋转模式，获取相应的纹理坐标数组
- (const GLfloat *)textureCoordinatesForRotation:(GPUImgLuo::RotationMode)rotationMode;
{
    static const GLfloat noRotationTextureCoordinates[] = {
        0.0f, 1.0f,
        1.0f, 1.0f,
        0.0f, 0.0f,
        1.0f, 0.0f,
    };
    
    static const GLfloat rotateRightTextureCoordinates[] = {
        1.0f, 1.0f,
        1.0f, 0.0f,
        0.0f, 1.0f,
        0.0f, 0.0f,
    };
    
    static const GLfloat rotateLeftTextureCoordinates[] = {
        0.0f, 0.0f,
        0.0f, 1.0f,
        1.0f, 0.0f,
        1.0f, 1.0f,
    };
    
    static const GLfloat verticalFlipTextureCoordinates[] = {
        0.0f, 0.0f,
        1.0f, 0.0f,
        0.0f, 1.0f,
        1.0f, 1.0f,
    };
    
    static const GLfloat horizontalFlipTextureCoordinates[] = {
        1.0f, 1.0f,
        0.0f, 1.0f,
        1.0f, 0.0f,
        0.0f, 0.0f,
    };
    
    static const GLfloat rotateRightVerticalFlipTextureCoordinates[] = {
        1.0f, 0.0f,
        1.0f, 1.0f,
        0.0f, 0.0f,
        0.0f, 1.0f,
    };
    
    static const GLfloat rotateRightHorizontalFlipTextureCoordinates[] = {
        0.0f, 1.0f,
        0.0f, 0.0f,
        1.0f, 1.0f,
        1.0f, 0.0f,
    };
    
    static const GLfloat rotate180TextureCoordinates[] = {
        1.0f, 0.0f,
        0.0f, 0.0f,
        1.0f, 1.0f,
        0.0f, 1.0f,
    };
    
    switch(inputRotation)
    {
        case GPUImgLuo::NoRotation: return noRotationTextureCoordinates;
        case GPUImgLuo::RotateLeft: return rotateLeftTextureCoordinates;
        case GPUImgLuo::RotateRight: return rotateRightTextureCoordinates;
        case GPUImgLuo::FlipVertical: return verticalFlipTextureCoordinates;
        case GPUImgLuo::FlipHorizontal: return horizontalFlipTextureCoordinates;
        case GPUImgLuo::RotateRightFlipVertical: return rotateRightVerticalFlipTextureCoordinates;
        case GPUImgLuo::RotateRightFlipHorizontal: return rotateRightHorizontalFlipTextureCoordinates;
        case GPUImgLuo::Rotate180: return rotate180TextureCoordinates;
    }
}

@end


