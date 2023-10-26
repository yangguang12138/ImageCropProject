//
//  JSToNativeBridgeModule.m
//  AwesomeProject
//
//  Created by shy on 2023/10/25.
//

#import "JSToNativeBridgeModule.h"

@implementation JSToNativeBridgeModule

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(drawImageWithOriginPath:(NSString *)originImagePath
                  withMaskPath:(NSString *)maskImagePath
                  callback:(RCTResponseSenderBlock)callback) {
  UIImage *originImage = nil;
  UIImage *maskImage = nil;
  NSData *originData = [NSData dataWithContentsOfURL:[NSURL URLWithString:originImagePath]];
  originImage = [UIImage imageWithData:originData];
  NSData *maskData = [NSData dataWithContentsOfURL:[NSURL URLWithString:maskImagePath]];
  maskImage = [UIImage imageWithData:maskData];
  
  // 分配内存
  const int imageWidth = originImage.size.width;
  const int imageHeight = originImage.size.height;
  size_t      bytesPerRow = imageWidth * 4;
  uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
  
  // 创建context
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
  CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), originImage.CGImage);
  
  uint32_t *maskImageBuf = (uint32_t *)malloc(bytesPerRow*imageHeight);
  CGContextRef maskContext = CGBitmapContextCreate(maskImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
  CGContextDrawImage(maskContext, CGRectMake(0, 0, imageWidth, imageHeight), maskImage.CGImage);
  
  // 遍历像素
  int pixelNum = imageWidth * imageHeight;
  uint32_t* pCurPtr = rgbImageBuf;
  uint32_t* maskPtr = maskImageBuf;
  
  for (int i = 0; i < pixelNum; i++, pCurPtr++)
  {
      uint8_t *ptr1= (uint8_t*)maskPtr;
      int maskB = ptr1[1];
      int maskG = ptr1[2];
      int maskR = ptr1[3];
      int gray = maskB +maskG + maskR;
      if (gray<=10) {
          uint8_t* ptr = (uint8_t*)pCurPtr;
          ptr[0] = 0;
      }
      maskPtr++;
  }
  // 将内存转成image
  CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight,NULL);
  CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,NULL, true, kCGRenderingIntentDefault);
  
  CGDataProviderRelease(dataProvider);
  
  UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef scale:originImage.scale orientation:originImage.imageOrientation];
  // 释放
  CGImageRelease(imageRef);
  CGContextRelease(context);
  CGContextRelease(maskContext);
  CGColorSpaceRelease(colorSpace);
  
  NSData *data = UIImagePNGRepresentation(resultUIImage);
  NSString*preSaveFile = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
  NSString*saveFile = [NSString stringWithFormat:@"%@/test.png",preSaveFile];
  [data writeToFile:saveFile atomically:YES];
  callback(@[@{@"path":saveFile}]);
}

@end
