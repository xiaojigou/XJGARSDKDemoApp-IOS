# XJGARSDKDemoApp-IOS
一、准备工作
-------------------------------
1.安装虚拟机；<br>
2.安装Mac操作系统；<br>
3.安装Xcode；<br>
4.在Mac OSX上安装配置CMake，版本至少是3.7；<br>
![image] https://github.com/TeacherLuo/XJGARSDKDemoApp-IOS/ImageCache/1.jpg <br>
![image] https://github.com/TeacherLuo/XJGARSDKDemoApp-IOS/ImageCache/2.jpg <br>

本说明使用的VMWare Station 12，操作系统为macOS High Sierra 版本10.13.3，Xcode版本9.2。如果有MAC电脑可以省去步骤1和2。<br>

二、生成工程文件
------------------

1.将名为XJGARSDK-ios-cmake的文件夹导入到虚拟机，放在“桌面”；<br>
2.修改根目录下CMakeList.txt文件：<br>
* 双击打开CMakeList.txt文件，如下图：<br>
* 修改该文件中的1-10内容（很重要），如下图：<br>

>>>第4行，修改TEAM_ID为自己的ID号，可在Apple的开发者网站注册，获得TEAM_ID号，在XCode的工具栏里点击perference，在弹出的窗口中，点击左下角+号，将Apple ID加入，在右侧可以看到Team，随后关闭窗口（该步骤获取了Team名，在后面XCode中会用到）；<br>

>>>其余几行的修改，只需要修改为相应的自己的工程中所对应的名字；<br>
* 修改完毕，点左上角红色圆点关闭。<br>

3.运行脚本
------------------------
* 点击Launchpad->其他->终端，打开命令行窗口，如下图：<br>
* 在命令行中输入 cmake --version，你会发现系统并不认识cmake这个命令。在命令行中输入PATH="/Applications/CMake.app/Contents/bin":"$PATH"，如下图所示。此后，再执行跟cmake有关的命令，系统就可以正确识别它了。<br>
* 指定到CMakeList.txt文件所在的路径下，本例CMakeList.txt在Desktop\XJGARSDK-ios-cmake下，因此在命令行中定位该路径，如下图操作：（根据你自己的文件路径，用cd命令来指定路径）<br>
* 点击finder->桌面，选中本例文件夹，将该文件夹下generate-project.sh直接拖入左侧的命令行窗口：<br>
* 按下“Enter”键，等待该脚本文件生成Xcode工程文件，生成成功后，在XJGARSDK-ios-cmake文件夹下会出现一个Xcode文件，双击可以看到一个.xcodeproj文件，这就是Xcode的工程文件。<br>

三、运行工程
-----------------

1.在XCode中运行上面生成的工程文件，在Targets中选中目标文件，设置General，在下图框中，勾选Automatically manage signing，选中Team，下拉框会自动出现前面操作中注册过的Team名，选中后Status会自动更新；<br>

如果发现Status多次更新失败，可以打开XCode的Perference查看，是否需要重新登录，因为网络的关系，有时会掉线，等网络稳定，Status会自动更改。<br>

2.选择运行设备，如下图，在你需要运行的程序上点击后面的三角，用于选择程序需要在哪种设备上运行，如果在真机上做测试，可以将手机接入电脑，在虚拟机中做相关操作(如何将手机接入虚拟机可以自行百度)，将手机接入虚拟机，接入成功后在Device中会显示该手机，选中后，点XCode工具栏的 ，即可在手机上运行程序。<br>

3. Xcode8.0有很多坑，填完一个又来一个，接入手机运行后，点击手机上的两个功能“Render Image Test”和“Render Camera Test”可能会看到“Thread 1: signal SIGABRT”这样的错误，很多原因都会导致这个错误，请注意看错误提示，我们的代码中因为涉及相册和相机，一般会给出如下的错误提示：<br>

This app has crashed because it attempted to access privacy-sensitive data without a usage description. The app's Info.plist must contain an NSCameraUsageDescription key with a string value explaining to the user how the app uses this data.<br>

解决方法：<br>

在上图的Get Info string的下拉框里，选中Privacy-Photo Library Usage Description，在后面的string字段里输入NSPhotoLibraryUsageDescription，这个字段需要自己手动输入，表示使用相册；选中Privacy-Camera Usage Description，在后面的string字段里输入NSCameraUsageDescription，同样需要自己手动输入，表示使用相机。<br>
