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
#import "SVProgressHUD.h"
#import <Photos/Photos.h>

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
    
    //保存图片到相机胶卷 //此方法@selector有固定的格式image:didFinishSavingWithError:contextInfo:
//    UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);

    PHAuthorizationStatus oldStatus = [PHPhotoLibrary authorizationStatus];
    

    
    // 判断当前的授权状态
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (status)
            {
                    // 这是系统级别的限制（比如家长控制），用户也无法修改这个授权状态
                case PHAuthorizationStatusRestricted: {
                    [SVProgressHUD showErrorWithStatus:@"由于系统原因，无法保存图片！"];
                    break;
                }
                    
                    // 用户已经拒绝当前App访问相片数据（说明用户当初选择了“Don't Allow”）
                case PHAuthorizationStatusDenied: {
                    if (oldStatus != PHAuthorizationStatusNotDetermined) {
                        LVLog(@"提醒用户去打开访问开关");
                    }
                    break;
                }
                    
                    // 用户已经允许当前App访问相片数据（说明用户当初选择了“OK”）
                case PHAuthorizationStatusAuthorized: {
                    [self saveImage];
                    break;
                }
                
                default:
                    break;
            }
            
        });
        

    }];

}


/**
 *  获得当前App对应的【自定义相册】
 */
- (PHAssetCollection *)createdCollection
{
    // 抓取所有【自定义相册】
    PHFetchResult<PHAssetCollection *> *collections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    // 从Info.plist中获得App名称(也就是当前App的相册名称)
    NSString *title = [NSBundle mainBundle].infoDictionary[(NSString *)kCFBundleNameKey];
    for (PHAssetCollection *collection in collections) {
        if ([collection.localizedTitle isEqualToString:title]) {
            // 【自定义相册】已经创建过
            return collection;
        }
    }
    
    __block NSString *collectionId = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        // 创建【自定义相册】
        collectionId = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:title].placeholderForCreatedAssetCollection.localIdentifier;
    } error:nil];
    
    // 根据id获得刚刚创建完的相册
    return [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[collectionId] options:nil].firstObject;
}

/**
 *  保存图片
 */
- (void)saveImage
{
    // 凡是遵守NSFastEnumeration协议的对象，都可以使用for-in来遍历, for-in的效率普通for循环高
    // performChanges里面不能嵌套performChanges
    
    // 获得【自定义相册】
    PHAssetCollection *createdCollection = self.createdCollection;
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        // 保存图片到【相机胶卷】
        // createdAsset 就代表 刚才添加到【相机胶卷】中的图片
        PHObjectPlaceholder *createdAsset = [PHAssetChangeRequest creationRequestForAssetFromImage:self.imageView.image].placeholderForCreatedAsset;
        
        // 将对应的相册传入，创建一个【相册修改请求】对象
        PHAssetCollectionChangeRequest *collectionChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:createdCollection];
        
        // 将保存到【相机胶卷】的图片添加到【自定义相册】
        [collectionChangeRequest insertAssets:@[createdAsset] atIndexes:[NSIndexSet indexSetWithIndex:0]];
    } completionHandler:^(BOOL success, NSError *error) {
        if (success) {
            [SVProgressHUD showSuccessWithStatus:@"保存成功！"];
        } else {
            [SVProgressHUD showErrorWithStatus:@"保存失败！"];
        }
    }];
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
