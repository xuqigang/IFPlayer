//
//  ViewController.m
//  IFPlayer
//
//  Created by Xuqigang on 2018/9/10.
//  Copyright © 2018年 凤凰新媒体. All rights reserved.
//

#import "ViewController.h"
#import "VideoListVC.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"AVPlayer演示";
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)videolistButtonClicked:(UIButton *)sender {
    VideoListVC *vc = [VideoListVC instanceFromNib];
    [self presentViewController:vc animated:YES completion:nil];
}

-(BOOL)shouldAutorotate {
    
    return NO;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
