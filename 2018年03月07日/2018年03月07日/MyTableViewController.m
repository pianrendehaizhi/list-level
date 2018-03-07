//
//  MyTableViewController.m
//  2018年03月07日
//
//  Created by BiShuai on 2018/3/7.
//  Copyright © 2018年 BiShuai. All rights reserved.
//

#import "MyTableViewController.h"
#import "MyModel.h"

@interface MyTableViewController ()

@property (nonatomic, strong) NSMutableArray <MyModel *>* dataArray;

@end

@implementation MyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
}

- (void)loadData {
    dispatch_async(dispatch_queue_create(0, 0), ^{
        if (!self.dataArray) {
            self.dataArray = [NSMutableArray array];
        }
        for (int i = 1; i < 5; i++) {
            MyModel *model = [[MyModel alloc] init];
            model.title = [NSString stringWithFormat:@"%d", i];
            model.level = 0;
            model.haveSubLevel = YES;
            model.expand = NO;
            [self.dataArray addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell" forIndexPath:indexPath];
    
    MyModel *model = self.dataArray[indexPath.row];
    NSString *str1 = model.expand ? @"- " : @"+ ";
    cell.textLabel.text = [(model.haveSubLevel ? str1 : @"") stringByAppendingString:model.title];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"第 %ld 级", model.level];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.dataArray[indexPath.row].level;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self expandWithIndexPath:indexPath];
}

- (void)expandWithIndexPath:(NSIndexPath *)indexPath {
    MyModel *model = self.dataArray[indexPath.row];
    NSMutableArray *tempArray = [NSMutableArray array];
    [self.tableView beginUpdates];
    if (!model.expand) {
        for (int i = 1; i < 5; i++) {
            MyModel *tempModel = [[MyModel alloc] init];
            tempModel.title = [model.title stringByAppendingString:[NSString stringWithFormat:@"-%d", i]];
            tempModel.level = model.level + 1;
            tempModel.haveSubLevel = YES;
            tempModel.expand = NO;
            [self.dataArray insertObject:tempModel atIndex:(indexPath.row + i)];
            [tempArray addObject:[NSIndexPath indexPathForRow:(indexPath.row + i) inSection:indexPath.section]];
        }
        [self.tableView insertRowsAtIndexPaths:tempArray withRowAnimation:UITableViewRowAnimationTop];
    } else {
        NSUInteger index = indexPath.row;
        NSUInteger total = self.dataArray.count;
        while (model.level < self.dataArray[indexPath.row + 1].level) {
            [self.dataArray removeObjectAtIndex:indexPath.row + 1];
            [tempArray addObject:[NSIndexPath indexPathForRow:++index inSection:0]];
            if (total <= (index + 1)) {
                break;
            }
        }
        [self.tableView deleteRowsAtIndexPaths:tempArray withRowAnimation:UITableViewRowAnimationTop];
    }
    model.expand = !model.expand;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
}

@end
