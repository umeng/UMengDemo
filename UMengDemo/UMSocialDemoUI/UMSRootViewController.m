//
//  UMSNavigationViewController.m
//  UMSocialSDK
//
//  Created by wyq.Cloudayc on 11/8/16.
//  Copyright © 2016 UMeng. All rights reserved.
//

#import "UMSRootViewController.h"

#import "UMSPlatformListViewController.h"
#import "UMShareViewController.h"

static NSString *UMS_NAV_NAME = @"UMS_NAV_NAME";
static NSString *UMS_NAV_ICON = @"UMS_NAV_ICON";
static NSString *UMS_NAV_ICON_SIZE = @"UMS_NAV_ICON_SIZE";
static NSString *UMS_NAV_SELECTOR = @"UMS_NAV_SELECTOR";

static NSString *UMS_NAV_TBL_CELL = @"UMS_NAV_TBL_CELL";

static NSUInteger UMS_TIP_BUTTON_TAG = 99001;

static NSUInteger specNumberLines = 0;
static NSString *UMS_NAV_SPEC_PREFIX = @"版本号：v6.6\n";



@interface UMSRootViewController ()
<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *opArray;
@property (nonatomic, strong) NSArray *stateArray;

@property (nonatomic, weak) UILabel *fetchCellLabel;// for width

@end

@implementation UMSRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.titleString = @"U-Share产品Demo";

    if (!_opArray) {
        self.opArray = @[@{UMS_NAV_NAME: @"分享",
                           UMS_NAV_ICON: [UIImage imageNamed:@"share_icon"],
                           UMS_NAV_ICON_SIZE: NSStringFromCGSize(CGSizeMake(25.f, 25.f)),
                           UMS_NAV_SELECTOR: NSStringFromSelector(@selector(enterShareView))},
                         @{UMS_NAV_NAME: @"授权（第三方登录）",
                           UMS_NAV_ICON: [UIImage imageNamed:@"auth_icon"],
                           UMS_NAV_ICON_SIZE: NSStringFromCGSize(CGSizeMake(25.f, 24.f)),
                           UMS_NAV_SELECTOR: NSStringFromSelector(@selector(enterAuthView))},
                         @{UMS_NAV_NAME: @"获取用户信息",
                           UMS_NAV_ICON: [UIImage imageNamed:@"userinfo_icon"],
                           UMS_NAV_ICON_SIZE: NSStringFromCGSize(CGSizeMake(25.f, 24.f)),
                           UMS_NAV_SELECTOR: NSStringFromSelector(@selector(enterUserInfoView))}];
        
        self.stateArray = @[@{UMS_NAV_NAME: @"新版更新内容",
                              UMS_NAV_ICON_SIZE: NSStringFromCGSize(CGSizeMake(25.f, 25.f)),
                              UMS_NAV_ICON: [UIImage imageNamed:@"versionstatus_icon"]}];
    }
    
    if (!_tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:UMS_NAV_TBL_CELL];
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.tableHeaderView = nil;
        self.tableView.tableFooterView = nil;
        self.tableView.sectionFooterHeight = 0.f;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;

        self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 0.f, 15.f)];
        [self.view addSubview:_tableView];
    }
}

- (void)viewWillLayoutSubviews {
    self.tableView.frame = self.view.bounds;
    
    __weak UMSRootViewController *ws = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [ws.tableView reloadData];
    });
}

- (void)enterShareView
{
    [self.navigationController pushViewController:[[UMSPlatformListViewController alloc] initWithViewType:UMSAuthViewTypeShare] animated:YES];
}

- (void)enterShareTemplateView
{
    [self.navigationController pushViewController:[UMShareViewController new] animated:YES];
}

- (void)enterAuthView
{
    [self.navigationController pushViewController:[[UMSPlatformListViewController alloc] initWithViewType:UMSAuthViewTypeAuth] animated:YES];
}

