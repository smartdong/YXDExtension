//
//  YXDNetworkImageObject.h
//  YXDExtensionDemo
//
//  Created by zjdd on 16/2/23.
//  Copyright © 2016年 YangXudong. All rights reserved.
//

#import <Foundation/Foundation.h>

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
