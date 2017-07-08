//
//  NoteManage.m
//  MemoPractice
//
//  Created by BlackApple on 2017/7/7.
//  Copyright © 2017年 BlackApple. All rights reserved.
//

#import "NoteManage.h"
#import "NoteDAO.h"

@implementation NoteManage

//插入
+(NSMutableArray*)createNote:(Note*)model {
    NoteDAO* dao = [NoteDAO shareManager];
    [dao creat:model];
    
    return [dao findAll];
}
//删除
+(NSMutableArray*)remove:(Note*)model {
    NoteDAO* dao = [NoteDAO shareManager];
    [dao remove:model];
    
    return [dao findAll];

}
//查询
+(NSMutableArray*)findAll {
    NoteDAO* dao = [NoteDAO shareManager];
    return [dao findAll];

}
//修改
+(NSMutableArray*)modify:(Note*)model {
    NoteDAO* dao = [NoteDAO shareManager];
    [dao modify:model];
    
    return [dao findAll];
}

@end
