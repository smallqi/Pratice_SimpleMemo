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

@end
