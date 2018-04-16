# XJGARSDKDemoApp-IOS
API接口
====================
注意：SDK中各个函数需要在单一的线程中调用。<br>
1.	初始化<br>

>####初始化方法：<br>
XJGARSDK_API bool XJGARSDKInitialization(const char* licenseText, <br>
	const char* userName, const char* companyName);<br>
* 	第一个参数为key<br>
* 	第二个参数为 key对应的用户名<br>
* 	第三个参数为 key对应的公司名<br>
该参数须申请<br>

>####销毁方法：<br>
>XJGARSDKCleanUP();<br>

2.	使用人脸整形<br>

>####大眼：<br>
XJGARSDK_API bool XJGARSDKSetBigEyeParam(int eyeParam);<br>
eyeParam参数为0-100，数值越大眼睛越大<br>

>####瘦脸：<br>
XJGARSDK_API bool XJGARSDKSetThinChinParam(int chinParam); <br>
chinParam参数为0-100，数值越大脸部下吧越瘦<br>

>####红润：<br>
XJGARSDK_API bool XJGARSDKSetRedFaceParam(int redFaceParam); 
redFaceParam参数为0-100，数值越大脸部皮肤越红润

>####美白：<br>
XJGARSDK_API bool XJGARSDKSetWhiteSkinParam(int whiteSkinParam); 
whiteSkinParam参数为0-100，数值越大脸部皮肤越白

>####磨皮：<br>
XJGARSDK_API bool XJGARSDKSetSkinSmoothParam(int skinSmoothParam); <br>
skinSmoothParam参数为0-100， 数值越大越皮肤越光滑<br>

3.	使用人脸滤镜<br>

SDK启动时默认不使用滤镜<br>
>####切换滤镜：<br>
XJGARSDK_API bool XJGARSDKChangeFilter(const char*  filterTypeName);<br>
filterTypeName参数为滤镜名字，目前可选的滤镜有6种，分别是冰冷,健康,祖母绿,怀旧, 蜡笔, 常青，填入“无”不使用滤镜;<br>
在某些中文输入有问题的状况下可以使用英文参数输入，6种滤镜分别为："filter_cool", "filter_Healthy","filter_emerald","filter_nostalgia","filter_crayon", "filter_evergreen"。填入"filter_none",不使用滤镜。<br>

4.	使用人脸道具<br>

>####显示贴纸：<br>
XJGARSDK_API bool XJGARSDKSetShowStickerPapers(bool bShowStickPaper);<br>
bShowStickPaper参数 为true时，显示贴纸<br>

>####切换贴纸：<br>
XJGARSDK_API bool XJGARSDKChangeStickpaper(const char*  stickPaperName);<br>
stickPaperName参数为贴纸名称，目前可选的贴纸见StickerPapers子文件夹，每个文件夹的名称均是贴纸名称<br>

5.	图片视频流处理<br>

//初始化OpenGL 环境<br>
XJGARSDK_API bool XJGARSDKInitOpenglEnvironment(int width,	int height);<br>
///if user dont't have opengl environment, call this to set up a virtual opengl environment<br>
///@width:	width of input image<br>
///@height: height of input image<br>
///@return  true: success, false: fail<br>

///销毁OpenGL环境<br>
XJGARSDK_API bool XJGARSDKDestroyOpenglEnvironment();<br>
///释放OpenGL资源<br>
XJGARSDK_API bool XJGARSDKReleaseAllOpenglResources();<br>

//设置SDK工作模式，0为视频，1为图片<br>
XJGARSDK_API bool XJGARSDKSetOptimizationMode(int mode);<br>
///set different optimization mode for video or image<br>
///@mode:	optimization mode, 0: video, 1: image<br>

XJGARSDK_API int XJGARSDKRenderImage(const unsigned char* image, int width,
	int height, unsigned char* imageBufOut);<br>
前三个是入参，其中image参数是图像RGB数据，width 图像宽带，heifht图像高度<br>
imageBufOut为出参，即经过美颜，滤镜，道具处理后的图像，可用OpenCV的imshow函数直接播放。或者也可以采用doublebuffer方案自行写播放函数<br>

XJGARSDK_API int XJGARSDKRenderImage(const unsigned char* image, int width,
	int height);<br>
其中image参数是图像RGB数据，width 图像宽带，heifht图像高度<br>
调用该函数后，将在Opengl屏幕缓存中存储最后渲染的结果。<br>

XJGARSDK_API int XJGARSDKRenderImage(const unsigned char* image, int width,
	int height, int* pOutputTexId);<br>
