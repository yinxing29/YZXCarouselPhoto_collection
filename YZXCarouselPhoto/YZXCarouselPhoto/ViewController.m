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
        _carouselPhotoView = [[YZXCarouselPhotoView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 300)];
        _carouselPhotoView.imageUrl = @[@"http://p5m3egx6g.bkt.clouddn.com/%E6%89%8B%E5%8A%BF%E8%A7%A3%E9%94%81.png",@"http://p5m3egx6g.bkt.clouddn.com/qq.png",@"http://p5m3egx6g.bkt.clouddn.com/wechat.png"];
        _carouselPhotoView.canCarousel = NO;
    }
    return _carouselPhotoView;
}

#pragma mark - ------------------------------------------------------------------------------------


@end
