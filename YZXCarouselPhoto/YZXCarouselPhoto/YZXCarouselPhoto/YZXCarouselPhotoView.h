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

- (instancetype)initWithFrame:(CGRect)frame
                   dataSource:(NSArray * _Nullable)dataSource;

@property (nonatomic, copy) YZXCarouselPhotoClickBlock         clickBlock;

@property (nonatomic, copy) NSArray              *dataSource;

@property (nonatomic, assign) NSTimeInterval     timeInterval;

@end

NS_ASSUME_NONNULL_END
