//
//  YXDNetworkManager.h
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NetworkManagerInstance  [YXDNetworkManager sharedInstance]

typedef NS_ENUM(NSInteger, NetworkManagerHttpMethod) {
    GET = 0,
    POST,
    PUT,
    DELETE,
    PATCH,
};

@class UIImage;

/**
 *  上传图片对象
 *
 *  @param paramName    接口对应的图片参数名
 *  @param imageName    图片名称
 *  @param imageData    image 对象
 *
 *  @param quality      压缩质量 默认 0.1 最高 1
 *  @param imageType    图片类型 默认 png
 */
@interface YXDNetworkImageObject : NSObject

@property (nonatomic, copy) NSString *paramName;
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, strong) UIImage *imageData;

//optional

@property (nonatomic, assign) float quality;
@property (nonatomic, copy) NSString *imageType;

@end

@class AFHTTPRequestOperationManager;

@interface YXDNetworkManager : NSObject

@property (nonatomic, strong) AFHTTPRequestOperationManager *requsetManager;

@property (nonatomic, strong) NSMutableDictionary *commonParams;
@property (nonatomic, strong) NSMutableDictionary *commonHeaders;

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
- (void)sendRequestWithParams:(NSDictionary *)params
             interfaceAddress:(NSString *)interfaceAddress
                      success:(void (^)(NSDictionary *data, NSString *msg))success
                      failure:(void (^)(NSError *error))failure
                loadingStatus:(NSString *)loadingStatus
                       method:(NetworkManagerHttpMethod)method;

/**
*  根据相应接口获取数据
*
*  @param params           数据字典
*  @param imagesDataArray  图片数据
*  @param interfaceAddress 接口地址
*  @param success          成功处理方法
*  @param failure          失败处理方法
*  @param loadingStatus    是否显示加载提示  nil则不提示
*  @param method           网络请求方法
*/
- (void)sendRequestWithParams:(NSDictionary *)params
              imagesDataArray:(NSArray<YXDNetworkImageObject *> *)imagesDataArray
             interfaceAddress:(NSString *)interfaceAddress
                      success:(void (^)(NSDictionary *data, NSString *msg))success
                      failure:(void (^)(NSError *error))failure
                loadingStatus:(NSString *)loadingStatus
                       method:(NetworkManagerHttpMethod)method;

#pragma mark - New

/**
 *  默认全局的 manager
 */
+ (instancetype)sharedInstance;

/**
 *  新建一个 manager
 */
+ (instancetype)newManager;

@end
