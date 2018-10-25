//
//  YZXCarouselPhotoCollectionViewCell.m
//  YZXCarouselPhoto
//
//  Created by 尹星 on 2018/10/25.
//  Copyright © 2018 尹星. All rights reserved.
//

#import "YZXCarouselPhotoCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface YZXCarouselPhotoCollectionViewCell ()

@property (nonatomic, strong) UIImageView       *imageView;

@end

@implementation YZXCarouselPhotoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self p_initView];
    }
    return self;
}

- (void)p_initView
{
    [self addSubview:self.imageView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

- (void)setImage:(NSString *)imageName
{
    self.imageView.image = [UIImage imageNamed:imageName];
}

- (void)setUrlImage:(NSString *)imageUrl
{
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
}

#pragma mark - 懒加载
- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

#pragma mark - ------------------------------------------------------------------------------------


@end
