
#ifndef _XJGARSDK_MACRO_DEFINITIONS_
#define _XJGARSDK_MACRO_DEFINITIONS_


#define ENABLE_GL_CHECK false

#if ENABLE_GL_CHECK
    #define CHECK_GL(glFunc) \
        glFunc; \
	{ \
		int e = glGetError(); \
		if (e != 0) \
		{ \
			std::string errorString = ""; \
			switch(e) \
			{ \
			case GL_INVALID_ENUM:       errorString = "GL_INVALID_ENUM";        break; \
			case GL_INVALID_VALUE:      errorString = "GL_INVALID_VALUE";       break; \
			case GL_INVALID_OPERATION:  errorString = "GL_INVALID_OPERATION";   break; \
			case GL_OUT_OF_MEMORY:      errorString = "GL_OUT_OF_MEMORY";       break; \
			default:                                                            break; \
			} \
			Log("ERROR", "GL ERROR 0x%04X %s in %s at line %i\n", e, errorString.c_str(), __PRETTY_FUNCTION__, __LINE__); \
		} \
	}
#else
    #define CHECK_GL(glFunc)  glFunc;
#endif

namespace GPUImgLuo {
     //纹理的旋转模式
     enum RotationMode {
         NoRotation = 0,                 //无旋转
         RotateLeft,                     //向左旋转
         RotateRight,                    //向右旋转
         FlipVertical,                   //垂直翻转
         FlipHorizontal,                 //水平翻转
         RotateRightFlipVertical,        //向右旋转垂直翻转
         RotateRightFlipHorizontal,      //向右旋转水平翻转
         Rotate180                       //旋转180度
     };
}

#endif
