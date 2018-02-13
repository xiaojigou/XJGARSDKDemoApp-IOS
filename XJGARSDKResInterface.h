
#import <UIKit/UIKit.h>

//"filter_none",
//"filter_cool",
//"filter_Healthy",
//"filter_emerald",
//"filter_nostalgia",
//"filter_crayon",
//"filter_evergreen",
//"filter_warm",
//"filter_antique",
//"filter_sketch"

//滤镜类型的枚举对象
typedef enum {
    XJGARSDK_FILTER_NONE,
    XJGARSDK_FILTER_COOL,
    XJGARSDK_FILTER_HEALTHY,
    XJGARSDK_FILTER_EMERALD,
    XJGARSDK_FILTER_NOSTALGIA,
    XJGARSDK_FILTER_CRAYON,
    XJGARSDK_FILTER_EVERGREEN,
//    XJGARSDK_FILTER_WARM,
//    XJGARSDK_FILTER_ANTIQUE,
//    XJGARSDK_FILTER_SKETCH,
    XJGARSDK_FILTER_TOTLALNUM
} XJGARSDKFilterType;

//贴纸类型的枚举对象
typedef enum {
    XJGARSDK_STICKER_NONE,
    XJGARSDK_STICKER_STRAWBERRYCAT,
    XJGARSDK_STICKER_ANGEL,
    XJGARSDK_STICKER_CANGOU,
    XJGARSDK_STICKER_DAXIONGMAO,
    XJGARSDK_STICKER_DIVING,
    XJGARSDK_STICKER_TOTLALNUM
} XJGARSDKStickerType;

//资源辅助类对象
@interface XJGARSDKResInterface : NSObject
//获取滤镜的名字，根据索引获取
+ (NSString*)getFilterNameByFilterIdx:(XJGARSDKFilterType)filterIdx;
+ (NSString*)getStickerNameByStickerIdx:(XJGARSDKStickerType)stickerIdx;

@end
