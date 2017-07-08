//
//  EditViewController.m
//  MemoPractice
//
//  Created by BlackApple on 2017/7/8.
//  Copyright © 2017年 BlackApple. All rights reserved.
//

#import "EditViewController.h"

@interface EditViewController ()

@property (weak, nonatomic) IBOutlet UITextView *editView;

@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //显示详情页面
    if(self.viewType == Detail){
        self.editView.text = self.myNote.content;
    }else if(self.viewType == Add) {//添加记录页面
        self.editView.text = @"Edit here...";
        self.myNote = [[Note alloc]init];
    }
    self.automaticallyAdjustsScrollViewInsets = NO;//从顶部开始
    
    //注册警告框消息通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(leaveWithoutSave) name:@"leaveWithoutSave" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(saveClick:) name:@"leaveWithSave" object:nil];
    
    // Do any additional setup after loading the view.
}

-(void)viewDidDisappear:(BOOL)animated{
    //取消注册
    //NSLog(@"disAppear");
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backClick:(id)sender {
    NSLog(@"backClick");
    //修改尚未保存
    BOOL contentIsChange = ((self.viewType == Detail) && ![self.editView.text isEqualToString:self.myNote.content]);
    if(contentIsChange || self.viewType == Add){
        //警告框提示是否保存
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Warning" message:@"leave without save?" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
            [[NSNotificationCenter defaultCenter]postNotificationName:@"leaveWithoutSave" object:nil userInfo:nil];
        }];
        [alertController addAction:yes];
        
        UIAlertAction* save = [UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
            [[NSNotificationCenter defaultCenter]postNotificationName:@"leaveWithSave" object:nil userInfo:nil];
        }];
        [alertController addAction:save];
        
        [self presentViewController:alertController animated:TRUE completion:nil];
    }else {
        [self leaveWithoutSave];
    }
}

//不保存直接返回
-(void)leaveWithoutSave{
    NSLog(@"withoutsave");
    //返回
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

//点击保存后返回
- (IBAction)saveClick:(id)sender {
    NSLog(@"save...");
    //更新note
    self.myNote.content = self.editView.text;
    self.myNote.date = [[NSDate alloc]init];
    //保存
    if(self.viewType == Detail) {//修改
        [NoteManage modify:self.myNote];
    }else if(self.viewType == Add) {//添加
        [NoteManage createNote:self.myNote];
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"updateData" object:nil userInfo:nil];
    //返回
    [self dismissViewControllerAnimated:TRUE completion:nil];
}


#pragma mark - Navigation
/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"leave editView");
    
}
*/

@end
