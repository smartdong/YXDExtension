//
//  YXDNetworkManager.h
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

//参数名
#define Define_Image_Dictionary_paramName               @"paramName"
//图片名
#define Define_Image_Dictionary_imageName               @"imageName"
//图片数据
#define Define_Image_Dictionary_imageData               @"imageData"

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, NetworkManagerHttpMethod) {
    GET = 0,
    POST,
    PUT,
    DELETE,
    PATCH,
};

@interface YXDNetworkManager : NSObject

/**
 *  根据相应接口获取数据
 *
 *  @param params           数据字典
 *  @param interfaceAddress 接口地址
 *  @param success          成功处理方法
 *  @param failure          失败处理方法
 *  @param loadingStatus    是否显示加载提示  nil则不提示
 *  @param method           网络请求方法
 */
+ (void)loadDataFromServerWithParams:(NSDictionary *)params
                    interfaceAddress:(NSString *)interfaceAddress
                             success:(void (^)(NSDictionary *data, NSString *msg))success
                             failure:(void (^)(NSError *error))failure
                       loadingStatus:(NSString *)loadingStatus
                              method:(NetworkManagerHttpMethod)method;

/**
*  根据相应接口获取数据
*
*  @param params           数据字典
*  @param imagesDataArray  图片数据数组     paramName:参数名  imageName:图片名  imageData:图片数据
*  @param interfaceAddress 接口地址
*  @param success          成功处理方法
*  @param failure          失败处理方法
*  @param loadingStatus    是否显示加载提示  nil则不提示
*  @param method           网络请求方法
*/
+ (void)loadDataFromServerWithParams:(NSDictionary *)params
                     imagesDataArray:(NSArray *)imagesDataArray
                    interfaceAddress:(NSString *)interfaceAddress
                             success:(void (^)(NSDictionary *data, NSString *msg))success
                             failure:(void (^)(NSError *error))failure
                       loadingStatus:(NSString *)loadingStatus
                              method:(NetworkManagerHttpMethod)method;

@end
