//
//  file.h
//  随便试试
//
//  Created by 张丽 on 15/7/15.
//  Copyright (c) 2015年 张丽. All rights reserved.
//

#ifndef _____file_h
#define _____file_h

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0f \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0f blue:((float)(rgbValue & 0xFF))/255.0f \
alpha:1.0f]


#endif
