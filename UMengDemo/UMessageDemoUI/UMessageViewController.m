//
//  UMessageViewController.m
//  UMengDemo
//
//  Created by shile on 2017/4/12.
//  Copyright © 2017年 UMeng. All rights reserved.
//

#import "UMessageViewController.h"
#import <UMPush/UMessage.h>
@interface UMessageViewController ()<UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *tagtext;
@property (weak, nonatomic) IBOutlet UILabel *tagnum;
@property (weak, nonatomic) IBOutlet UIButton *selecttype;
@property (weak, nonatomic) IBOutlet UITextField *nametext;
@property (nonatomic,strong) NSArray *types;
@property (weak, nonatomic) IBOutlet UIPickerView *typepicker;

@end

@implementation UMessageViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.types = @[kUMessageAliasTypeSina,kUMessageAliasTypeTencent,kUMessageAliasTypeQQ,kUMessageAliasTypeWeiXin,kUMessageAliasTypeBaidu,kUMessageAliasTypeRenRen,kUMessageAliasTypeKaixin,kUMessageAliasTypeDouban,kUMessageAliasTypeFacebook,kUMessageAliasTypeTwitter];
    self.typepicker.backgroundColor = [UIColor whiteColor];
    self.typepicker.delegate=self;
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(respondToTapGesture:)];
    
    // Specify that the gesture must be a single tap
    tapRecognizer.numberOfTapsRequired = 1;
    
    // Add the tap gesture recognizer to the view
    [self.view addGestureRecognizer:tapRecognizer];
    
    [self.selecttype setTitle:[self.types objectAtIndex:0] forState:UIControlStateNormal];
    CALayer *bglayer = [CALayer layer];
    bglayer.frame = CGRectMake(0, 0, self.typepicker.bounds.size.width, self.typepicker.bounds.size.height+54) ;
    bglayer.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor;
    [self.typepicker.layer addSublayer:bglayer];
    
    
    CALayer *topBorder = [CALayer layer];
    topBorder.frame = CGRectMake(0.0f, 0, CGRectGetWidth(self.typepicker.bounds), 1.0f);
    topBorder.backgroundColor = [UIColor grayColor].CGColor;
    [self.typepicker.layer addSublayer:topBorder];
    // Do any additional setup after loading the view.
}

- (void)respondToTapGesture:(id)sender
{
    
    if(!self.typepicker.hidden)
    {
        [self.typepicker setHidden:YES];
    }
    
    if([self.tagtext isFirstResponder])
    {
        [self.tagtext resignFirstResponder];
    }
    
    if([self.nametext isFirstResponder])
    {
        [self.nametext resignFirstResponder];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)Addtag:(id)sender {
    
#ifdef UM_Swift
    [UMessageSwiftInterface addTagWithTag:[self getTagsWithString:self.tagtext.text] response:^(id _Nonnull responseObject, NSInteger remain, NSError * _Nonnull error) {
        [self.tagnum setText:[NSString stringWithFormat:@"%ld",(long)remain]];
        [self.tagnum setNeedsDisplay];
        if(responseObject)
        {
            [self showMessageAlert:@"添加成功！"];
        }
        else
        {
            [self showMessageAlert:error.localizedDescription];
        }
    }];
#else
    [UMessage addTags:[self getTagsWithString:self.tagtext.text]
            response:^(id responseObject, NSInteger remain, NSError *error) {
                [self.tagnum setText:[NSString stringWithFormat:@"%ld",(long)remain]];
                [self.tagnum setNeedsDisplay];
                if(responseObject)
                {
                    [self showMessageAlert:@"添加成功！"];
                }
                else
                {
                    [self showMessageAlert:error.localizedDescription];
                }
                
            }];
#endif
}

- (IBAction)RemoveTag:(id)sender {

#ifdef UM_Swift
    [UMessageSwiftInterface removeTagWithTag:[self getTagsWithString:self.tagtext.text] response:^(id _Nonnull responseObject, NSInteger remain, NSError * _Nonnull error) {
        [self.tagnum setText:[NSString stringWithFormat:@"%ld",(long)remain]];
        [self.tagnum setNeedsDisplay];
        if(responseObject)
        {
            [self showMessageAlert:@"删除成功！"];
        }
        else
        {
            [self showMessageAlert:error.localizedDescription];
        }
    }];
#else
    [UMessage deleteTags:[self getTagsWithString:self.tagtext.text]
               response:^(id responseObject, NSInteger remain, NSError *error) {
                   [self.tagnum setText:[NSString stringWithFormat:@"%ld",(long)remain]];
                   [self.tagnum setNeedsDisplay];
                   if(responseObject)
                   {
                       [self showMessageAlert:@"删除成功！"];
                   }
                   else
                   {
                       [self showMessageAlert:error.localizedDescription];
                   }
                   
               }];
#endif
}

- (IBAction)ResetTag:(id)sender {
#ifdef UM_Swift
//    [UMessageSwiftInterface removeAllTagsWithResponse:^(id _Nonnull responseObject, NSInteger remain, NSError * _Nonnull error) {
//        [self.tagnum setText:[NSString stringWithFormat:@"%ld",(long)remain]];
//        [self.tagnum setNeedsDisplay];
//        if(responseObject)
//        {
//            [self showMessageAlert:@"重置成功！"];
//        }
//        else
//        {
//            [self showMessageAlert:error.localizedDescription];
//        }
//    }];
#else
//    [UMessage removeAllTags:^(id responseObject, NSInteger remain, NSError *error) {
//        [self.tagnum setText:[NSString stringWithFormat:@"%ld",(long)remain]];
//        [self.tagnum setNeedsDisplay];
//        if(responseObject)
//        {
//            [self showMessageAlert:@"重置成功！"];
//        }
//        else
//        {
//            [self showMessageAlert:error.localizedDescription];
//        }
//    }];
#endif
}






- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.types count];//将数据建立一个数组
}
- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.types objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self.selecttype setTitle:[self.types objectAtIndex:row] forState:UIControlStateNormal];
    [self.selecttype setNeedsDisplay];
}


