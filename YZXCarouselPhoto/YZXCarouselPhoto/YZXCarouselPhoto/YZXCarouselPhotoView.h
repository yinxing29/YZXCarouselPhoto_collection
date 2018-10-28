//
//  YZXCarouselPhotoView.h
//  YZXCarouselPhoto
//
//  Created by 尹星 on 2018/10/25.
//  Copyright © 2018 尹星. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^YZXCarouselPhotoClickBlock)(NSIndexPath *indexPath);

NS_ASSUME_NONNULL_BEGIN

@interface YZXCarouselPhotoView : UIView

/**
 点击回调
 */
@property (nonatomic, copy) YZXCarouselPhotoClickBlock         clickBlock;

/**
 本地数据源
 */
@property (nonatomic, copy) NSArray              *imageName;

/**
 网络数据源
 */
@property (nonatomic, copy) NSArray              *imageUrl;

/**
 设置轮播间隔时间
 */
@property (nonatomic, assign) NSTimeInterval     timeInterval;

/**
 是否自动轮播
 */
@property (nonatomic, assign) BOOL               canCarousel;

@end

NS_ASSUME_NONNULL_END
