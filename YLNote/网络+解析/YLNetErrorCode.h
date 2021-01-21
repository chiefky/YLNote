//
//  YLNetErrorCode.h
//  YLNote
//
//  Created by tangh on 2021/1/21.
//  Copyright © 2021 tangh. All rights reserved.
//

#ifndef YLNetErrorCode_h
#define YLNetErrorCode_h

// errors

#define YLNetworkErrorDesc @"服务器异常"
static const int YLNetworkErrorCode = 1;

#define YLNetworkDataformatErrorDesc @"服务器返回数据格式错误"
static const int YLNetworkDataformatErrorCode = 2;

#define YLFileUploadErrorDomain @"FileUploadError"

#define YLFilePreprocessErrorDesc @"文件预处理错误"
static const int YLFilePreprocessErrorCode = 8999;

#define YLFileNotFoundErrorDesc @"文件不存在"
static const int YLFileNotFoundErrorCode = 8998;

#define YLFileErrorDesc @"文件错误"
static const int YLFileErrorCode = 8997;

#define YLFileUploadErrorDesc @"文件上传异常"
static const int YLFileUploadErrorCode = 8996;

#define YLFileSegUploadErrorDesc @"文件分片上传异常"
static const int YLFileSegUploadErrorCode = 8995;

#define YLFileProcessErrorDesc @"文件处理错误"
static const int YLFileProcessErrorCode = 8994;

#define YLFilePathComputErrorDesc @"文件路径计算错误"
static const int YLFilePathComputErrorCode = 8993;

#define YLSaveFileFromAlbumErrorDesc @"从相册保存文件错误"
static const int YLSaveFileFromAlbumErrorCode = 8992;

#define YLReadOriImageFileErrorDesc @"读取原图错误"
static const int YLReadOriImageFileErrorCode = 8991;

#define YLImageResizeErrorDesc @"图片缩放处理错误"
static const int YLImageResizeErrorCode = 8990;

#define YLFilePreprocessUnknownErrorDesc @"文件预处理未知错误"
static const int YLFilePreprocessUnknownErrorCode = 8989;

#define YLImageFilePathResizeErrorDesc @"图片(文件路径)缩放处理错误"
static const int YLImageFilePathResizeErrorCode = 8988;

#define YLFilePreprocessUnknownErrorDesc2 @"文件预处理未知错误2"
static const int YLFilePreprocessUnknownErrorCode2 = 8987;

#define YLFilePreprocessUnknownErrorDesc3 @"有图片预处理失败，请检查磁盘空间和图片是否有效"
static const int YLFilePreprocessUnknownErrorCode3 = 8986;

#define YLFilePreprocessFreeDiskSizeNotEnough @"磁盘空间不足导致无法处理图片"
static const int YLFilePreprocessFreeDiskSizeNotEnoughErrorCode = 8985;

#define YLFileSourceFileNullErrorDesc @"原文件名为空"
static const int YLFileSourceFileNullErrorCode = 8984;

#define YLArticlSendErrorDesc @"长微博发送失败"
static const int YLArticleSendErrorCode = 8700;

#define YLComposeAttachmentSendErrorDesc @"附件发送失败"
static const int YLComposeAttachmentSendErrorCode = 8701;

#define YLUploadParameterValidationFailDesc @"上传校验参数错误"
static const int YLUploadParameterValidationFailCode = 8983;



#endif /* YLNetErrorCode_h */