- (IBAction)AliasType:(id)sender {
    [self.typepicker setHidden:NO];
}
- (IBAction)AddAlias:(id)sender {
    NSLog(@"self nameTextField [%@]",self.nametext.text);
    
#ifdef UM_Swift
    [UMessageSwiftInterface setAliasWithName:self.nametext.text type:[self.selecttype titleForState:UIControlStateNormal] response:^(id _Nonnull responseObject, NSError * _Nonnull error) {
        if(responseObject)
        {
            [self showMessageAlert:@"绑定成功！"];
        }
        else
        {
            [self showMessageAlert:error.localizedDescription];
        }
    }];
#else
    [UMessage setAlias:self.nametext.text type:[self.selecttype titleForState:UIControlStateNormal] response:^(id responseObject, NSError *error) {
        if(responseObject)
        {
            [self showMessageAlert:@"绑定成功！"];
        }
        else
        {
            [self showMessageAlert:error.localizedDescription];
        }
    }];
#endif
}
- (IBAction)RemoveAlias:(id)sender {
    NSLog(@"self nameTextField [%@]",self.nametext.text);
    
#ifdef UM_Swift
    [UMessageSwiftInterface removeAliasWithName:self.nametext.text type:[self.selecttype titleForState:UIControlStateNormal] response:^(id _Nonnull responseObject, NSError * _Nonnull error) {
        if(responseObject)
        {
            [self showMessageAlert:@"删除成功！"];
        }
        else
        {
            [self showMessageAlert:error.localizedDescription];
        }
    }];
#else
    [UMessage removeAlias:self.nametext.text type:[self.selecttype titleForState:UIControlStateNormal] response:^(id responseObject, NSError *error) {
        if(responseObject)
        {
            [self showMessageAlert:@"删除成功！"];
        }
        else
        {
            [self showMessageAlert:error.localizedDescription];
        }
    }];
#endif
}

- (NSArray *)getTagsWithString:(NSString *)string
{
    if(string == nil)
    {
        return nil;
    }
    
    NSArray *sepArray = [string componentsSeparatedByString:@","];
    
    __autoreleasing NSMutableArray *array = [[NSMutableArray alloc] initWithArray:sepArray];
    
    for(NSString *str in sepArray)
    {
        if([str length]==0)
        {
            [array removeObject:str];
        }
    }
    
    return array;
}

- (void)showMessageAlert:(NSString *)message
{
    if([message length])
    {
        //处理前台消息框弹出
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Notification",@"Notification") message:message delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"OK") otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        NSLog(@"showMessageAlert: Message is nil...[%@]",message);
    }
    
}
@end