///input 3 channels RGB image, render to get result opengl texture name<br>
///@width:	width of input image<br>
///@height: height of input image<br>
///@outputTexId:	result opengl texture name<br>

XJGARSDK_API int XJGARSDKRenderGLTexture(int inputTexId, int width, 
	int height, int* pOutputTexId);<br>
///input opengl texture , render to get result opengl texture <br>
///@inputTexId:input opengl texture<br>
///@width:	width of input texture<br>
///@height: height of input texture<br>
///@outputTexId:	result opengl texture name<br>

XJGARSDK_API int XJGARSDKRenderGLTexture(int inputTexId, int width, int height);<br>
///input opengl texture , render to opengl back buffer<br>
///@inputTexId:input opengl texture<br>
///@width:	width of input texture<br>
///@height: height of input texture<br>

XJGARSDK_API void XJGARSDKDrawAFullViewTexture(int inputTexId, int startX, int startY, int viewportWidth, int viewportHeight);<br>
///Given a inputeTexId, draw to target opengl viewport<br>
///@inputTexId: the inpute text id<br>
///@startx: start x coordinates of view<br>
///@startY: start y coordinates of view<br>
///@viewportWidth: width of view<br>
///@viewportWidth: height of view<br>

XJGARSDK_API int XJGARSDKGetTargetResultImgAndLandMarks(unsigned char* imageBufOut, int* pOutputTexId, float* faceLandmarks, int targetWidth, int targetHeight, int iImgCropMode, float *pXscale = 0, float * pYScale = 0);<br>
//在每一帧渲染结束后，可以使用该函数获取结果图像及脸部特征点，<br>
imageBufOut为结果图像存储的RGB缓存，如果为空，则不输出rgb图像。<br>
pOutputTexId为结果图像存储的纹理Id，如果为空，则不输出纹理对象。<br>
以上两个参数至少有一个不能为空。<br>
faceLandmarks为结果脸部特征点缓存的数组缓存。格式为：第一个人的脸部特征点列表，第二个人脸部特征点列表…<br>
targetWidth:指定输出rgb图像，或纹理的宽度<br>
targetHeight：指定输出rgb图像，或纹理的高度<br>
iImgCropMode：目标图像与相机输入的目标图像尺寸不一致时，指定输入目标图像的裁剪方式，0：拉伸到目标位置，1:中心点对齐并裁剪边界（不缩放），2：居中对齐并缩放以尽可能匹配目标，然后裁剪<br>
///@pXscale, 捕获的结果图像坐标与原始图像坐标的缩放参数<br>
///@pYScale, 捕获的结果图像坐标与原始图像坐标的缩放参数<br>
返回值：检测到的人脸个数<br>


