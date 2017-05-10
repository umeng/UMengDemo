//
//  UMSLaiWangShareTableViewController.h
//  SocialSDK
//
//  Created by umeng on 16/4/18.
//  Copyright © 2016年 dongjianxiong. All rights reserved.
//

#import <UMSocialCore/UMSocialCore.h>

@interface UMSocialLaiWangHandler : UMSocialHandler

+ (UMSocialLaiWangHandler *)defaultManager;

- (void)setAppId:(NSString *)appID appSecret:(NSString *)secret url:(NSString *)url appDescription:(NSString *)description;

@end
