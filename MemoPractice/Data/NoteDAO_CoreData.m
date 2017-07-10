//
//  NoteDAO_CoreData.m
//  MemoPractice
//
//  Created by BlackApple on 2017/7/10.
//  Copyright © 2017年 BlackApple. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "NoteDAO_CoreData.h"
#import "NoteManagedObject+CoreDataClass.h"

@interface NoteDAO_CoreData() //声明NoteDAO扩展

//NoteDAO扩展中DateFormatter属性是私有的
@property (nonatomic,strong) NSDateFormatter *dateFormatter;

@end

@implementation NoteDAO_CoreData

static NoteDAO_CoreData *sharedSingleton = nil;

+ (NoteDAO_CoreData *)shareManager {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
        sharedSingleton = [[self alloc] init];
        
        //初始化DateFormatter
        sharedSingleton.dateFormatter = [[NSDateFormatter alloc] init];
        [sharedSingleton.dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
    });
    return sharedSingleton;
}

//插入Note方法
- (int)creat:(Note *)model {
    //获得上下文
    NSManagedObjectContext* context = [self managedObjectContext];
    //新增一个实体实例
    NoteManagedObject* object = [NSEntityDescription insertNewObjectForEntityForName:@"Note" inManagedObjectContext:context];
    object.date = model.date;
    object.content = model.content;
    //保存
    [self saveContext];
    
    return 0;
}

//删除Note方法
- (int)remove:(Note *)model {
    //获得上下文
    NSManagedObjectContext* context = [self managedObjectContext];
    //获得实体
    NSEntityDescription* entityDescription = [NSEntityDescription entityForName:@"Note" inManagedObjectContext:context];
    //创建一个请求
    NSFetchRequest* request = [[NSFetchRequest alloc]init];
    [request setEntity:entityDescription];
    //设置请求获得的数据过滤条件
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"date = %@", model.date];
    request.predicate = predicate;
    //获得数据
    NSError* error = nil;
    NSArray* listData = [context executeFetchRequest:request error:&error];
    //删除数据
    if(error == nil && listData.count > 0){
        [self.managedObjectContext deleteObject:[listData lastObject]];
        //保存数据
        [self saveContext];
    }
    return 0;
}

//修改Note方法
- (int)modify:(Note *)model {
    //获得上下文
    NSManagedObjectContext* context = [self managedObjectContext];
    //获得实体
    NSEntityDescription* entityDescription = [NSEntityDescription entityForName:@"Note" inManagedObjectContext:context];
    //创建一个请求
    NSFetchRequest* request = [[NSFetchRequest alloc]init];
    [request setEntity:entityDescription];
    //设置请求获得的数据过滤条件
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"date = %@", model.date];
    request.predicate = predicate;
    //获得数据
    NSError* error = nil;
    NSArray* listData = [context executeFetchRequest:request error:&error];
    //修改数据
    if(error == nil && listData.count > 0){
        NoteManagedObject* note = [listData lastObject];
        note.content = model.content;
        //保存数据
        [self saveContext];
    }
    return 0;
}

//查询所有数据方法
- (NSMutableArray *)findAll {
    
    //获得上下文
    NSManagedObjectContext* context = [self managedObjectContext];
    //获得实体
    NSEntityDescription* entityDescription = [NSEntityDescription entityForName:@"Note" inManagedObjectContext:context];
    //创建一个请求
    NSFetchRequest* request = [[NSFetchRequest alloc]init];
    [request setEntity:entityDescription];
    //获得数据
    NSError* error = nil;
    NSArray* listData = [context executeFetchRequest:request error:&error];
    if(error != nil)
        return nil;
    //类型转换
    NSMutableArray* array = [[NSMutableArray alloc]init];
    for(NoteManagedObject* tempNote in listData){
        Note* note = [[Note alloc]initWithDate:tempNote.date content:tempNote.content];
        [array addObject:note];
    }
    return array;
}

//按照主键查询数据方法
- (Note *)findById:(Note *)model {
    
    //获得上下文
    NSManagedObjectContext* context = [self managedObjectContext];
    //获得实体
    NSEntityDescription* entityDescription = [NSEntityDescription entityForName:@"Note" inManagedObjectContext:context];
    //创建一个请求
    NSFetchRequest* request = [[NSFetchRequest alloc]init];
    [request setEntity:entityDescription];
    //设置请求获得的数据过滤条件
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"date = %@", model.date];
    request.predicate = predicate;
    //获得数据
    NSError* error = nil;
    NSArray* listData = [context executeFetchRequest:request error:&error];
    //修改数据
    if(error == nil && listData.count > 0){
        NoteManagedObject* tempNote = [listData lastObject];
        Note* note = [[Note alloc]initWithDate:tempNote.date content:tempNote.content];
        return note;
    }
    return nil;
}


@end

