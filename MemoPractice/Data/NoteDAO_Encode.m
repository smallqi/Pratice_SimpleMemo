//
//  NoteDAO_Encode.m
//  MemoPractice
//
//  Created by BlackApple on 2017/7/9.
//  Copyright © 2017年 BlackApple. All rights reserved.
//

#import "NoteDAO_Encode.h"

#define FILE_NAME @"NoteList.archive"
#define ARCHIVE_KEY @"NoteList"

@interface NoteDAO_Encode()

@property(strong, nonatomic)NSDateFormatter* dateFormatter;//转换date 2 strin
@property(strong, nonatomic)NSString* plistPath;    //属性列表文件的路径
@property(strong, nonatomic)NSMutableArray* listData;  //数据库在内存中的临时数据,note数组

@end

@implementation NoteDAO_Encode

static NoteDAO_Encode* shareDAO = nil;//全局的DAO

//实例方法，全局返回一个单例DAO
+(NoteDAO_Encode*)shareManager {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
        shareDAO = [[self alloc]init];
        
        //获得沙盒中list文件的路径
        NSString* documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, TRUE) lastObject];
        shareDAO.plistPath = [documentPath stringByAppendingPathComponent:FILE_NAME];
        
        //如果文件不存在则进行创建
        NSFileManager* fileManager = [NSFileManager defaultManager];
        if(![fileManager fileExistsAtPath:shareDAO.plistPath]){
            
            NSDate* date1 = [[NSDate alloc]init];
            Note* note1 = [[Note alloc]initWithDate:date1 content:@"Example Note"];
            NSMutableArray* array = [[NSMutableArray alloc]init];
            [array addObject:note1];
            
            NSMutableData* data = [NSMutableData data];
            NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
            [archiver encodeObject:array forKey:ARCHIVE_KEY];
            [archiver finishEncoding];
            
            [data writeToFile:shareDAO.plistPath atomically:TRUE];
        }
        
        //设置formatter
        shareDAO.dateFormatter = [[NSDateFormatter alloc]init];
        [shareDAO.dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        //获取数据
        [shareDAO getDataFromFile];
    });
    return shareDAO;
}
//从文件中获取数据
-(void)getDataFromFile {
    
    NSData* data = [NSData dataWithContentsOfFile:shareDAO.plistPath];
    if([data length] > 0) {
        NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
        self.listData = [unarchiver decodeObjectForKey:ARCHIVE_KEY];
    }
}
//将内存暂存的数据写入文件
-(void)writeToDataBase {
    NSMutableData* data = [NSMutableData data];
    NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiver encodeObject:self.listData forKey:ARCHIVE_KEY];
    [archiver finishEncoding];
    
    [data writeToFile:self.plistPath atomically:TRUE];
}
//插入
-(int)creat:(Note*)note {
    
    [self.listData addObject:note];
    [self writeToDataBase];
    return 0;
}
//删除
-(int)remove:(Note*)note {
    
    for(Note* tNote in self.listData) {
        if([tNote.date isEqualToDate:note.date])
        {
            [self.listData removeObject:tNote];
            [self writeToDataBase];
            return 0;
        }
    }
    return 1;
}
//修改
-(int)modify:(Note*)note {
    
    for(Note* tNote in self.listData) {
        if([tNote.date isEqualToDate:note.date])
        {
            tNote.content = note.content;
            [self writeToDataBase];
            break;
        }
    }
    return 0;
}
//查询
-(NSMutableArray*)findAll {
    NSMutableArray* array = [NSMutableArray arrayWithArray:self.listData];
    return array;
}
//主键查询
-(Note*)findById:(Note*)note {
    
    for(Note* tNote in self.listData) {
        if([tNote.date isEqualToDate:note.date])
        {
            Note* newNote = [[Note alloc]initWithDate:tNote.date content:tNote.content];
            return newNote;
        }
    }
    return nil;
}

@end
