//
//  VideoListVC.m
//  IFPlayer
//
//  Created by Xuqigang on 2018/9/11.
//  Copyright © 2018年 凤凰新媒体. All rights reserved.
//

#import "VideoListVC.h"
#import "VideoCell.h"

@interface VideoListVC ()<UITableViewDelegate,UITableViewDataSource,VideoCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *tableViewDataSource;
@end

@implementation VideoListVC

+ (instancetype)instanceFromNib{
    return [[self alloc] initWithNibName:NSStringFromClass([self class]) bundle:[NSBundle mainBundle]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupDataSource];
    [self setupUI];
    [self.tableView reloadData];

}

- (void)setupUI{
    self.navigationItem.title = @"视频列表";
    self.tableView.estimatedRowHeight = 500;
    self.tableView.rowHeight = 200;
    UINib *cellNib = [UINib nibWithNibName:@"VideoCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"VideoCell"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
}

- (void)setupDataSource{
    self.tableViewDataSource = [NSMutableArray arrayWithCapacity:1];
    VideoModel *model1 = [[VideoModel alloc] init];
    model1.title = @"";
    model1.des = @"";
    model1.videoUrl = @"http://ips.ifeng.com/video19.ifeng.com/video09/2017/11/13/13898978-102-009-193912.mp4";
    VideoModel *model2 = [[VideoModel alloc] init];
    model2.title = @"";
    model2.des = @"";
    model2.videoUrl = @"http://ips.ifeng.com/video19.ifeng.com/video09/2017/11/13/13855425-102-009-075213.mp4";
    VideoModel *model3 = [[VideoModel alloc] init];
    model3.title = @"";
    model3.des = @"";
    model3.videoUrl = @"http://ips.ifeng.com/video19.ifeng.com/video09/2017/11/13/13862828-102-009-101313.mp4";
    VideoModel *model4 = [[VideoModel alloc] init];
    model4.title = @"";
    model4.des = @"";
    model4.videoUrl = @"http://ips.ifeng.com/video19.ifeng.com/video09/2017/11/13/13868713-102-009-123413.mp4";
    VideoModel *model5 = [[VideoModel alloc] init];
    model5.title = @"";
    model5.des = @"";
    model5.videoUrl = @"http://ips.ifeng.com/video19.ifeng.com/video09/2017/11/12/13827583-102-009-173712.mp4";
    VideoModel *model6 = [[VideoModel alloc] init];
    model6.title = @"";
    model6.des = @"";
    model6.videoUrl = @"http://ips.ifeng.com/video19.ifeng.com/video09/2017/11/13/13884783-102-009-145519.mp4";
    [self.tableViewDataSource addObject:model1];
    [self.tableViewDataSource addObject:model2];
    [self.tableViewDataSource addObject:model3];
    [self.tableViewDataSource addObject:model4];
    [self.tableViewDataSource addObject:model5];
    [self.tableViewDataSource addObject:model6];
   
}
#pragma mark - UITableViewDataSource
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath NS_AVAILABLE_IOS(6_0){
    
    //当cell从界面消失的时候，自动停止视频播放
    VideoCell * videoCell = (VideoCell*)cell;
    [videoCell stopVideo];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableViewDataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VideoCell * cell ;
    cell = (VideoCell*)[tableView dequeueReusableCellWithIdentifier:@"VideoCell"];
    if (self.tableViewDataSource.count > indexPath.row) {
        [cell setupCell:self.tableViewDataSource[indexPath.row]];
        cell.delegate = self;
    } else {
        [cell setupCell:nil];
        cell.delegate = nil;
    }
    return cell;
}
#pragma mark VideoCellDelegate
- (void)videoCell:(VideoCell*)videoCell didVideoStateChanged:(BOOL)isPlay{
    //用户点击播放按钮时，关闭掉其它cell上的视频
    NSArray <VideoCell*> *cells = [self.tableView visibleCells];
    [cells enumerateObjectsUsingBlock:^(VideoCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (videoCell != obj){
            [obj stopVideo];
        }
    }];
}

-(BOOL)shouldAutorotate {
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
