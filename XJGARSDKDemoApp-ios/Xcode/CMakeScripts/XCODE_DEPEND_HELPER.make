# DO NOT EDIT
# This makefile makes sure all linkable targets are
# up-to-date with anything they link to
default:
	echo "Do not invoke directly"

# Rules to remove targets that are older than anything to which they
# link.  This forces Xcode to relink the targets from scratch.  It
# does not seem to check these dependencies itself.
PostBuild.XJGARSDKDemoApp.Debug:
/Users/jianxinluo/Desktop/Test/XJGARSDKDemoApp-ios/Xcode/Debug${EFFECTIVE_PLATFORM_NAME}/XJGARSDKDemoApp.app/XJGARSDKDemoApp:\
	/Users/jianxinluo/Desktop/Test/XJGARSDKDemoApp-ios/Xcode/cppframework/./${CONFIGURATION}${EFFECTIVE_PLATFORM_NAME}/TestFramework.framework/TestFramework
	/bin/rm -f /Users/jianxinluo/Desktop/Test/XJGARSDKDemoApp-ios/Xcode/Debug${EFFECTIVE_PLATFORM_NAME}/XJGARSDKDemoApp.app/XJGARSDKDemoApp
	/bin/rm -f /Users/jianxinluo/Desktop/Test/XJGARSDKDemoApp-ios/Xcode/XJGARSDKDemoApp.build/Debug/XJGARSDKDemoApp.build/Objects-normal/armv7/XJGARSDKDemoApp
	/bin/rm -f /Users/jianxinluo/Desktop/Test/XJGARSDKDemoApp-ios/Xcode/XJGARSDKDemoApp.build/Debug/XJGARSDKDemoApp.build/Objects-normal/armv7s/XJGARSDKDemoApp
	/bin/rm -f /Users/jianxinluo/Desktop/Test/XJGARSDKDemoApp-ios/Xcode/XJGARSDKDemoApp.build/Debug/XJGARSDKDemoApp.build/Objects-normal/arm64/XJGARSDKDemoApp


PostBuild.TestFramework.Debug:
/Users/jianxinluo/Desktop/Test/XJGARSDKDemoApp-ios/Xcode/cppframework/Debug${EFFECTIVE_PLATFORM_NAME}/TestFramework.framework/TestFramework:
	/bin/rm -f /Users/jianxinluo/Desktop/Test/XJGARSDKDemoApp-ios/Xcode/cppframework/Debug${EFFECTIVE_PLATFORM_NAME}/TestFramework.framework/TestFramework
	/bin/rm -f /Users/jianxinluo/Desktop/Test/XJGARSDKDemoApp-ios/Xcode/cppframework/XJGARSDKDemoApp.build/Debug/TestFramework.build/Objects-normal/armv7/TestFramework.framework/TestFramework
	/bin/rm -f /Users/jianxinluo/Desktop/Test/XJGARSDKDemoApp-ios/Xcode/cppframework/XJGARSDKDemoApp.build/Debug/TestFramework.build/Objects-normal/armv7s/TestFramework.framework/TestFramework
	/bin/rm -f /Users/jianxinluo/Desktop/Test/XJGARSDKDemoApp-ios/Xcode/cppframework/XJGARSDKDemoApp.build/Debug/TestFramework.build/Objects-normal/arm64/TestFramework.framework/TestFramework


PostBuild.XJGARSDKDemoApp.Release:
/Users/jianxinluo/Desktop/Test/XJGARSDKDemoApp-ios/Xcode/Release${EFFECTIVE_PLATFORM_NAME}/XJGARSDKDemoApp.app/XJGARSDKDemoApp:\
	/Users/jianxinluo/Desktop/Test/XJGARSDKDemoApp-ios/Xcode/cppframework/./${CONFIGURATION}${EFFECTIVE_PLATFORM_NAME}/TestFramework.framework/TestFramework
	/bin/rm -f /Users/jianxinluo/Desktop/Test/XJGARSDKDemoApp-ios/Xcode/Release${EFFECTIVE_PLATFORM_NAME}/XJGARSDKDemoApp.app/XJGARSDKDemoApp
	/bin/rm -f /Users/jianxinluo/Desktop/Test/XJGARSDKDemoApp-ios/Xcode/XJGARSDKDemoApp.build/Release/XJGARSDKDemoApp.build/Objects-normal/armv7/XJGARSDKDemoApp
	/bin/rm -f /Users/jianxinluo/Desktop/Test/XJGARSDKDemoApp-ios/Xcode/XJGARSDKDemoApp.build/Release/XJGARSDKDemoApp.build/Objects-normal/armv7s/XJGARSDKDemoApp
	/bin/rm -f /Users/jianxinluo/Desktop/Test/XJGARSDKDemoApp-ios/Xcode/XJGARSDKDemoApp.build/Release/XJGARSDKDemoApp.build/Objects-normal/arm64/XJGARSDKDemoApp


