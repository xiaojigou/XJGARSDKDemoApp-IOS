//
//  Created by luojianxin on 9/12/17.
//  Copyright (c) 2017-2018 luojianxin. All rights reserved.
//  Copyright (c) 2017-2018 xiaojigou network tech. ltd.. All rights reserved.
//  Copyright (c) 2018 wenyue smart tech. ltd.. All rights reserved.
//
#pragma once

#if defined(_WIN32)||defined(_WIN64)
	#ifdef XJGARSDK_EXPORTS
	#define XJGARSDK_API  __declspec(dllexport)
	#else
	#define XJGARSDK_API __declspec(dllimport)
	#endif
#elif defined(__APPLE__)
#include "TargetConditionals.h"
#define EXPORT __attribute__((visibility("default")))
    #if TARGET_IPHONE_SIMULATOR
         // iOS Simulator
    #define XJGARSDK_API EXPORT
    #elif TARGET_OS_IPHONE
    // iOS device
    #define XJGARSDK_API EXPORT
    #elif TARGET_OS_MAC
    // Other kinds of Mac OS
    #define XJGARSDK_API EXPORT
    #else
    #   error "Unknown Apple platform"
    #endif
#elif defined(__ANDROID__) || defined(ANDROID)
	// android
	#define XJGARSDK_API extern
#elif defined(__linux__)
	// linux
	#define XJGARSDK_API extern
#elif defined(__unix__) // all unices not caught above
    // Unix
    #define XJGARSDK_API extern
#elif defined(_POSIX_VERSION)
    // POSIX
    #define XJGARSDK_API extern
#else
#   error "Unknown compiler"
#endif


///set root driectory of stick papers, face detection model, face alignment model, and other resources
///@rootDirectory:	the root directory of SDK data resources
XJGARSDK_API bool XJGARSDKSetRootDirectory(const char*  rootDirectory);

//XJGARSDK_API bool XJGARSDKInitialization();
XJGARSDK_API bool XJGARSDKInitialization(const char* licenseText, 
	const char* userName, const char* companyName);
XJGARSDK_API bool XJGARSDKSetBigEyeParam(			int eyeParam			);
XJGARSDK_API bool XJGARSDKSetThinChinParam(			int chinParam			);
XJGARSDK_API bool XJGARSDKSetRedFaceParam(			int redFaceParam		);
XJGARSDK_API bool XJGARSDKSetWhiteSkinParam(		int whiteSkinParam		);
XJGARSDK_API bool XJGARSDKSetSkinSmoothParam(		int skinSmoothParam		);
XJGARSDK_API bool XJGARSDKSetShowStickerPapers(		bool bShowStickPaper	);
XJGARSDK_API bool XJGARSDKSetShowPerformanceStatic(	bool bPerformanceStatic	);
XJGARSDK_API bool XJGARSDKChangeStickpaper(	const char*  stickPaperName		);
XJGARSDK_API bool XJGARSDKChangeFilter(	const char*  filterTypeName			);
XJGARSDK_API bool XJGARSDKCleanUP();




///input 3 channels RGB image , render to get result
///@width:	width of input image
///@height: height of input image
///@imageBufOut:	result image buffer
XJGARSDK_API int XJGARSDKRenderImage(const unsigned char* image, int width,
	int height, unsigned char* imageBufOut);

///input 3 channels RGB image , render result to opengl back buffer
///@width:	width of input image
///@height: height of input image
XJGARSDK_API int XJGARSDKRenderImage(const unsigned char* image, int width,
	int height);

///input 3 channels RGB image , render to get result opengl texture name
///@width:	width of input image
///@height: height of input image
///@outputTexId:	result opengl texture name
XJGARSDK_API int XJGARSDKRenderImage(const unsigned char* image, int width,
	int height, int* pOutputTexId);



///input opengl texture , render to get result opengl texture 
///@inputTexId:input opengl texture
///@width:	width of input texture
///@height: height of input texture
///@outputTexId:	result opengl texture name
XJGARSDK_API int XJGARSDKRenderGLTexture(int inputTexId, int width, 
	int height, int* pOutputTexId);
