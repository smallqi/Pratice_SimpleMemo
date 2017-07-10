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
#import "NoteDAO_Sqlite.h"
#import "NoteDAO_CoreData.h"

#define  dataType 4

@implementation NoteManage

//插入
+(NSMutableArray*)createNote:(Note*)model {
    if(dataType == 1) {
        //plist
        NoteDAO* dao = [NoteDAO shareManager];
        [dao creat:model];
        return [dao findAll];

    }else if(dataType == 2){
        //序列化
        NoteDAO_Encode* dao = [NoteDAO_Encode shareManager];
        [dao creat:model];
        return [dao findAll];
    }else if(dataType == 3){
        //sqlite
        NoteDAO_Sqlite* dao = [NoteDAO_Sqlite shareManager];
        [dao creat:model];
        return [dao findAll];
    }else if(dataType == 4){
        NoteDAO_CoreData* dao = [NoteDAO_CoreData shareManager];
        [dao creat:model];
        return [dao findAll];
    }
    
    
}
//删除
+(NSMutableArray*)remove:(Note*)model {
    if(dataType == 1) {
        //plist
        NoteDAO* dao = [NoteDAO shareManager];
        [dao remove:model];
        return [dao findAll];
        
    }else if(dataType == 2){
        //序列化
        NoteDAO_Encode* dao = [NoteDAO_Encode shareManager];
        [dao remove:model];
        return [dao findAll];
    }else if(dataType == 3){
        //sqlite
        NoteDAO_Sqlite* dao = [NoteDAO_Sqlite shareManager];
        [dao remove:model];
        return [dao findAll];
    }else if(dataType == 4){
        NoteDAO_CoreData* dao = [NoteDAO_CoreData shareManager];
        [dao remove:model];
        return [dao findAll];
    }

}
//查询
+(NSMutableArray*)findAll {
    if(dataType == 1) {
        //plist
        NoteDAO* dao = [NoteDAO shareManager];
        return [dao findAll];
        
    }else if(dataType == 2){
        //序列化
        NoteDAO_Encode* dao = [NoteDAO_Encode shareManager];
        return [dao findAll];
    }else if(dataType == 3){
        //sqlite
        NoteDAO_Sqlite* dao = [NoteDAO_Sqlite shareManager];
        return [dao findAll];
    }else if(dataType == 4){
        NoteDAO_CoreData* dao = [NoteDAO_CoreData shareManager];
        return [dao findAll];
    }

}
//修改
+(NSMutableArray*)modify:(Note*)model {
    if(dataType == 1) {
        //plist
        NoteDAO* dao = [NoteDAO shareManager];
        [dao modify:model];
        return [dao findAll];
        
    }else if(dataType == 2){
        //序列化
        NoteDAO_Encode* dao = [NoteDAO_Encode shareManager];
        [dao modify:model];
        return [dao findAll];
    }else if(dataType == 3){
        //sqlite
        NoteDAO_Sqlite* dao = [NoteDAO_Sqlite shareManager];
        [dao modify:model];
        return [dao findAll];
    }else if(dataType == 4){
        NoteDAO_CoreData* dao = [NoteDAO_CoreData shareManager];
        [dao modify:model];
        return [dao findAll];
    }
}

@end
