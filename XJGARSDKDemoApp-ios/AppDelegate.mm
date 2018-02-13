
#import "AppDelegate.h"
#import "MainViewController.h"
#include "XJGArSdk.h"
#include <string>

@interface AppDelegate ()

@end

//实现AppDelegate类对象
@implementation AppDelegate

//将模型文件从资源库复制到Documents目录，由于在沙盒里只有Documents目录是可读写的
-(NSString*) copyFile2Documents:(NSString*)fileName filetype:(NSString*) ftype
{
    NSFileManager*fileManager =[NSFileManager defaultManager];
    NSError*error;
    NSArray*paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString*documentsDirectory =[paths objectAtIndex:0];
    
    NSString*destPath1 =[documentsDirectory stringByAppendingPathComponent:fileName];
    NSString*destPath2 =[destPath1 stringByAppendingString:@"."];
    NSString*destPath  =[destPath2 stringByAppendingString:ftype];
    
    //  如果目标目录也就是(Documents)目录没有文件的时候，才会复制一份，否则不复制
    if(![fileManager fileExistsAtPath:destPath]){
        // 设置文件路径
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"resbundle"  ofType:@"bundle"];
        NSString *sourcePath1 = [bundlePath  stringByAppendingPathComponent:fileName];
        NSString *sourcePath2 = [sourcePath1 stringByAppendingString:@"."];
        NSString *sourcePath  = [sourcePath2 stringByAppendingString:ftype];

        NSLog(@"sourcePath：%@", sourcePath);
        NSLog(@"destPath：%@", destPath);
        
        [fileManager copyItemAtPath:sourcePath toPath:destPath error:&error];
    }
    return destPath;
}


//将模型文件从资源库复制到Documents下指定目录中，由于在沙盒里只有Documents目录是可读写的
-(NSString*) copyFile2DirOfDocument:(NSString*)dirName fileName:(NSString*)fileName fileType:(NSString*) ftype
{
    NSFileManager*fileManager =[NSFileManager defaultManager];
    NSError*error;
    
    NSString*destPath1 =[dirName stringByAppendingPathComponent:fileName];
    NSString*destPath2 =[destPath1 stringByAppendingString:@"."];
    NSString*destPath  =[destPath2 stringByAppendingString:ftype];

    //  如果目标目录也就是(Documents)目录没有文件的时候，才会复制一份，否则不复制
    if(![fileManager fileExistsAtPath:destPath]){
        // 设置文件路径
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"resbundle"  ofType:@"bundle"];
        NSString *sourcePath1 = [bundlePath  stringByAppendingPathComponent:fileName];
        NSString *sourcePath2 = [sourcePath1 stringByAppendingString:@"."];
        NSString *sourcePath  = [sourcePath2 stringByAppendingString:ftype];
        
        NSLog(@"sourcePath：%@", sourcePath);
        NSLog(@"destPath：%@", destPath);
        
        [fileManager copyItemAtPath:sourcePath toPath:destPath error:&error];
    }
    return destPath;
}


