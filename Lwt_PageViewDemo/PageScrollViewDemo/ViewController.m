//
//  ViewController.m
//  PageScrollViewDemo
//
//  Created by showsoft_004 on 15-1-16.
//  Copyright (c) 2015年 秀软. All rights reserved.
//

#import "ViewController.h"
#import "Lwt_PageView.h"
@interface ViewController ()
{

}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSMutableArray *arr= [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 6; i ++)
    {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loupan_pic%d.png",i]];
        [arr addObject:image];
    }
    
    
    UIScrollView *_scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_scrollView];
    
    _scrollView.contentSize = CGSizeMake(320, 40000);
    
    Lwt_PageView *pageScrollView = [[Lwt_PageView alloc] initWithFrame:CGRectMake(0, 0, 320,300) withImages:arr repeat:YES showHorizontal:YES];
    
    pageScrollView.currentPageColor = [UIColor blackColor];
    pageScrollView.tintPageColor = [UIColor grayColor];
    [pageScrollView startRepeatScroll:2];
    
    [pageScrollView currentPageViewBlock:^(UIImageView *imageView, NSInteger page) {
        NSLog(@"page = %d",page) ;
    }];
    
    [pageScrollView clickBlock:^(UIImageView *imageView, NSInteger page) {
        NSLog(@"page = %d",page) ;
    }];
    
    
    [_scrollView addSubview:pageScrollView];
 
//    [pageScrollView startAutoScrollWithDuration:1];

    
}

#pragma mark - Lwt_PageScrollViewDelegate

- (void)scrollDidEndWithPage:(NSInteger)page
{
    NSLog(@"%d",page);
}

- (void)tapImageWithPage:(NSInteger)page
{
    NSLog(@"%d",page);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