PostBuild.TestFramework.Release:
/Users/jianxinluo/Desktop/Test/XJGARSDKDemoApp-ios/Xcode/cppframework/Release${EFFECTIVE_PLATFORM_NAME}/TestFramework.framework/TestFramework:
	/bin/rm -f /Users/jianxinluo/Desktop/Test/XJGARSDKDemoApp-ios/Xcode/cppframework/Release${EFFECTIVE_PLATFORM_NAME}/TestFramework.framework/TestFramework
	/bin/rm -f /Users/jianxinluo/Desktop/Test/XJGARSDKDemoApp-ios/Xcode/cppframework/XJGARSDKDemoApp.build/Release/TestFramework.build/Objects-normal/armv7/TestFramework.framework/TestFramework
	/bin/rm -f /Users/jianxinluo/Desktop/Test/XJGARSDKDemoApp-ios/Xcode/cppframework/XJGARSDKDemoApp.build/Release/TestFramework.build/Objects-normal/armv7s/TestFramework.framework/TestFramework
	/bin/rm -f /Users/jianxinluo/Desktop/Test/XJGARSDKDemoApp-ios/Xcode/cppframework/XJGARSDKDemoApp.build/Release/TestFramework.build/Objects-normal/arm64/TestFramework.framework/TestFramework


PostBuild.XJGARSDKDemoApp.MinSizeRel:
/Users/jianxinluo/Desktop/Test/XJGARSDKDemoApp-ios/Xcode/MinSizeRel${EFFECTIVE_PLATFORM_NAME}/XJGARSDKDemoApp.app/XJGARSDKDemoApp:\
	/Users/jianxinluo/Desktop/Test/XJGARSDKDemoApp-ios/Xcode/cppframework/./${CONFIGURATION}${EFFECTIVE_PLATFORM_NAME}/TestFramework.framework/TestFramework
	/bin/rm -f /Users/jianxinluo/Desktop/Test/XJGARSDKDemoApp-ios/Xcode/MinSizeRel${EFFECTIVE_PLATFORM_NAME}/XJGARSDKDemoApp.app/XJGARSDKDemoApp
	/bin/rm -f /Users/jianxinluo/Desktop/Test/XJGARSDKDemoApp-ios/Xcode/XJGARSDKDemoApp.build/MinSizeRel/XJGARSDKDemoApp.build/Objects-normal/armv7/XJGARSDKDemoApp
	/bin/rm -f /Users/jianxinluo/Desktop/Test/XJGARSDKDemoApp-ios/Xcode/XJGARSDKDemoApp.build/MinSizeRel/XJGARSDKDemoApp.build/Objects-normal/armv7s/XJGARSDKDemoApp
	/bin/rm -f /Users/jianxinluo/Desktop/Test/XJGARSDKDemoApp-ios/Xcode/XJGARSDKDemoApp.build/MinSizeRel/XJGARSDKDemoApp.build/Objects-normal/arm64/XJGARSDKDemoApp