- (void)enterUserInfoView
{
    [self.navigationController pushViewController:[[UMSPlatformListViewController alloc] initWithViewType:UMSAuthViewTypeUserInfo] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIButton *)tipButton
{
    UIButton *tipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tipButton.frame = CGRectMake(0.f, 10.f, 100.f, 28.f);
    tipButton.tag = UMS_TIP_BUTTON_TAG;
    tipButton.layer.borderColor = [UIColor colorWithRed:0.f green:0.53f blue:0.8f alpha:1.f].CGColor;
    tipButton.layer.borderWidth = 1.f;
    tipButton.layer.cornerRadius = 3.f;

    [tipButton setTitle:@"分享菜单模板" forState:UIControlStateNormal];
    [tipButton setTitleColor:[UIColor colorWithRed:0.f green:0.53f blue:0.86f alpha:1.f] forState:UIControlStateNormal];
    tipButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
    
    [tipButton addTarget:self action:@selector(enterShareTemplateView) forControlEvents:UIControlEventTouchUpInside];
    
    return tipButton;
}

- (NSString *)updateSpecification
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"update" ofType:@"txt"];
    NSData *readme = [NSData dataWithContentsOfFile:filePath];
    NSString *str = [[NSString alloc] initWithData:readme encoding:NSUTF8StringEncoding];
    return [UMS_NAV_SPEC_PREFIX stringByAppendingString:str];
}
#pragma mark -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (section == 0) ? _opArray.count : _stateArray.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:UMS_NAV_TBL_CELL];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = [UIColor colorWithRed:0.34 green:.35 blue:.3 alpha:1];
    
    UIImage *accessImage = nil;
    
    NSDictionary *dict = nil;
    if (indexPath.section == 0) {
        dict = self.opArray[indexPath.row];
        
        // share
        if (indexPath.row == 0) {
            UIButton *tipButton = [cell.contentView viewWithTag:UMS_TIP_BUTTON_TAG];
            if (!tipButton) {
                tipButton = [self tipButton];
                [cell.contentView addSubview:tipButton];
            }
            CGRect frame = tipButton.frame;
            frame.origin.x = cell.contentView.frame.size.width - frame.size.width - 40.f;
            tipButton.frame = frame;
        }
        
        accessImage = [self resizeImage:[UIImage imageNamed:@"access"]
                                   size:CGSizeMake(8.f, 14.f)];
    } else {
        if (indexPath.row == 0) {
            dict = self.stateArray[indexPath.row];
        } else {
            if (cell.textLabel) {
                NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
                paragraph.lineSpacing = 4.f;
                NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:[self updateSpecification] attributes:@{NSParagraphStyleAttributeName: paragraph}];
                cell.textLabel.attributedText = attrString;
                cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
                cell.textLabel.numberOfLines = specNumberLines;
                cell.textLabel.font = [UIFont systemFontOfSize:14.f];
                [cell.textLabel sizeToFit];
                
                self.fetchCellLabel = cell.textLabel;
            }
            cell.imageView.image = [self blankImage];
            
        }
    }
    
    if (dict) {
        cell.textLabel.text = dict[UMS_NAV_NAME];
        cell.imageView.image = [self resizeImage:dict[UMS_NAV_ICON]
                                            size:CGSizeFromString(dict[UMS_NAV_ICON_SIZE])] ;
    }
    
    if (accessImage) {
        cell.accessoryView = [[UIImageView alloc] initWithImage:accessImage];
    }
    
    
    return cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 1) {
        if (_fetchCellLabel) {
            return _fetchCellLabel.frame.size.height;
        }
        return 155.f;
    }
    return 45.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSDictionary *dict = nil;
    if (indexPath.section == 0) {
        dict = self.opArray[indexPath.row];
    } else {
    }
    if (dict) {
        [self performSelector:NSSelectorFromString(dict[UMS_NAV_SELECTOR])];
    }
}
//- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    if (section == 0)
//        return 0.0f;
//    return 0.f;
//}
//
//- (NSString*) tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger)section
//{
//    if (section == 0) {
//        return nil;
//    } else {
//        return nil;
//    }
//}

#pragma mark -
- (UIImage *)resizeImage:(UIImage *)image size:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, size.width, size.height);
    [image drawInRect:imageRect];
    UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return retImage;
}

- (UIImage *)blankImage
{
    CGSize size = CGSizeMake(25.f, 25.f);
    UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    [[UIColor whiteColor] setFill];
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"U-Share产品Demo";
    //self.tabBarItem.title = @"UShare";
}
@end
