
//
//  YZXCarouselPhotoView.m
//  YZXCarouselPhoto
//
//  Created by 尹星 on 2018/10/25.
//  Copyright © 2018 尹星. All rights reserved.
//

#import "YZXCarouselPhotoView.h"
#import "YZXCarouselPhotoCollectionViewCell.h"
#import <SDWebImage/UIImage+MultiFormat.h>

@interface YZXCarouselPhotoView ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>

@property (nonatomic, strong) UICollectionViewFlowLayout       *layout;
@property (nonatomic, strong) UICollectionView                 *collectionView;
@property (nonatomic, strong) NSTimer                          *timer;

@property (nonatomic, strong) UILabel                          *pageLab;

@property (nonatomic, copy) NSArray                            *dataSource;

@property (nonatomic, assign) NSInteger                        dataSourceCountMultiple;

/**
 防止修改pageLab的frame时触发layoutSubviews导致其他内容重新初始化
 */
@property (nonatomic, assign) BOOL                             first;

@end

static const NSInteger kDataSourceCountMultiple = 1000;

@implementation YZXCarouselPhotoView

static NSString *kCollectionViewCellIdentify = @"collectionViewCell_identify";

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self p_initData];
    [self p_initView];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self p_initData];
        [self p_initView];
    }
    return self;
}

- (void)p_initData
{
    self.timeInterval = 2.0;
    self.first = YES;
    self.canCarousel = YES;
}

- (void)p_initView
{
    [self.collectionView registerClass:[YZXCarouselPhotoCollectionViewCell class] forCellWithReuseIdentifier:kCollectionViewCellIdentify];
    
    [self addSubview:self.collectionView];
    
    [self addSubview:self.pageLab];
    self.pageLab.text = [NSString stringWithFormat:@"%d/%ld",1,_dataSource.count];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.first) {
        self.collectionView.frame = self.bounds;
        self.layout.itemSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
     
        [self p_settingPageLabFrame];
        if (_dataSource.count != 0) {//防止传入空数组崩溃
            if (self.dataSourceCountMultiple == 1) {//不自动轮播
                [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
            }else {
                [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_dataSource.count * self.dataSourceCountMultiple / 2 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
            }
        }
        self.first = NO;
    }
}
//循环事件
- (void)carousel
{
    [self p_scrollPage];
}
//初始化timer
- (void)p_creatTimer
{
    if (_dataSource.count == 0 || !self.canCarousel) {
        return;
    }
    [self p_removeTimer];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(carousel) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}
//移除timer
- (void)p_removeTimer
{
    [self.timer invalidate];
    self.timer = nil;
}
//自动轮播
- (void)p_scrollPage
{
    NSInteger item = self.collectionView.contentOffset.x / self.collectionView.bounds.size.width;
    BOOL animated = YES;
    //达到最大值是返回到中间
    if (item == _dataSource.count * self.dataSourceCountMultiple - 1) {
        item = _dataSource.count * self.dataSourceCountMultiple / 2 - 1;
        animated = NO;
    }
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:item + 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:animated];
}

//重设pageLab的frame
- (void)p_settingPageLabFrame
{
    [self.pageLab sizeToFit];
    self.pageLab.frame = CGRectMake(self.bounds.size.width - 17.0 - ((self.pageLab.bounds.size.width + 10)), self.bounds.size.height - 23.0, self.pageLab.bounds.size.width + 10, 15.0);
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.pageLab.text = [NSString stringWithFormat:@"%ld/%ld",(NSInteger)((self.collectionView.contentOffset.x + self.layout.itemSize.width / 2.0) / self.layout.itemSize.width) % _dataSource.count + 1,_dataSource.count];
    [self p_settingPageLabFrame];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self p_removeTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self p_creatTimer];
}

#pragma mark - ------------------------------------------------------------------------------------

#pragma mark - <UICollectionViewDataSource,UICollectionViewDelegate>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataSource.count * self.dataSourceCountMultiple;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YZXCarouselPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCellIdentify forIndexPath:indexPath];
    [cell setImage:_dataSource[indexPath.item % _dataSource.count]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.clickBlock) {
        self.clickBlock(indexPath);
    }
}

#pragma mark - ------------------------------------------------------------------------------------

#pragma mark - setter
- (void)setImageUrl:(NSArray *)imageUrl
{
    _imageName = nil;
    _imageUrl = [imageUrl copy];
    self.dataSource = [imageUrl copy];
}

- (void)setImageName:(NSArray *)imageName
{
    _imageUrl = nil;
    _imageName = [imageName copy];
    self.dataSource = [imageName copy];
}

- (void)setDataSource:(NSArray *)dataSource
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //对于传入的数组（imageName或者imageUrl）先统一转换成image
        NSMutableArray *images = [NSMutableArray array];
        if (self->_imageName) {
            for (NSString *imageName in self.imageName) {
                UIImage *image = [UIImage imageNamed:imageName];
                [images addObject:image];
            }
            self->_dataSource = [images copy];
        }else {
            for (NSString *url in self.imageUrl) {
                [images addObject:[UIImage sd_imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]]];
            }
            self->_dataSource = [images copy];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
            self.pageLab.text = [NSString stringWithFormat:@"%d/%ld",1,self->_dataSource.count];
        });
    });
}

- (void)setTimeInterval:(NSTimeInterval)timeInterval
{
    _timeInterval = timeInterval;
    [self p_creatTimer];
}

- (void)setClickBlock:(YZXCarouselPhotoClickBlock)clickBlock
{
    _clickBlock = clickBlock;
}

- (void)setCanCarousel:(BOOL)canCarousel
{
    _canCarousel = canCarousel;
    if (_canCarousel) {
        self.dataSourceCountMultiple = kDataSourceCountMultiple;
    }else {
        self.dataSourceCountMultiple = 1;
    }
}

#pragma mark - ------------------------------------------------------------------------------------

#pragma mark - 懒加载
- (UICollectionViewFlowLayout *)layout
{
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _layout.minimumLineSpacing = 0.0;
    }
    return _layout;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
    }
    return _collectionView;
}

- (UILabel *)pageLab
{
    if (!_pageLab) {
        _pageLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _pageLab.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5];
        _pageLab.textColor = [UIColor whiteColor];
        _pageLab.textAlignment = NSTextAlignmentCenter;
        _pageLab.font = [UIFont systemFontOfSize:10.0];
        _pageLab.layer.cornerRadius = 7.5;
        [_pageLab setClipsToBounds:YES];
    }
    return _pageLab;
}

#pragma mark - ------------------------------------------------------------------------------------

@end
