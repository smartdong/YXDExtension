//
//  YXDNetworkUploadObject.h
//  YXDExtensionDemo
//
//  Copyright © 2016年 YangXudong. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  上传文件对象
 *
 *  @param paramName    接口对应的文件参数名
 *  @param file         文件对象 仅支持 UIImage 或 NSData 类型
 *
 *  @param fileName     文件名称
 *  @param fileType     文件类型 默认 image/jpeg 其他类型则必须 示例：image/png 、text/plain 、application/zip
 *  @param imageQuality 图片压缩质量 范围(0.1 ~ 1) 默认 0.1
 */
@interface YXDNetworkUploadObject : NSObject

//required
@property (nonatomic, strong) NSString *paramName;
@property (nonatomic, strong) id file;

//optional
@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSString *fileType;
@property (nonatomic, assign) float imageQuality;

@end
