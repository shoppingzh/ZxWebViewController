//
//  HomeUI.m
//  ZxWebViewControllerDemo
//
//  Created by xpzheng on 2020/5/13.
//  Copyright © 2020 xpzheng. All rights reserved.
//

#import "HomeUI.h"
#import "ZxWebViewController.h"

@interface HomeUI ()
@property (weak, nonatomic) IBOutlet UITextField *linkTextField;

@end

@implementation HomeUI

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"首页";
}

- (IBAction)openLink:(id)sender {
    ZxWebViewController *zxWebViewUI = [[ZxWebViewController alloc] initWithUrl:self.linkTextField.text];
    [self.navigationController pushViewController:zxWebViewUI animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
