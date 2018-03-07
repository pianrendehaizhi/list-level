//
//  MyModel.h
//  2018年03月07日
//
//  Created by BiShuai on 2018/3/7.
//  Copyright © 2018年 BiShuai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL haveSubLevel;
@property (nonatomic, assign) BOOL expand;
@property (nonatomic, assign) NSUInteger level;

@end
