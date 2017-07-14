//
//  YXDNetworkUploadObject.m
//  YXDExtensionDemo
//
//  Copyright © 2016年 YangXudong. All rights reserved.
//

#import "YXDNetworkUploadObject.h"

@implementation YXDNetworkUploadObject

- (NSString *)fileName {
    if (!_fileName) {
        _fileName = @"sth.obj";
    }
    return _fileName;
}

- (NSString *)fileType {
    if (!_fileType) {
        _fileType = @"image/jpeg";
    }
    return _fileType;
}

- (float)imageQuality {
    if (_imageQuality < 0.1) {
        _imageQuality = 0.1;
    } else if (_imageQuality > 1) {
        _imageQuality = 1;
    }
    return _imageQuality;
}

@end