//Tells the delegate that the launch process is almost done and the app is almost ready to run.
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //分配UiWindow实例对象，并用主屏幕边界初始化
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //背景色设置为白色背景
    self.window.backgroundColor = [UIColor whiteColor];
    //The UINavigationController class implements a specialized view controller that manages the navigation of hierarchical content. This navigation interface makes it possible to present your data efficiently and makes it easier for the user to navigate that content. You generally use this class as-is but you may also subclass to customize the class behavior.
    //初始化一个视图控制器，并制定给uiwindow对象
    UINavigationController* rootNavigationController = [[UINavigationController alloc] init];
    [self.window setRootViewController:rootNavigationController];
    //Shows the window and makes it the key window.
    [self.window makeKeyAndVisible];
    
    //将自定义的菜单视图控制器对象初始化，并指定给主视图控制器
    [rootNavigationController pushViewController:[[MainViewController alloc] init] animated:NO];
    
    
    
    //复制bundle中的人脸检测与对齐模型文件
    [self copyFile2Documents:@"com.xjg.facedet.model" filetype:@"bin"];
    [self copyFile2Documents:@"com.xjg.landmark.model.100-50-10-5percent.L1000.0-F5-12-4-1.0-2-2-2iter3" filetype:@"bin"];
    [self copyFile2Documents:@"ResForShader" filetype:@"zip"];

    //创建ResForShader目录，复制bundle
    //获得沙盒中Documents文件夹路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    // 在Documents文件夹中创建文件夹
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *resDirectory = [documentsPath stringByAppendingPathComponent:@"ResForShader"];
    [fileManager createDirectoryAtPath:resDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    //复制图片资源文件
    //[self copyFile2DirOfDocument:resDirectory fileName:@"ResForShader" fileType:@"zip"];
    NSString  * shaderResZipDirName   = [documentsPath stringByAppendingPathComponent:@"ResForShader"];
    NSString  * shaderResZipFileName  = [shaderResZipDirName stringByAppendingString:@".zip"];
    const char* shaderResDName        = [shaderResZipDirName UTF8String];
    const char* shaderResFName        = [shaderResZipFileName UTF8String];
    XJGARSDKUnzipFileToTheFolder(shaderResFName,shaderResDName);
    
    //创建贴纸目录，并拷贝贴纸，然后解压
    NSString *stickerDir = [documentsPath stringByAppendingPathComponent:@"StickerPapers"];
    [fileManager createDirectoryAtPath:stickerDir withIntermediateDirectories:YES attributes:nil error:nil];
    //复制贴纸资源文件
    [self copyFile2DirOfDocument:stickerDir fileName:@"angel" fileType:@"zip"];
    [self copyFile2DirOfDocument:stickerDir fileName:@"caishen" fileType:@"zip"];
    [self copyFile2DirOfDocument:stickerDir fileName:@"cangou" fileType:@"zip"];
    //[self copyFile2DirOfDocument:stickerDir fileName:@"daxiongmao" fileType:@"zip"];
    [self copyFile2DirOfDocument:stickerDir fileName:@"diving" fileType:@"zip"];
    [self copyFile2DirOfDocument:stickerDir fileName:@"stpaper900224" fileType:@"zip"];
    
    //解压缩贴纸资源
    NSString  * stickerpaperDirName  = [stickerDir stringByAppendingPathComponent:@"angel"];
    NSString  * stickerpaperPathName = [stickerpaperDirName stringByAppendingString:@".zip"];
    const char* stickerpaperDName    = [stickerpaperDirName UTF8String];
    const char* stickerpaperPName    = [stickerpaperPathName UTF8String];
    XJGARSDKUnzipFileToTheFolder(stickerpaperPName,stickerpaperDName);
    
    stickerpaperDirName  = [stickerDir stringByAppendingPathComponent:@"caishen"];
    stickerpaperPathName = [stickerpaperDirName stringByAppendingString:@".zip"];
    stickerpaperDName    = [stickerpaperDirName UTF8String];
    stickerpaperPName    = [stickerpaperPathName UTF8String];
    XJGARSDKUnzipFileToTheFolder(stickerpaperPName,stickerpaperDName);
    
    
    stickerpaperDirName  = [stickerDir stringByAppendingPathComponent:@"cangou"];
    stickerpaperPathName = [stickerpaperDirName stringByAppendingString:@".zip"];
    stickerpaperDName    = [stickerpaperDirName UTF8String];
    stickerpaperPName    = [stickerpaperPathName UTF8String];
    XJGARSDKUnzipFileToTheFolder(stickerpaperPName,stickerpaperDName);
    
//    stickerpaperDirName  = [stickerDir stringByAppendingPathComponent:@"daxiongmao"];
//    stickerpaperPathName = [stickerpaperDirName stringByAppendingString:@".zip"];
//    stickerpaperDName    = [stickerpaperDirName UTF8String];
//    stickerpaperPName    = [stickerpaperPathName UTF8String];
//    XJGARSDKUnzipFileToTheFolder(stickerpaperPName,stickerpaperDName);
    
    stickerpaperDirName  = [stickerDir stringByAppendingPathComponent:@"diving"];
    stickerpaperPathName = [stickerpaperDirName stringByAppendingString:@".zip"];
    stickerpaperDName    = [stickerpaperDirName UTF8String];
    stickerpaperPName    = [stickerpaperPathName UTF8String];
    XJGARSDKUnzipFileToTheFolder(stickerpaperPName,stickerpaperDName);
    
    stickerpaperDirName  = [stickerDir stringByAppendingPathComponent:@"stpaper900224"];
    stickerpaperPathName = [stickerpaperDirName stringByAppendingString:@".zip"];
    stickerpaperDName    = [stickerpaperDirName UTF8String];
    stickerpaperPName    = [stickerpaperPathName UTF8String];
    XJGARSDKUnzipFileToTheFolder(stickerpaperPName,stickerpaperDName);


    

    std::string licenseText = "hMPthC0oBIbtMp515TWb9jZvrLAKWIMvA4Dhf03n51QvnJr7jZowVe86d0WwU0NK9QGRFaXQn628fRu941qyr3FtsI5R7Y6v1XEpL6YvQNWQCkFEt1SAb0hyawimOYf1tfG2lIaNE63c5e+OxXssOVUWvw8tOr2glVwWVzh79NmZMahrnS8l69SoeoXLMKCYlvAt/qJFFk4+6Aq3QvOv3o72fq5p90yty+YWg7o0HirZpMSP9P5/DHYPFqR/ud7twTJ+Yo2+ZzYvodqRQbGG0HseZn8Xpt7fZdFuZbc2HGRMVk56vNDMRlcGZZXAjENk7m2UMhi1ohhuSf4WmIgXCZFiJXvYFByaY625gXKtEI7+b7t81nWQYHP9BEbzURwL";
    const char* rootDir = [documentsPath UTF8String];
    XJGARSDKSetRootDirectory(rootDir);//first set model data root directory. then initialize the sdk
    XJGARSDKInitialization(licenseText.c_str(), "DoctorLuoInvitedUser:teacherluo", "LuoInvitedCompany:www.xiaojigou.cn");
    
//    Foo testFramework;
//    testFramework.PrintFoo();
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