一、准备工作
-------------------------------
1.安装虚拟机；<br>
2.安装Mac操作系统；<br>
3.安装Xcode；<br>
4.在Mac OSX上安装配置CMake，版本至少是3.7；<br>
![image](https://github.com/TeacherLuo/XJGARSDKDemoApp-IOS/raw/master/ImageCache/1.jpg)<br>
![image](https://github.com/TeacherLuo/XJGARSDKDemoApp-IOS/raw/master/ImageCache/2.jpg)<br>

本说明使用的VMWare Station 12，操作系统为macOS High Sierra 版本10.13.3，Xcode版本9.2。如果有MAC电脑可以省去步骤1和2。<br>

二、生成工程文件
------------------

1.将名为XJGARSDK-ios-cmake的文件夹导入到虚拟机，放在“桌面”；<br>
2.修改根目录下CMakeList.txt文件：<br>
* 双击打开CMakeList.txt文件，如下图：<br>
![image](https://github.com/TeacherLuo/XJGARSDKDemoApp-IOS/raw/master/ImageCache/3.jpg)<br>
* 修改该文件中的1-10内容（很重要），如下图：<br>
![image](https://github.com/TeacherLuo/XJGARSDKDemoApp-IOS/raw/master/ImageCache/4.jpg)<br>
>>>第4行，修改TEAM_ID为自己的ID号，可在Apple的开发者网站注册，获得TEAM_ID号，在XCode的工具栏里点击perference，在弹出的窗口中，点击左下角+号，将Apple ID加入，在右侧可以看到Team，随后关闭窗口（该步骤获取了Team名，在后面XCode中会用到）；<br>
![image](https://github.com/TeacherLuo/XJGARSDKDemoApp-IOS/raw/master/ImageCache/5.jpg)<br>
![image](https://github.com/TeacherLuo/XJGARSDKDemoApp-IOS/raw/master/ImageCache/6.jpg)<br>
>>>其余几行的修改，只需要修改为相应的自己的工程中所对应的名字；<br>
* 修改完毕，点左上角红色圆点关闭。<br>

3.运行脚本
------------------------
* 点击Launchpad->其他->终端，打开命令行窗口，如下图：<br>
![image](https://github.com/TeacherLuo/XJGARSDKDemoApp-IOS/raw/master/ImageCache/7.jpg)<br>
* 在命令行中输入 cmake --version，你会发现系统并不认识cmake这个命令。在命令行中输入PATH="/Applications/CMake.app/Contents/bin":"$PATH"，如下图所示。此后，再执行跟cmake有关的命令，系统就可以正确识别它了。<br>
![image](https://github.com/TeacherLuo/XJGARSDKDemoApp-IOS/raw/master/ImageCache/8.jpg)<br>
* 指定到CMakeList.txt文件所在的路径下，本例CMakeList.txt在Desktop\XJGARSDK-ios-cmake下，因此在命令行中定位该路径，如下图操作：（根据你自己的文件路径，用cd命令来指定路径）<br>
![image](https://github.com/TeacherLuo/XJGARSDKDemoApp-IOS/raw/master/ImageCache/9.jpg)<br>
* 点击finder->桌面，选中本例文件夹，将该文件夹下generate-project.sh直接拖入左侧的命令行窗口：<br>
![image](https://github.com/TeacherLuo/XJGARSDKDemoApp-IOS/raw/master/ImageCache/10.jpg)<br>
* 按下“Enter”键，等待该脚本文件生成Xcode工程文件，生成成功后，在XJGARSDK-ios-cmake文件夹下会出现一个Xcode文件，双击可以看到一个.xcodeproj文件，这就是Xcode的工程文件。<br>
![image](https://github.com/TeacherLuo/XJGARSDKDemoApp-IOS/raw/master/ImageCache/11.jpg)<br>

三、运行工程
-----------------

1.在XCode中运行上面生成的工程文件，在Targets中选中目标文件，设置General，在下图框中，勾选Automatically manage signing，选中Team，下拉框会自动出现前面操作中注册过的Team名，选中后Status会自动更新；<br>
![image](https://github.com/TeacherLuo/XJGARSDKDemoApp-IOS/raw/master/ImageCache/12.jpg)<br>
![image](https://github.com/TeacherLuo/XJGARSDKDemoApp-IOS/raw/master/ImageCache/13.jpg)<br>

如果发现Status多次更新失败，可以打开XCode的Perference查看，是否需要重新登录，因为网络的关系，有时会掉线，等网络稳定，Status会自动更改。<br>
![image](https://github.com/TeacherLuo/XJGARSDKDemoApp-IOS/raw/master/ImageCache/14.jpg)<br>

2.选择运行设备，如下图，在你需要运行的程序上点击后面的三角，用于选择程序需要在哪种设备上运行，如果在真机上做测试，可以将手机接入电脑，在虚拟机中做相关操作(如何将手机接入虚拟机可以自行百度)，将手机接入虚拟机，接入成功后在Device中会显示该手机，选中后，点XCode工具栏的 ，即可在手机上运行程序。<br>
![image](https://github.com/TeacherLuo/XJGARSDKDemoApp-IOS/raw/master/ImageCache/15.jpg)<br>

3. Xcode8.0有很多坑，填完一个又来一个，接入手机运行后，点击手机上的两个功能“Render Image Test”和“Render Camera Test”可能会看到“Thread 1: signal SIGABRT”这样的错误，很多原因都会导致这个错误，请注意看错误提示，我们的代码中因为涉及相册和相机，一般会给出如下的错误提示：<br>

`This app has crashed because it attempted to access privacy-sensitive data without a usage description. The app's Info.plist must contain an NSCameraUsageDescription key with a string value explaining to the user how the app uses this data.`<br>

`解决方法：`<br>
![image](https://github.com/TeacherLuo/XJGARSDKDemoApp-IOS/raw/master/ImageCache/16.jpg)<br>
在上图的Get Info string的下拉框里，选中Privacy-Photo Library Usage Description，在后面的string字段里输入NSPhotoLibraryUsageDescription，这个字段需要自己手动输入，表示使用相册；选中Privacy-Camera Usage Description，在后面的string字段里输入NSCameraUsageDescription，同样需要自己手动输入，表示使用相机。<br>
