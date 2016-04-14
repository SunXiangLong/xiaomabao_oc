//
//  RootViewController.h
//  pictureProcess
//
//  Created by Ibokan on 12-9-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <UIKit/UIKit.h>
@interface ImageUtil : NSObject 

+ (UIImage *)imageWithImage:(UIImage*)inImage withColorMatrix:(const float*)f;

+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation;//改变image方向
@end