PostBuild.TestFramework.MinSizeRel:
/Users/jianxinluo/Desktop/Test/XJGARSDKDemoApp-ios/Xcode/cppframework/MinSizeRel${EFFECTIVE_PLATFORM_NAME}/TestFramework.framework/TestFramework:
	/bin/rm -f /Users/jianxinluo/Desktop/Test/XJGARSDKDemoApp-ios/Xcode/cppframework/MinSizeRel${EFFECTIVE_PLATFORM_NAME}/TestFramework.framework/TestFramework
	/bin/rm -f /Users/jianxinluo/Desktop/Test/XJGARSDKDemoApp-ios/Xcode/cppframework/XJGARSDKDemoApp.build/MinSizeRel/TestFramework.build/Objects-normal/armv7/TestFramework.framework/TestFramework
	/bin/rm -f /Users/jianxinluo/Desktop/Test/XJGARSDKDemoApp-ios/Xcode/cppframework/XJGARSDKDemoApp.build/MinSizeRel/TestFramework.build/Objects-normal/armv7s/TestFramework.framework/TestFramework
	/bin/rm -f /Users/jianxinluo/Desktop/Test/XJGARSDKDemoApp-ios/Xcode/cppframework/XJGARSDKDemoApp.build/MinSizeRel/TestFramework.build/Objects-normal/arm64/TestFramework.framework/TestFramework


PostBuild.XJGARSDKDemoApp.RelWithDebInfo:
/Users/jianxinluo/Desktop/Test/XJGARSDKDemoApp-ios/Xcode/RelWithDebInfo${EFFECTIVE_PLATFORM_NAME}/XJGARSDKDemoApp.app/XJGARSDKDemoApp:\
	/Users/jianxinluo/Desktop/Test/XJGARSDKDemoApp-ios/Xcode/cppframework/./${CONFIGURATION}${EFFECTIVE_PLATFORM_NAME}/TestFramework.framework/TestFramework
	/bin/rm -f /Users/jianxinluo/Desktop/Test/XJGARSDKDemoApp-ios/Xcode/RelWithDebInfo${EFFECTIVE_PLATFORM_NAME}/XJGARSDKDemoApp.app/XJGARSDKDemoApp
	/bin/rm -f /Users/jianxinluo/Desktop/Test/XJGARSDKDemoApp-ios/Xcode/XJGARSDKDemoApp.build/RelWithDebInfo/XJGARSDKDemoApp.build/Objects-normal/armv7/XJGARSDKDemoApp
	/bin/rm -f /Users/jianxinluo/Desktop/Test/XJGARSDKDemoApp-ios/Xcode/XJGARSDKDemoApp.build/RelWithDebInfo/XJGARSDKDemoApp.build/Objects-normal/armv7s/XJGARSDKDemoApp
	/bin/rm -f /Users/jianxinluo/Desktop/Test/XJGARSDKDemoApp-ios/Xcode/XJGARSDKDemoApp.build/RelWithDebInfo/XJGARSDKDemoApp.build/Objects-normal/arm64/XJGARSDKDemoApp


PostBuild.TestFramework.RelWithDebInfo:
/Users/jianxinluo/Desktop/Test/XJGARSDKDemoApp-ios/Xcode/cppframework/RelWithDebInfo${EFFECTIVE_PLATFORM_NAME}/TestFramework.framework/TestFramework:
	/bin/rm -f /Users/jianxinluo/Desktop/Test/XJGARSDKDemoApp-ios/Xcode/cppframework/RelWithDebInfo${EFFECTIVE_PLATFORM_NAME}/TestFramework.framework/TestFramework
	/bin/rm -f /Users/jianxinluo/Desktop/Test/XJGARSDKDemoApp-ios/Xcode/cppframework/XJGARSDKDemoApp.build/RelWithDebInfo/TestFramework.build/Objects-normal/armv7/TestFramework.framework/TestFramework
	/bin/rm -f /Users/jianxinluo/Desktop/Test/XJGARSDKDemoApp-ios/Xcode/cppframework/XJGARSDKDemoApp.build/RelWithDebInfo/TestFramework.build/Objects-normal/armv7s/TestFramework.framework/TestFramework
	/bin/rm -f /Users/jianxinluo/Desktop/Test/XJGARSDKDemoApp-ios/Xcode/cppframework/XJGARSDKDemoApp.build/RelWithDebInfo/TestFramework.build/Objects-normal/arm64/TestFramework.framework/TestFramework




# For each target create a dummy ruleso the target does not have to exist
/Users/jianxinluo/Desktop/Test/XJGARSDKDemoApp-ios/Xcode/cppframework/./${CONFIGURATION}${EFFECTIVE_PLATFORM_NAME}/TestFramework.framework/TestFramework:
