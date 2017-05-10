//
//  UMAnalyticsDplusViewController.m
//  UMengDemo
//
//  Created by wangkai on 17/4/13.
//  Copyright © 2017年 UMeng. All rights reserved.
//

#import "UMAnalyticsDplusViewController.h"
#import <UMAnalytics/DplusMobClick.h>
#import <UMAnalytics/MobClick.h>

@implementation UMAnalyticsDplusViewController
- (void)viewDidLoad {
    [MobClick setScenarioType:E_UM_DPLUS];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setFrame:CGRectMake(0, 20, [UMAnalyticsDplusViewController getScreenWidth], 40)];
    [closeButton setBackgroundColor:[UIColor colorWithRed:141/255.0 green:166/255.0 blue:196/255.0 alpha:1.0]];
    [closeButton.layer setCornerRadius:5.0];
    [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    closeButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    [self.view addSubview:closeButton];
    
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerButton setFrame:CGRectMake(0, 70, [UMAnalyticsDplusViewController getScreenWidth]/2-5, 40)];
    [registerButton setBackgroundColor:[UIColor colorWithRed:141/255.0 green:166/255.0 blue:196/255.0 alpha:1.0]];
    [registerButton.layer setCornerRadius:5.0];
    [registerButton setTitle:@"registerSuper" forState:UIControlStateNormal];
    [registerButton addTarget:self action:@selector(registerButtonClick) forControlEvents:UIControlEventTouchUpInside];
    registerButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    [self.view addSubview:registerButton];
    
    UIButton *unregisterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [unregisterButton setFrame:CGRectMake([UMAnalyticsDplusViewController getScreenWidth]/2+5, 70, [UMAnalyticsDplusViewController getScreenWidth]/2-5, 40)];
    [unregisterButton setBackgroundColor:[UIColor colorWithRed:141/255.0 green:166/255.0 blue:196/255.0 alpha:1.0]];
    [unregisterButton.layer setCornerRadius:5.0];
    [unregisterButton setTitle:@"unregisterSuper" forState:UIControlStateNormal];
    [unregisterButton addTarget:self action:@selector(unregisterButtonClick) forControlEvents:UIControlEventTouchUpInside];
    unregisterButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    [self.view addSubview:unregisterButton];
    
    UIButton *getSuperButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [getSuperButton setFrame:CGRectMake(0, 120, [UMAnalyticsDplusViewController getScreenWidth]/2-5, 40)];
    [getSuperButton setBackgroundColor:[UIColor colorWithRed:141/255.0 green:166/255.0 blue:196/255.0 alpha:1.0]];
    [getSuperButton.layer setCornerRadius:5.0];
    [getSuperButton setTitle:@"getSuper" forState:UIControlStateNormal];
    [getSuperButton addTarget:self action:@selector(getSuperButtonClick) forControlEvents:UIControlEventTouchUpInside];
    getSuperButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    [self.view addSubview:getSuperButton];
    
    UIButton *clearSuperButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [clearSuperButton setFrame:CGRectMake([UMAnalyticsDplusViewController getScreenWidth]/2+5, 120, [UMAnalyticsDplusViewController getScreenWidth]/2-5, 40)];
    [clearSuperButton setBackgroundColor:[UIColor colorWithRed:141/255.0 green:166/255.0 blue:196/255.0 alpha:1.0]];
    [clearSuperButton.layer setCornerRadius:5.0];
    [clearSuperButton setTitle:@"clearSuper" forState:UIControlStateNormal];
    [clearSuperButton addTarget:self action:@selector(clearSuperButtonClick) forControlEvents:UIControlEventTouchUpInside];
    clearSuperButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    [self.view addSubview:clearSuperButton];
    
    UIButton *trackaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [trackaButton setFrame:CGRectMake(0, 170, [UMAnalyticsDplusViewController getScreenWidth]/2-5, 40)];
    [trackaButton setBackgroundColor:[UIColor colorWithRed:141/255.0 green:166/255.0 blue:196/255.0 alpha:1.0]];
    [trackaButton.layer setCornerRadius:5.0];
    [trackaButton setTitle:@"track A" forState:UIControlStateNormal];
    [trackaButton addTarget:self action:@selector(trackaButtonClick) forControlEvents:UIControlEventTouchUpInside];
    trackaButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    [self.view addSubview:trackaButton];
    
    UIButton *trackbButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [trackbButton setFrame:CGRectMake([UMAnalyticsDplusViewController getScreenWidth]/2+5, 170, [UMAnalyticsDplusViewController getScreenWidth]/2-5, 40)];
    [trackbButton setBackgroundColor:[UIColor colorWithRed:141/255.0 green:166/255.0 blue:196/255.0 alpha:1.0]];
    [trackbButton.layer setCornerRadius:5.0];
    [trackbButton setTitle:@"track B" forState:UIControlStateNormal];
    [trackbButton addTarget:self action:@selector(trackbButtonClick) forControlEvents:UIControlEventTouchUpInside];
    trackbButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    [self.view addSubview:trackbButton];
    
    
}
-(void)registerButtonClick{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys: @"um", @"name", @"123"
                         , @"age",@"66",@"width", nil];
    [DplusMobClick registerSuperProperty:dic];
    NSLog(@"register");
    
    
}
-(void)unregisterButtonClick{
    [DplusMobClick unregisterSuperProperty:@"name"];
    NSLog(@"del name");
    
}
-(void)getSuperButtonClick{
    NSDictionary *getDplus= [DplusMobClick getSuperProperties];
    NSLog(@"getSuper: %@",getDplus);
    
}
-(void)clearSuperButtonClick{
    [DplusMobClick clearSuperProperties];
    NSLog(@"clearSuper");
    
}
-(void)trackaButtonClick{
    [DplusMobClick track:@"eventDplusa"];
    
}
-(void)trackbButtonClick{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys: @"66", @"length", @"dplusvalue"
                         , @"dpluskey", nil];
    
    [DplusMobClick track:@"eventDplusb" property:dic];
    
}

-(void)closeButtonClick{
    [self dismissModalViewControllerAnimated:YES];
}
+ (float)getScreenHeight
{
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    return screenBounds.size.height;
}

+ (float)getScreenWidth
{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    return screenBounds.size.width;
}
@end
