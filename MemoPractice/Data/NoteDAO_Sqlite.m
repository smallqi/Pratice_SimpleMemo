//
//  NoteDAO_Sqlite.m
//  MemoPractice
//
//  Created by BlackApple on 2017/7/9.
//  Copyright © 2017年 BlackApple. All rights reserved.
//

#import "NoteDAO_Sqlite.h"
#import "sqlite3.h"

#define FILE_NAME @"NoteList.db"

@interface NoteDAO_Sqlite()
{
    sqlite3 *db;
}

@property(strong, nonatomic)NSDateFormatter* dateFormatter;//转换date 2 strin
@property(strong, nonatomic)NSString* plistPath;    //属性列表文件的路径

@end

@implementation NoteDAO_Sqlite

static NoteDAO_Sqlite* shareDAO = nil;//全局的DAO

//实例方法，全局返回一个单例DAO
+(NoteDAO_Sqlite*)shareManager {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
        shareDAO = [[self alloc]init];
        
        //获得沙盒中list文件的路径
        NSString* documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, TRUE) lastObject];
        shareDAO.plistPath = [documentPath stringByAppendingPathComponent:FILE_NAME];
        
        //初始化数据库
        [shareDAO initData];
        
        //设置formatter
        shareDAO.dateFormatter = [[NSDateFormatter alloc]init];
        [shareDAO.dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
    });
    return shareDAO;
}
-(void)initData {
    //打开数据库
    const char* cpath = [self.plistPath UTF8String];
    if(sqlite3_open(cpath, &db) != SQLITE_OK) {
        NSLog(@"db open fail");
    }else {//创建表语句
        NSString* sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS Note (cdate TEXT PRIMARY KEY, content TEXT);"];
        const char* cSql = [sql UTF8String];
        if(sqlite3_exec(db, cSql, NULL, NULL, NULL) != SQLITE_OK)
            NSLog(@"table Note creat fail");
    }
    sqlite3_close(db);
}
//插入
-(int)creat:(Note*)note {
    //打开数据库
    const char* cPath = [self.plistPath UTF8String];
    if(sqlite3_open(cPath, &db) != SQLITE_OK){
        NSLog(@"db open fail");
    }else {
        NSString* sql = @"INSERT OR REPLACE INTO Note(cdate, content) VALUES (?,?)";
        const char* cSql = [sql UTF8String];
        
        //预处理语句
        sqlite3_stmt* statement;
        if(sqlite3_prepare_v2(db, cSql, -1, &statement, NULL) == SQLITE_OK){
            NSString* tempStrDate = [self.dateFormatter stringFromDate:note.date];
            const char* tempCDate = [tempStrDate UTF8String];
            
            const char* tempCContent = [note.content UTF8String];
            //加载参数
            sqlite3_bind_text(statement, 1, tempCDate, -1, NULL);
            sqlite3_bind_text(statement, 2, tempCContent, -1, NULL);
            //执行
            if(sqlite3_step(statement) != SQLITE_DONE)
                NSLog(@"creat fail");
        }
        //释放
        sqlite3_finalize(statement);
    }
    sqlite3_close(db);
    return 0;
}
//删除
-(int)remove:(Note*)note {
    //打开数据库
    const char* cPath = [self.plistPath UTF8String];
    if(sqlite3_open(cPath, &db) != SQLITE_OK){
        NSLog(@"db open fail");
    }else {
        NSString* sql = @"DELETE FROM Note where cdate = ?";
        const char* cSql = [sql UTF8String];
        
        //预处理语句
        sqlite3_stmt* statement;
        if(sqlite3_prepare_v2(db, cSql, -1, &statement, NULL) == SQLITE_OK){
            NSString* tempStrDate = [self.dateFormatter stringFromDate:note.date];
            const char* tempCDate = [tempStrDate UTF8String];
            //加载参数
            sqlite3_bind_text(statement, 1, tempCDate, -1, NULL);
            //执行
            if(sqlite3_step(statement) != SQLITE_DONE)
                NSLog(@"Delete fail");
        }
        //释放
        sqlite3_finalize(statement);
    }
    sqlite3_close(db);
    return 0;
}
//修改
-(int)modify:(Note*)note {
    //打开数据库
    const char* cPath = [self.plistPath UTF8String];
    if(sqlite3_open(cPath, &db) != SQLITE_OK){
        NSLog(@"db open fail");
    }else {
        NSString* sql = @"UPDATE Note SET content =? where cdate =?";
        const char* cSql = [sql UTF8String];
        
        //预处理语句
        sqlite3_stmt* statement;
        if(sqlite3_prepare_v2(db, cSql, -1, &statement, NULL) == SQLITE_OK){
            NSString* tempStrDate = [self.dateFormatter stringFromDate:note.date];
            const char* tempCDate = [tempStrDate UTF8String];
            
            const char* tempCContent = [note.content UTF8String];
            //加载参数
            sqlite3_bind_text(statement, 1, tempCContent, -1, NULL);
            sqlite3_bind_text(statement, 2, tempCDate, -1, NULL);
            
            //执行
            if(sqlite3_step(statement) != SQLITE_DONE)
                NSLog(@"UpDate fail");
        }
        //释放
        sqlite3_finalize(statement);
    }
    sqlite3_close(db);
    return 0;}
