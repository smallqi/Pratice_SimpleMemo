//
//  NoteDAO.m
//  MemoPractice
//
//  Created by BlackApple on 2017/7/7.
//  Copyright © 2017年 BlackApple. All rights reserved.
//

#import "NoteDAO.h"

@interface NoteDAO()

@property(strong, nonatomic)NSDateFormatter* dateFormatter;//转换date 2 strin
@property(strong, nonatomic)NSString* plistPath;    //属性列表文件的路径
@property(strong, nonatomic)NSMutableArray* listData;  //数据库在内存中的临时数据,单元为字典

@end

@implementation NoteDAO

static NoteDAO* shareDAO = nil;//全局的DAO


//实例方法，全局返回一个单例DAO
+(NoteDAO*)shareManager {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
        shareDAO = [[self alloc]init];
        
        //获得沙盒中list文件的路径
        NSString* documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, TRUE) lastObject];
        shareDAO.plistPath = [documentPath stringByAppendingPathComponent:@"Note.plist"];
        
        //如果文件不存在则复制资源文件进行创建
        NSFileManager* fileManager = [NSFileManager defaultManager];
        if(![fileManager fileExistsAtPath:shareDAO.plistPath]){
            //获取工程资源Note.plist的路径
            NSBundle* frameWorkBundle = [NSBundle bundleForClass:[NoteDAO class]];//在应用下用mainBundle创建
                                                                                    //在框架下，由于编译和运行环境的不同，采用类方式创建
            NSString* sourcePath = [[frameWorkBundle resourcePath]stringByAppendingPathComponent:@"Note.plist"];
            //复制文件
            NSError* error;
            BOOL success = [fileManager copyItemAtPath:sourcePath toPath:shareDAO.plistPath error:&error];
            NSAssert(success, @"文件复制失败");
            
        }
        
        //设置formatter
        shareDAO.dateFormatter = [[NSDateFormatter alloc]init];
        [shareDAO.dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        //获取数据
        shareDAO.listData = [[NSMutableArray alloc]initWithContentsOfFile:shareDAO.plistPath];
    });
    return shareDAO;
}
//将内存暂存的数据写入文件
-(void)writeToDataBase {
    [shareDAO.listData writeToFile:shareDAO.plistPath atomically:TRUE];
}
//插入
-(int)creat:(Note*)note {
    //日期转为string
    NSString* date = [shareDAO.dateFormatter stringFromDate:note.date];
    NSDictionary* dic = @{@"date":date, @"content":note.content};
    [shareDAO.listData addObject:dic];
    [shareDAO writeToDataBase];
    return 0;
}
//删除
-(int)remove:(Note*)note {
    
    for(NSDictionary* dict in self.listData) {
        NSDate* date = [shareDAO.dateFormatter dateFromString:dict[@"date"]];
        if([date isEqualToDate:note.date])
        {
            [shareDAO.listData removeObject:dict];
            [shareDAO writeToDataBase];
            break;
        }
    }
    
    return 0;
}
//修改
-(int)modify:(Note*)note {
    
    for(NSDictionary* dict in self.listData) {
        NSDate* date = [shareDAO.dateFormatter dateFromString:dict[@"date"]];
        if([date isEqualToDate:note.date])
        {
            [dict setValue:note.content forKey:@"content"];
            [shareDAO writeToDataBase];
            break;
        }
    }
    return 0;
}
//查询
-(NSMutableArray*)findAll {
    
    NSMutableArray* notes = [[NSMutableArray alloc]init];
    
    for(NSDictionary* dict in shareDAO.listData) {
        NSString* temp = dict[@"date"];
        NSDate* tempDate = [shareDAO.dateFormatter dateFromString:temp];
        NSString* tempContent = dict[@"content"];
        
        Note* note = [[Note alloc]initWithDate:tempDate content:tempContent];
        
        [notes addObject:note];
    }
    return notes;
}
//主键查询
-(Note*)findById:(Note*)note {
    
    for(NSDictionary* dict in self.listData) {
        NSDate* date = [shareDAO.dateFormatter dateFromString:dict[@"date"]];
        if([date isEqualToDate:note.date])
        {
            NSString* content = dict[@"content"];
            Note* note = [[Note alloc]initWithDate:date content:content];
            return note;
        }
    }
    return nil;
}

@end
