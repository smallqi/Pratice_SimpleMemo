//
//  NoteDAO_Sqlite.h
//  MemoPractice
//
//  Created by BlackApple on 2017/7/9.
//  Copyright © 2017年 BlackApple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Note.h"
@interface NoteDAO_Sqlite : NSObject
//实例方法，全局返回一个单例DAO
+(NoteDAO_Sqlite*)shareManager;
//插入
-(int)creat:(Note*)note;
//删除
-(int)remove:(Note*)note;
//修改
-(int)modify:(Note*)note;
//查询
-(NSMutableArray*)findAll;
//主键查询
-(Note*)findById:(Note*)note;

@end
