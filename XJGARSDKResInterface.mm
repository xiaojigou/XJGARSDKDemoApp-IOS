
#import "XJGARSDKResInterface.h"


@interface XJGARSDKResInterface ()

@end

@implementation XJGARSDKResInterface


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
+ (NSString*)getFilterNameByFilterIdx:(XJGARSDKFilterType)filterIdx
{
    switch (filterIdx) {
        case XJGARSDK_FILTER_NONE:      return @"filter_none";
        case XJGARSDK_FILTER_COOL:      return @"filter_cool";
        case XJGARSDK_FILTER_HEALTHY:   return @"filter_Healthy";
        case XJGARSDK_FILTER_EMERALD:   return @"filter_emerald";
        case XJGARSDK_FILTER_NOSTALGIA: return @"filter_nostalgia";
        case XJGARSDK_FILTER_CRAYON:    return @"filter_crayon";
        case XJGARSDK_FILTER_EVERGREEN: return @"filter_evergreen";
//        case XJGARSDK_FILTER_WARM:      return @"filter_warm";
//        case XJGARSDK_FILTER_ANTIQUE:   return @"filter_antique";
//        case XJGARSDK_FILTER_SKETCH:    return @"filter_sketch";
        default:break;
    }
    return @"";
}


+ (NSString*)getStickerNameByStickerIdx:(XJGARSDKStickerType)stickerIdx
{
    
    //贴纸类型的枚举对象
    switch (stickerIdx) {
        case XJGARSDK_STICKER_NONE:                 return @"sticker_none";
        case XJGARSDK_STICKER_STRAWBERRYCAT:        return @"stpaper900224";
        case XJGARSDK_STICKER_ANGEL:                return @"angel";
        case XJGARSDK_STICKER_CANGOU:               return @"cangou";
        case XJGARSDK_STICKER_DAXIONGMAO:           return @"caishen";
        case XJGARSDK_STICKER_DIVING:               return @"diving";
        default:break;
    }
    return @"";
}


@end
