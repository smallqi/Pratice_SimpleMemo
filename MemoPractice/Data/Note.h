//
//  Note.h
//  MemoPractice
//
//  Created by BlackApple on 2017/7/7.
//  Copyright © 2017年 BlackApple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Note : NSObject<NSCoding>

@property(nonatomic, strong)NSDate* date;
@property(nonatomic, strong)NSString* content;

-(instancetype)initWithDate:(NSDate*)date content:(NSString*)content;
-(instancetype)init;

@end
