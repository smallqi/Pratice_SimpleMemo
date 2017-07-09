//
//  Note.m
//  MemoPractice
//
//  Created by BlackApple on 2017/7/7.
//  Copyright © 2017年 BlackApple. All rights reserved.
//

#import "Note.h"

@implementation Note

-(instancetype)initWithDate:(NSDate *)date content:(NSString *)content {
    self = [super init];
    if(self) {
        self.date = date;
        self.content = content;
    }
    return self;
}

-(instancetype)init {
    self = [super init];
    if(self) {
        self.date = [[NSDate alloc]init];
        self.content = @"";
    }
    return self;
}
//对象归档方法
#pragma mark - NSCoding
//序列化对象
-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.date forKey:@"date"];
    [aCoder encodeObject:self.content forKey:@"content"];
}
//反序列化对象
-(id)initWithCoder:(NSCoder *)aDecoder{
    self.date = [aDecoder decodeObjectForKey:@"date"];
    self.content = [aDecoder decodeObjectForKey:@"content"];
    return self;
}
@end
