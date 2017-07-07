//
//  NoteDAO.m
//  MemoPractice
//
//  Created by BlackApple on 2017/7/7.
//  Copyright © 2017年 BlackApple. All rights reserved.
//

#import "NoteDAO.h"

@implementation NoteDAO

static NoteDAO* shareDAO = nil;//全局的DAO


//实例方法，全局返回一个单例DAO
+(NoteDAO*)shareManager {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
        shareDAO = [[self alloc]init];
        //添加数据
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-M-dd HH:mm:ss"];
        
        NSDate* date1 = [dateFormatter dateFromString:@"2011-11-11 11:11:11"];
        Note* note1 = [[Note alloc]initWithDate:date1 content:@"first Note"];
        
        shareDAO.listData  = [[NSMutableArray alloc]init];
        [shareDAO.listData addObject:note1];
    });
    return shareDAO;
}
//插入
-(int)creat:(Note*)note {
    [self.listData addObject:note];
    return 0;
}
//删除
-(int)remove:(Note*)note {
    for(Note* listNote in self.listData) {
        if([listNote.date isEqualToDate:note.date])
        {
            [self.listData removeObject:listNote];
            break;
        }
    }
    return 0;
}
//修改
-(int)modify:(Note*)note {
    
    for(Note* listNote in self.listData) {
        if([listNote.date isEqualToDate:note.date])
        {
            listNote.content = note.content;
            break;
        }
    }
    return 0;
}
//查询
-(NSMutableArray*)findAll {
    return self.listData;
}
//主键查询
-(Note*)findById:(Note*)note {
    
    for(Note* listNote in self.listData) {
        if(listNote.date == note.date)
        {
            return listNote;
        }
    }
    return nil;
}

@end
