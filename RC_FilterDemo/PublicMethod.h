//
//  PublicMethod.h
//  EffectDemon
//
//  Created by wsq-wlq on 14-12-20.
//  Copyright (c) 2014年 wsq-wlq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONKit.h"

#import "sys/sysctl.h"
#include <mach/mach.h>
#import <stdlib.h>
#import <time.h>
#import <UIKit/UIKit.h>



@interface PublicMethod : NSObject

NSDictionary *getFilterProgressConfigDic(NSInteger type);
NSDictionary *getConfigFilterDic(NSInteger type);

CGRect getTextLabelRectWithContentAndFont(NSString *content ,UIFont *font);

UIColor* colorWithHexString(NSString *stringToConvert);

NSString *doDevicePlatform();

NSString *LocalizedString(NSString *translation_key, id none);

UIImage* pngImagePath(NSString *name);

CGFloat getTheScaleForImageSize(CGSize size,CGSize oriSize);

@end
