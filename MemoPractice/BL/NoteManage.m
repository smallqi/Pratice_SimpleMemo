//
//  NoteManage.m
//  MemoPractice
//
//  Created by BlackApple on 2017/7/7.
//  Copyright © 2017年 BlackApple. All rights reserved.
//

#import "NoteManage.h"
#import "NoteDAO.h"
#import "NoteDAO_Encode.h"

@implementation NoteManage

//插入
+(NSMutableArray*)createNote:(Note*)model {
    //plist
    //NoteDAO* dao = [NoteDAO shareManager];
    //[dao creat:model];
    //序列化
    NoteDAO_Encode* dao = [NoteDAO_Encode shareManager];
    [dao creat:model];
    
    return [dao findAll];
}
//删除
+(NSMutableArray*)remove:(Note*)model {
    //plist
    //NoteDAO* dao = [NoteDAO shareManager];
    //[dao remove:model];
    //序列化
    NoteDAO_Encode* dao = [NoteDAO_Encode shareManager];
    [dao remove:model];
    
    return [dao findAll];

}
//查询
+(NSMutableArray*)findAll {
    //plist
    //NoteDAO* dao = [NoteDAO shareManager];
    //return [dao findAll];
    //序列化
    NoteDAO_Encode * dao = [NoteDAO_Encode shareManager];
    return [dao findAll];

}
//修改
+(NSMutableArray*)modify:(Note*)model {
    //plist
    //NoteDAO* dao = [NoteDAO shareManager];
    //[dao modify:model];
    //序列化
    NoteDAO_Encode* dao = [NoteDAO_Encode shareManager];
    [dao modify:model];
    
    return [dao findAll];
}

@end
