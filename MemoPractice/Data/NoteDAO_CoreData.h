//
//  NoteDAO_CoreData.h
//  MemoPractice
//
//  Created by BlackApple on 2017/7/10.
//  Copyright © 2017年 BlackApple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Note.h"
#import "CoreDataDAO.h"

@interface NoteDAO_CoreData :CoreDataDAO

+ (NoteDAO_CoreData*)shareManager;

//插入Note方法
-(int) creat:(Note*)model;

//删除Note方法
-(int) remove:(Note*)model;

//修改Note方法
-(int) modify:(Note*)model;

//查询所有数据方法
-(NSMutableArray*) findAll;

//按照主键查询数据方法
-(Note*) findById:(Note*)model;
@end
