//
//  UMShareViewController.m
//  UMSocialSDK
//
//  Created by wyq.Cloudayc on 11/8/16.
//  Copyright © 2016 UMeng. All rights reserved.
//

#import "UMShareViewController.h"
#import <UShareUI/UShareUI.h>
#import "UMShareTypeViewController.h"

#ifdef UM_Swift
#import "UMengDemo-Swift.h"
#endif

@interface UMShareViewController ()<UMSocialShareMenuViewDelegate>

@property (nonatomic, strong) UIButton *bottomNormalButton;
@property (nonatomic, strong) UIButton *bottomCircleButton;
@property (nonatomic, strong) UIButton *middleNormalButton;
@property (nonatomic, strong) UIButton *middleCircleButton;

@property (nonatomic, strong) UIButton *bottomNormalButtonWithoutTitle;
@property (nonatomic, strong) UIButton *bottomNormalButtonWithoutCancel;


@end

@implementation UMShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
#ifdef UM_Swift
    [UMSocialSwiftInterface setPreDefinePlatforms:@[
                                                   @(UMSocialPlatformType_WechatSession),
                                                   @(UMSocialPlatformType_WechatTimeLine),
                                                   @(UMSocialPlatformType_WechatFavorite),
                                                   @(UMSocialPlatformType_QQ),
                                                   @(UMSocialPlatformType_Qzone),
                                                   @(UMSocialPlatformType_Sina),
                                                   @(UMSocialPlatformType_TencentWb),
                                                   @(UMSocialPlatformType_AlipaySession),
                                                   @(UMSocialPlatformType_DingDing),
                                                   @(UMSocialPlatformType_Renren),
                                                   @(UMSocialPlatformType_Douban),
                                                   @(UMSocialPlatformType_Sms),
                                                   @(UMSocialPlatformType_Email),
                                                   @(UMSocialPlatformType_Facebook),
                                                   @(UMSocialPlatformType_FaceBookMessenger),
                                                   @(UMSocialPlatformType_Twitter),
                                                   @(UMSocialPlatformType_LaiWangSession),
                                                   @(UMSocialPlatformType_LaiWangTimeLine),
                                                   @(UMSocialPlatformType_YixinSession),
                                                   @(UMSocialPlatformType_YixinTimeLine),
                                                   @(UMSocialPlatformType_YixinFavorite),
                                                   @(UMSocialPlatformType_Instagram),
                                                   @(UMSocialPlatformType_Line),
                                                   @(UMSocialPlatformType_Whatsapp),
                                                   @(UMSocialPlatformType_Linkedin),
                                                   @(UMSocialPlatformType_Flickr),
                                                   @(UMSocialPlatformType_KakaoTalk),
                                                   @(UMSocialPlatformType_Pinterest),
                                                   @(UMSocialPlatformType_Tumblr),
                                                   @(UMSocialPlatformType_YouDaoNote),
                                                   @(UMSocialPlatformType_EverNote),
                                                   @(UMSocialPlatformType_GooglePlus),
                                                   @(UMSocialPlatformType_Pocket),
                                                   @(UMSocialPlatformType_DropBox),
                                                   @(UMSocialPlatformType_VKontakte),
                                                   @(UMSocialPlatformType_UserDefine_Begin+1),
                                                   ]];
#else
    //设置用户自定义的平台
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),
                                               @(UMSocialPlatformType_WechatTimeLine),
                                               @(UMSocialPlatformType_WechatFavorite),
                                               @(UMSocialPlatformType_QQ),
                                               @(UMSocialPlatformType_Qzone),
                                               @(UMSocialPlatformType_Sina),
                                               @(UMSocialPlatformType_TencentWb),
                                               @(UMSocialPlatformType_AlipaySession),
                                               @(UMSocialPlatformType_DingDing),
                                               @(UMSocialPlatformType_Renren),
                                               @(UMSocialPlatformType_Douban),
                                               @(UMSocialPlatformType_Sms),
                                               @(UMSocialPlatformType_Email),
                                               @(UMSocialPlatformType_Facebook),
                                               @(UMSocialPlatformType_FaceBookMessenger),
                                               @(UMSocialPlatformType_Twitter),
                                               @(UMSocialPlatformType_LaiWangSession),
                                               @(UMSocialPlatformType_LaiWangTimeLine),
                                               @(UMSocialPlatformType_YixinSession),
                                               @(UMSocialPlatformType_YixinTimeLine),
                                               @(UMSocialPlatformType_YixinFavorite),
                                               @(UMSocialPlatformType_Instagram),
                                               @(UMSocialPlatformType_Line),
                                               @(UMSocialPlatformType_Whatsapp),
                                               @(UMSocialPlatformType_Linkedin),
                                               @(UMSocialPlatformType_Flickr),
                                               @(UMSocialPlatformType_KakaoTalk),
                                               @(UMSocialPlatformType_Pinterest),
                                               @(UMSocialPlatformType_Tumblr),
                                               @(UMSocialPlatformType_YouDaoNote),
                                               @(UMSocialPlatformType_EverNote),
                                               @(UMSocialPlatformType_GooglePlus),
                                               @(UMSocialPlatformType_Pocket),
                                               @(UMSocialPlatformType_DropBox),
                                               @(UMSocialPlatformType_VKontakte),
                                               @(UMSocialPlatformType_UserDefine_Begin+1),
                                               ]];
#endif
    
    //设置分享面板的显示和隐藏的代理回调
    [UMSocialUIManager setShareMenuViewDelegate:self];
    
    self.titleString = @"分享菜单模板";

    UIButton *button = [self button];
    [button setTitle:@"页面底部菜单-1" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showBottomNormalView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    self.bottomNormalButton = button;
    
    button = [self button];
    [button setTitle:@"页面底部菜单-2" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showBottomCircleView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    self.bottomCircleButton = button;
    
    button = [self button];
    [button setTitle:@"页面中部菜单-1" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showMiddleNormalView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    self.middleNormalButton = button;
    
    button = [self button];
    [button setTitle:@"页面中部菜单-2" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showMiddleCircleView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    self.middleCircleButton = button;
    }

- (void)viewWillLayoutSubviews {
    
    CGFloat y = [self viewOffsetY] + 20.f;
    
    CGFloat width = self.view.bounds.size.width;
    CGFloat pad = 20.f;
    
    CGRect viewFrame = self.view.frame;
    CGFloat viewWidth = viewFrame.size.width - 20.f * 4;
    viewWidth /= 2;
    
    CGRect frame;
    frame.origin.x = width / 4.f - viewWidth / 2.f;
    frame.origin.y = y;
    frame.size.width = viewWidth;
    frame.size.height = viewWidth / 3;
    _bottomNormalButton.frame = frame;
    
    frame.origin.x = width * 3 / 4.f - frame.size.width / 2.f;
    frame.origin.y = y;
    _bottomCircleButton.frame = frame;
    
    y += frame.size.height + pad;

    frame.origin.x = width / 4.f - frame.size.width / 2.f;
    frame.origin.y = y;
    _middleNormalButton.frame = frame;
    
    frame.origin.x = width * 3 / 4.f - frame.size.width / 2.f;
    frame.origin.y = y;
    _middleCircleButton.frame = frame;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showBottomNormalView
{
    //加入copy的操作
    //@see http://dev.umeng.com/social/ios/进阶文档#6
    [UMSocialUIManager addCustomPlatformWithoutFilted:UMSocialPlatformType_UserDefine_Begin+2
                                     withPlatformIcon:[UIImage imageNamed:@"icon_circle"]
                                     withPlatformName:@"演示icon"];
    
    [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Bottom;
    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_None;
#ifdef UM_Swift
    [UMSocialSwiftInterface showShareMenuViewInWindowWithPlatformSelectionBlockWithSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary* userInfo) {
#else
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
#endif
        //在回调里面获得点击的
        if (platformType == UMSocialPlatformType_UserDefine_Begin+2) {
            NSLog(@"点击演示添加Icon后该做的操作");
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"添加自定义icon"
                                                                message:@"具体操作方法请参考UShareUI内接口文档"
                                                               delegate:nil
                                                      cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                                      otherButtonTitles:nil];
                [alert show];
                
            });
        }
        else{
            [self runShareWithType:platformType];
        }
    }];
}

- (void)showBottomCircleView
{
    [UMSocialUIManager removeAllCustomPlatformWithoutFilted];
    [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Bottom;
    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_IconAndBGRadius;
#ifdef UM_Swift
    [UMSocialSwiftInterface showShareMenuViewInWindowWithPlatformSelectionBlockWithSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary* userInfo) {
#else
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
#endif
        [self runShareWithType:platformType];
    }];
}

- (void)showMiddleNormalView
{
    [UMSocialUIManager removeAllCustomPlatformWithoutFilted];
    [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Middle;
    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_None;
#ifdef UM_Swift
    [UMSocialSwiftInterface showShareMenuViewInWindowWithPlatformSelectionBlockWithSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary* userInfo) {
#else
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
#endif
        [self runShareWithType:platformType];
    }];
}

- (void)showMiddleCircleView
{
    [UMSocialUIManager removeAllCustomPlatformWithoutFilted];
    [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Middle;
    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_IconAndBGRadius;
#ifdef UM_Swift
    [UMSocialSwiftInterface showShareMenuViewInWindowWithPlatformSelectionBlockWithSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary* userInfo) {
#else
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
#endif
        [self runShareWithType:platformType];
    }];
}

- (void)runShareWithType:(UMSocialPlatformType)type
{
    UMShareTypeViewController *VC = [[UMShareTypeViewController alloc] initWithType:type];
    [self.navigationController pushViewController:VC animated:YES];
}


- (UILabel *)labelWithName:(NSString *)name
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, 140.f, 33.f)];
    label.font = [UIFont systemFontOfSize:16.f];
    label.textAlignment = NSTextAlignmentLeft;
    label.text = name;
    label.textColor = [UIColor colorWithRed:0.f green:0.53f blue:0.86f alpha:1.f];
    return label;
}

- (UIButton *)button
{
    CGRect frame = self.view.frame;
    CGFloat width = frame.size.width - 20.f * 4;
    width /= 2;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(250.f, 10.f, width, width / 3);
    button.backgroundColor = [UIColor whiteColor];
    [button setTitleColor:[UIColor colorWithRed:0.34 green:.35 blue:.3 alpha:1] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16.f];
    
    return button;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UMSocialShareMenuViewDelegate
- (void)UMSocialShareMenuViewDidAppear
{
    NSLog(@"UMSocialShareMenuViewDidAppear");
}
- (void)UMSocialShareMenuViewDidDisappear
{
    NSLog(@"UMSocialShareMenuViewDidDisappear");
}

//不需要改变父窗口则不需要重写此协议
- (UIView*)UMSocialParentView:(UIView*)defaultSuperView
{
    return defaultSuperView;
}

@end
