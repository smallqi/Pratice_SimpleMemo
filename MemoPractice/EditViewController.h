//
//  EditViewController.h
//  MemoPractice
//
//  Created by BlackApple on 2017/7/8.
//  Copyright © 2017年 BlackApple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteManage.h"

enum editType{
    Detail, //详情
    Add //新增
};
@interface EditViewController : UIViewController

@property enum editType viewType;
@property (strong, nonatomic)Note* myNote;

@end
