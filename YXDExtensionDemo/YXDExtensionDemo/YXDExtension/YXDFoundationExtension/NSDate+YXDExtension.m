//
//  NSDate+YXDExtension.m
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import "NSDate+YXDExtension.h"

@implementation NSDate (YXDExtension)

- (NSString *)dateString {
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter stringFromDate:self];
}

- (NSString *)dateTimeString {
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter stringFromDate:self];
}

- (NSString *)stringWithDateFormat:(NSString *)format {
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:format];
    return [formatter stringFromDate:self];
}

+ (NSDate *)dateFromDateString:(NSString *)dateString {
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter dateFromString:dateString];
}

+ (NSDate *)dateFromDatetimeString:(NSString *)dateTimeString {
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter dateFromString:dateTimeString];
}

-(NSString *)constellation {
    //计算星座
    NSString *retStr=@"";
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM"];
    int i_month=0;
    NSString *theMonth = [dateFormat stringFromDate:self];
    if([[theMonth substringToIndex:0] isEqualToString:@"0"]){
        i_month = [[theMonth substringFromIndex:1] intValue];
    }else{
        i_month = [theMonth intValue];
    }
    
    [dateFormat setDateFormat:@"dd"];
    int i_day=0;
    NSString *theDay = [dateFormat stringFromDate:self];
    if([[theDay substringToIndex:0] isEqualToString:@"0"]){
        i_day = [[theDay substringFromIndex:1] intValue];
    }else{
        i_day = [theDay intValue];
    }
    /*
     摩羯座 12月22日------1月19日
     水瓶座 1月20日-------2月18日
     双鱼座 2月19日-------3月20日
     白羊座 3月21日-------4月19日
     金牛座 4月20日-------5月20日
     双子座 5月21日-------6月21日
     巨蟹座 6月22日-------7月22日
     狮子座 7月23日-------8月22日
     处女座 8月23日-------9月22日
     天秤座 9月23日------10月23日
     天蝎座 10月24日-----11月21日
     射手座 11月22日-----12月21日
     */
    switch (i_month) {
        case 1:
            if(i_day>=20 && i_day<=31){
                retStr=@"水瓶座";
            }
            if(i_day>=1 && i_day<=19){
                retStr=@"摩羯座";
            }
            break;
        case 2:
            if(i_day>=1 && i_day<=18){
                retStr=@"水瓶座";
            }
            if(i_day>=19 && i_day<=31){
                retStr=@"双鱼座";
            }
            break;
        case 3:
            if(i_day>=1 && i_day<=20){
                retStr=@"双鱼座";
            }
            if(i_day>=21 && i_day<=31){
                retStr=@"白羊座";
            }
            break;
        case 4:
            if(i_day>=1 && i_day<=19){
                retStr=@"白羊座";
            }
            if(i_day>=20 && i_day<=31){
                retStr=@"金牛座";
            }
            break;
        case 5:
            if(i_day>=1 && i_day<=20){
                retStr=@"金牛座";
            }
            if(i_day>=21 && i_day<=31){
                retStr=@"双子座";
            }
            break;
        case 6:
            if(i_day>=1 && i_day<=21){
                retStr=@"双子座";
            }
            if(i_day>=22 && i_day<=31){
                retStr=@"巨蟹座";
            }
            break;
        case 7:
            if(i_day>=1 && i_day<=22){
                retStr=@"巨蟹座";
            }
            if(i_day>=23 && i_day<=31){
                retStr=@"狮子座";
            }
            break;
        case 8:
            if(i_day>=1 && i_day<=22){
                retStr=@"狮子座";
            }
            if(i_day>=23 && i_day<=31){
                retStr=@"处女座";
            }
            break;
        case 9:
            if(i_day>=1 && i_day<=22){
                retStr=@"处女座";
            }
            if(i_day>=23 && i_day<=31){
                retStr=@"天秤座";
            }
            break;
        case 10:
            if(i_day>=1 && i_day<=23){
                retStr=@"天秤座";
            }
            if(i_day>=24 && i_day<=31){
                retStr=@"天蝎座";
            }
            break;
        case 11:
            if(i_day>=1 && i_day<=21){
                retStr=@"天蝎座";
            }
            if(i_day>=22 && i_day<=31){
                retStr=@"射手座";
            }
            break;
        case 12:
            if(i_day>=1 && i_day<=21){
                retStr=@"射手座";
            }
            if(i_day>=21 && i_day<=31){
                retStr=@"摩羯座";
            }
            break;
    }
    return retStr;
}

@end
