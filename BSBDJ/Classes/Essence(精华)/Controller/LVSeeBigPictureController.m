//
//  LVSeeBigPictureController.m
//  BSBDJ
//
//  Created by lvdesheng on 16/3/6.
//  Copyright © 2016年 lvdesheng. All rights reserved.
//

/*
 1.如果控制器的view是通过xib创建的，那么在viewDidLoad方法中，控制器view的大小就是xib中设置的大小
 
 2.为了避免【在viewDidLoad方法中拿到不准确的控制器view大小】，可以这么解决
 1> 在viewDidLoad方法中初始化添加子控件
 2> 在viewDidLayoutSubviews方法中设置子控件的frame
 */


#import "LVSeeBigPictureController.h"
#import "LVTopic.h"
#import "UIImageView+WebCache.h"

@interface LVSeeBigPictureController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property (nonatomic, weak)  UIImageView *imageView;

@end

@implementation LVSeeBigPictureController

- (void)viewDidLoad {
    [super viewDidLoad];

    //创建一个scrollView
    UIScrollView *ScrollView = [[UIScrollView alloc]init];
    
    ScrollView.frame = [UIScreen mainScreen].bounds;

    [ScrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back:)]];
    
    [self.view insertSubview:ScrollView atIndex:0];
   //创建imagview
    UIImageView *ImageView = [[UIImageView alloc]init];
    
    CGFloat imageW = LVScreenW;
    CGFloat imageH = imageW * self.topic.height / self.topic.width;
    CGFloat imageY = 0;
    if (imageH < LVScreenH) {
        imageY = (LVScreenH - imageH) * 0.5;
    } else { // 图片高度超过屏幕高度
        ScrollView.contentSize = CGSizeMake(0, imageH);
    }

    ImageView.frame = CGRectMake(0, imageY, imageW, imageH);
    
    [ImageView sd_setImageWithURL:[NSURL URLWithString:self.topic.image1] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
       if (image == nil) return;
        
        self.saveButton.enabled = YES;
        
    }];
    
    [ScrollView addSubview:ImageView];
    self.imageView = ImageView;
    
    //缩放
    
    CGFloat maxScale = self.topic.width / imageW;
    
    if (maxScale){
        ScrollView.maximumZoomScale = maxScale;
        ScrollView.delegate = self;
    }
    
    
}

#pragma mark - 按钮点击
- (IBAction)saveClick:(id)sender {
    LVFunc
}

- (IBAction)back:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIScrollViewDelegate
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}




@end
