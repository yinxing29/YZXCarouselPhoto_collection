//
//  ViewController.m
//  YZXCarouselPhoto
//
//  Created by 尹星 on 2018/10/25.
//  Copyright © 2018 尹星. All rights reserved.
//

#import "ViewController.h"
#import "YZXCarouselPhotoView.h"

@interface ViewController ()

@property (nonatomic, strong) YZXCarouselPhotoView       *carouselPhotoView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    
    [self.view addSubview:self.carouselPhotoView];
}

#pragma mark - 懒加载
- (YZXCarouselPhotoView *)carouselPhotoView
{
    if (!_carouselPhotoView) {
        _carouselPhotoView = [[YZXCarouselPhotoView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 300) dataSource:nil];
        _carouselPhotoView.dataSource = @[];
    }
    return _carouselPhotoView;
}

#pragma mark - ------------------------------------------------------------------------------------


@end
