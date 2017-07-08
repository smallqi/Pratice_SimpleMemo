//
//  NoteManage.h
//  MemoPractice
//
//  Created by BlackApple on 2017/7/7.
//  Copyright © 2017年 BlackApple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Note.h"

@interface NoteManage : NSObject

//插入
+(NSMutableArray*)createNote:(Note*)model;
//删除
+(NSMutableArray*)remove:(Note*)model;
//查询
+(NSMutableArray*)findAll;
//修改
+(NSMutableArray*)modify:(Note*)model;

@end
