cmake_minimum_required (VERSION 3.7)

file(GLOB_RECURSE FRAMEWORK_HEADS
"./*.h"
"./*.hpp"
)


file(GLOB_RECURSE FRAMEWORK_SRCS
"./*.cpp"
"./*.mm"
)

include_directories( "." "./filter" "./source" "./target" "./target/IOS")

set(LIBRARY_SOURCE
    ${CMAKE_CURRENT_LIST_DIR}/Foo.hh
    ${CMAKE_CURRENT_LIST_DIR}/Foo.cpp
)

set(CMAKE_CXX_FLAGS "-x objective-c++")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fobjc-arc")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
set(CMAKE_C_FLAGS "-x objective-c")


find_library(AVFOUNDATION AVFoundation)
find_library(COREMEDIA CoreMedia)
find_library(OPENGLES OpenGLES)
find_library(COREGRAPHICS CoreGraphics)
find_library(GLKIT GLKit)

find_library(UIKIT UIKit)
find_library(FOUNDATION Foundation)

find_library(MOBILECORESERVICES MobileCoreServices)
find_library(CFNETWORK CFNetwork)
find_library(SYSTEMCONFIGURATION SystemConfiguration)

find_library(CORETELEPHONY CoreTelephony)
find_library(COREVIDEO CoreVideo)
find_library(MESSAGEUI MessageUI)


find_library(QUARTZCORE QuartzCore)
find_library(COREDATA CoreData)


add_library(
    ${FRAMEWORK_NAME} SHARED
    ${LIBRARY_SOURCE}
    ${FRAMEWORK_HEADS}
    ${FRAMEWORK_SRCS}
)


target_link_libraries(${FRAMEWORK_NAME} ${AVFOUNDATION})
target_link_libraries(${FRAMEWORK_NAME} ${COREMEDIA})
target_link_libraries(${FRAMEWORK_NAME} ${OPENGLES})
target_link_libraries(${FRAMEWORK_NAME} ${COREGRAPHICS})
target_link_libraries(${FRAMEWORK_NAME} ${GLKIT})

target_link_libraries(${FRAMEWORK_NAME} ${UIKIT})
target_link_libraries(${FRAMEWORK_NAME} ${FOUNDATION})

target_link_libraries(${FRAMEWORK_NAME} ${MOBILECORESERVICES})
target_link_libraries(${FRAMEWORK_NAME} ${CFNETWORK})
target_link_libraries(${FRAMEWORK_NAME} ${SYSTEMCONFIGURATION})


target_link_libraries(${FRAMEWORK_NAME} ${CORETELEPHONY})
target_link_libraries(${FRAMEWORK_NAME} ${COREVIDEO})
target_link_libraries(${FRAMEWORK_NAME} ${MESSAGEUI})

target_link_libraries(${FRAMEWORK_NAME} ${QUARTZCORE})
target_link_libraries(${FRAMEWORK_NAME} ${COREDATA})


set(CMAKE_SHARED_LINKER_FLAGS "-Wall")

#只能设置一个头文件？？，设置多个不行？？
set(OUTPUT_HEAD_FILES
"${CMAKE_CURRENT_LIST_DIR}/Foo.hh"
)


set_target_properties(${FRAMEWORK_NAME} PROPERTIES
    FRAMEWORK TRUE
    FRAMEWORK_VERSION A
    MACOSX_FRAMEWORK_IDENTIFIER ${FRAMEWORK_BUNDLE_IDENTIFIER}
    MACOSX_FRAMEWORK_INFO_PLIST ${CMAKE_CURRENT_LIST_DIR}/framework.plist.in
    # "current version" in semantic format in Mach-O binary file
    VERSION 1.0.0
    # "compatibility version" in semantic format in Mach-O binary file
    SOVERSION 1.0.0
    PUBLIC_HEADER ${OUTPUT_HEAD_FILES}
    XCODE_ATTRIBUTE_IPHONEOS_DEPLOYMENT_TARGET ${DEPLOYMENT_TARGET}
    XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY ${CODE_SIGN_IDENTITY}
    XCODE_ATTRIBUTE_DEVELOPMENT_TEAM ${DEVELOPMENT_TEAM_ID}
    XCODE_ATTRIBUTE_TARGETED_DEVICE_FAMILY ${DEVICE_FAMILY}
    XCODE_ATTRIBUTE_SKIP_INSTALL "YES"
)

# Symbol visibility setup, COMPILE_FLAGS only affect C++ so for Objective C we
# have to use XCODE_ATTRIBUTE_OTHER_CFLAGS.
set_target_properties(${FRAMEWORK_NAME} PROPERTIES
    COMPILE_FLAGS "-fvisibility=hidden -fvisibility-inlines-hidden"
    XCODE_ATTRIBUTE_OTHER_CFLAGS "-fvisibility=hidden -fvisibility-inlines-hidden")

# set_target_properties(${FRAMEWORK_NAME} PROPERTIES COMPILE_FLAGS "-x c++")

add_custom_command(
    TARGET ${FRAMEWORK_NAME}
    POST_BUILD
    COMMAND /bin/bash -c "${CMAKE_CURRENT_LIST_DIR}/install_name.sh \${BUILT_PRODUCTS_DIR}/\${PRODUCT_NAME}.framework/\${PRODUCT_NAME}"
)

add_custom_command(
    TARGET ${FRAMEWORK_NAME}
    POST_BUILD
    COMMAND install_name_tool -id \"@rpath/\${PRODUCT_NAME}.framework/\${PRODUCT_NAME}\"
    \${BUILT_PRODUCTS_DIR}/\${PRODUCT_NAME}.framework/\${PRODUCT_NAME}
)