//查询
-(NSMutableArray*)findAll {
    //打开数据库
    const char* cpath = [self.plistPath UTF8String];
    if(sqlite3_open(cpath, &db) == SQLITE_OK) {
        NSString* sql = @"SELECT cdate, content FROM Note";
        const char* cSql = [sql UTF8String];
        //预处理
        sqlite3_stmt* statement;
        if(sqlite3_prepare_v2(db, cSql, -1, &statement, NULL) == SQLITE_OK){
            NSMutableArray* listData = [[NSMutableArray alloc]init];
            //执行查询语句
            while (sqlite3_step(statement) == SQLITE_ROW) {
                char* tempCDate = (char*)sqlite3_column_text(statement, 0);
                NSString* tempStrDate = [[NSString alloc]initWithUTF8String:tempCDate];
                NSDate* date = [self.dateFormatter dateFromString:tempStrDate];
                
                char* tempCContent = (char*)sqlite3_column_text(statement, 1);
                NSString* tempStrContent = [[NSString alloc]initWithUTF8String:tempCContent];
                
                Note* note = [[Note alloc]initWithDate:date content:tempStrContent];
                [listData addObject:note];
            }
            //释放语句
            sqlite3_finalize(statement);
            //释放数据库
            sqlite3_close(db);
            return listData;
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(db);
    return nil;
}
//主键查询
-(Note*)findById:(Note*)note {
    
    const char* cpath = [self.plistPath UTF8String];
    if(sqlite3_open(cpath, &db) != SQLITE_OK){
        NSLog(@"db open fail");
    }else {
        //查询表语句
        NSString* sql = @"SELECT cdate, content FROM Note where cdate = ?";
        const char* cSql = [sql UTF8String];
        //语句对象
        sqlite3_stmt* statement;
        //预处理
        if(sqlite3_prepare_v2(db, cSql, -1, &statement, NULL) == SQLITE_OK) {
            NSString* strDate = [self.dateFormatter stringFromDate:note.date];
            const char* cDate = [strDate UTF8String];
            //绑定参数
            sqlite3_bind_text(statement, 1, cDate, -1, NULL);
            //执行查询
            if(sqlite3_step(statement) == SQLITE_ROW) {
                char* resCDate = (char*) sqlite3_column_text(statement, 0);
                NSString* resStrDate = [[NSString alloc]initWithUTF8String:resCDate];
                NSDate* resDate = [self.dateFormatter dateFromString:resStrDate];
                
                char* resCContent = (char*) sqlite3_column_text(statement, 1);
                NSString* resContent = [[NSString alloc]initWithUTF8String:resCContent];
                
                Note* resNote = [[Note alloc]initWithDate:resDate content:resContent];
                //释放语句
                sqlite3_finalize(statement);
                //关闭数据库
                sqlite3_close(db);
                
                return resNote;
            }
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(db);
    return nil;
}
@end