///input opengl texture , render to opengl back buffer
///@inputTexId:input opengl texture
///@width:	width of input texture
///@height: height of input texture
XJGARSDK_API int XJGARSDKRenderGLTexture(int inputTexId, int width, int height);



// to be done...
//XJGARSDK_API bool XJGARSDKSetShowLandMarks(bool bShowLandMarks);

///if user dont't have opengl environment, call this to set up a virtual opengl environment
///@width:	width of input image
///@height: height of input image
///@return  true: success, false: fail
XJGARSDK_API bool XJGARSDKInitOpenglEnvironment(int width,	int height);
///destroy the opengl environment,
XJGARSDK_API bool XJGARSDKDestroyOpenglEnvironment();
///release all the opengl resources,
XJGARSDK_API bool XJGARSDKReleaseAllOpenglResources();


///set different optimization mode for video or image
///@mode:	optimization mode, 0: video £¨default), 1: image, 
///			2: video, using asynchronized face detection thread
XJGARSDK_API bool XJGARSDKSetOptimizationMode(int mode);

////maximum face detection number is 100, the output face rect array size is float[400]
//#define MAX_FACE_DETECTION_ARRAY_SIZE 400
//maximum face detection number is 100, the output landmark array size is float[13600]
#define MAX_FACE_DETECTION_ARRAY_SIZE 13600
///after image rendered, face information can be gotten via this funciton
///@faceRects, the face rects list, format is (x1,y1,width1,height1), (x2,y2,width2,height2)......
///@faceLandmarks, the face 68 points landmarks list, format is:
///		person1 : (P1.x1,P1.y1 , P1.x1,P1.y1 , ... P1.x68,P1.y68), 
///		person2 : (P2.x1,P2.y1 , P2.x1,P2.y1 , .... P2.x68,P2.y68) ......
///@return  the total number of detected faces 
//XJGARSDK_API int XJGARSDKGetFaceRectAndLandmarks(float faceRects[], 
//	float faceLandmarks[]);
XJGARSDK_API int XJGARSDKGetFaceLandmarks(float* faceLandmarks);


///after render, you may want small or large reults, 
///call this function to get target width and height image and texname
///@imageBufOut,  target output rgbimage, , if null not output image
///@pOutputTexId, target output texture id, if null not output texture
/// at least, make sure one of imageBufOut and pOutputTexId is not null
///@pOutputTexId, target output 68 points face landmarks list, format is:
///		person1 : (P1.x1,P1.y1 , P1.x1,P1.y1 , ... P1.x68,P1.y68), 
///		person2 : (P2.x1,P2.y1 , P2.x1,P2.y1 , .... P2.x68,P2.y68) ......
///@width,			target output width, 
///@height,			target output height, 
///@iImgCropMode,	image crop mode,  0: strech to target, 
///		1: center align and crop border, 
///		2: center align and scale to match target, then crop
///@pXscale,			landmark coordinate scale factor form original inpute image to target image
///@pYScale,			landmark coordinate scale factor form original inpute image to target image
///@return facenumber
XJGARSDK_API int XJGARSDKGetTargetResultImgAndLandMarks(unsigned char* imageBufOut,
	int* pOutputTexId, float* faceLandmarks, int targetWidth, int targetHeight, int iImgCropMode,
	float *pXscale, float * pYScale);



///Given a inputeTexId, draw to target opengl viewport
///@inputTexId: the inpute text id
///@startx: start x coordinates of view
///@startY: start y coordinates of view
///@viewportWidth: width of view
///@viewportWidth: height of view
XJGARSDK_API void XJGARSDKDrawAFullViewTexture(int inputTexId, int startX, int startY,
	int viewportWidth, int viewportHeight);








///unzip a zip file to the destionation folder
///@zipFilePathName: the path name ot zip file to be unzipped
///@unzipDestFolder: destination folder to save the unzipped files
XJGARSDK_API void XJGARSDKUnzipFileToTheFolder(const char* zipFilePathName, const char * unzipDestFolder);





