//
//  MemoTableViewController.m
//  MemoPractice
//
//  Created by BlackApple on 2017/7/8.
//  Copyright © 2017年 BlackApple. All rights reserved.
//

#import "MemoTableViewController.h"
#import "NoteManage.h"
#import "EditViewController.h"

@interface MemoTableViewController ()

@property(nonatomic, strong)NSMutableArray* listData;

@end

@implementation MemoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.listData = [NoteManage findAll];
    //NSLog(@"tableViewDidLoad");
    //设置单元格编辑按钮
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    //注册消息通知,当有笔记更新时，更新listdata,tableView
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateTableView) name:@"updateData" object:nil];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    NSLog(@"tableViewDidsappear");
}

//更新表视图
-(void)updateTableView {
    NSLog(@"updateTableView");
    self.listData = [NoteManage findAll];
    [self.tableView reloadData];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listData.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemoTableViewCell" forIndexPath:indexPath];
    //设置单元格内容
    Note* note = self.listData[indexPath.row];
    cell.textLabel.text = note.content;
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm"];
    cell.detailTextLabel.text = [dateFormatter stringFromDate:note.date];
    
    return cell;
}


// Override to support conditional editing of the table view.
/*
-(void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
}
 */
//设置具体单元格可以编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    //NSLog(@"enter to edit");
    return YES;
}
//设置单元格编辑格式
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
//设置单元格响应事件
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [NoteManage remove:self.listData[indexPath.row]];   //从数据库中删除
        [self.listData removeObjectAtIndex:indexPath.row];  //从列表中删除
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];//从表视图中删除
        
    }/*else if (editingStyle == UITableViewCellEditingStyleInsert) {
        
    }
    */
    [self.tableView reloadData];
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    EditViewController* editViewCrl = (EditViewController*)[[segue destinationViewController]topViewController];
    NSLog(@"%@", editViewCrl.class);
    if([segue.identifier isEqualToString: @"Detail"]){//显示详情
        editViewCrl.viewType = Detail;
        editViewCrl.myNote = self.listData[[self.tableView indexPathForSelectedRow].row];
        editViewCrl.title = @"EditNote";
    }else if([segue.identifier isEqualToString:@"Add"]){//新增记录
        editViewCrl.viewType = Add;
        editViewCrl.myNote = nil;
        editViewCrl.title = @"NewNote";
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
