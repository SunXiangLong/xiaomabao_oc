//
//  MBBabySearchViewController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/1/27.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBBabySearchViewController.h"
#import "MBVaccineViewController.h"
@interface MBBabySearchViewController ()<UITextFieldDelegate>
{
    UITextField *_searchField;
    BOOL _Search;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation MBBabySearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self show:@"加载中..."];
    _webView.scalesPageToFit = YES;
    _webView.backgroundColor = [UIColor colorR:205 colorG:222 colorB:232];
    NSURLRequest* request = [NSURLRequest requestWithURL:_url];//创建NSURLRequest
    [_webView loadRequest:request];//加载
    if (_isSearch) {
        [self setSearchUI];
        [_searchField becomeFirstResponder];
    }
   
}
- (void)setSearchUI{
    UITextField *searchField = [[UITextField alloc] init];
    searchField.layer.cornerRadius = 5;
    searchField.delegate = self;
    searchField.backgroundColor = [UIColor whiteColor];
    searchField.font = [UIFont systemFontOfSize:15];
    searchField.textColor = [UIColor grayColor];
    searchField.placeholder = @"点击搜索...";
    searchField.returnKeyType = UIReturnKeySearch;
    
    [self.view addSubview:searchField];
    
    [searchField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(27);
        make.left.equalTo(self.navBar.leftButton.mas_right).offset(10);
        make.right.equalTo(self.navBar.rightButton.mas_left).offset(-10);
        make.height.mas_equalTo(30);
    }];
    
    UIView *searchLeftView = [[UIView alloc] init];
    searchLeftView.frame = CGRectMake(0, 0, 35, searchField.frame.size.height);
    
    UIImageView *searchImageView = [[UIImageView alloc] init];
    searchImageView.image = [UIImage imageNamed:@"search_icon"];
    
    
    
    searchImageView.contentMode = UIViewContentModeScaleAspectFit;
    searchImageView.frame = CGRectMake(10, (searchField.frame.size.height - 20) * 0.5, 20, 20);
    [searchLeftView addSubview:searchImageView];
    
    searchField.leftView = searchLeftView;
    searchField.leftViewMode = UITextFieldViewModeAlways;
    _searchField = searchField;
    
    [self ListeningKeyboard];
}
#pragma mark --注册监听键盘的通知
- (void)ListeningKeyboard{
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    
    
    
    
    
}
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    if (height!=0) {
        _bottom.constant = height;
    }
    
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    [UIView animateWithDuration:.5f animations:^{
         _bottom.constant = 0;
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSURL *url = request.mainDocumentURL;
    NSString *str = [NSString stringWithFormat:@"%@",url];
    NSString *str1 = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSArray *arr = [str1 componentsSeparatedByString:@"_title_"];


    
    
    
        
        if ([url isEqual:_url]) {
            return YES;
        }else{
            
                MBVaccineViewController *VC = [[MBVaccineViewController alloc] init];
                VC.url = url;
                VC.isSearch = NO;
                VC.title = arr.lastObject?arr.lastObject:@"疫苗纪录";
            
            if (_Search) {
                VC.title = _searchField.text;
                _searchField.text = @"";
            }

                [self pushViewController:VC Animated:YES];
            
           
                return NO;
            
         
            
        }
        

    
    
    
}
-(void)webViewDidStartLoad:(UIWebView*)webView {
    //当网页视图已经开始加载一个请求后，得到通知。
    
    //    [self show];
}
-(void)webViewDidFinishLoad:(UIWebView*)webView{
    //当网页视图结束加载一个请求之后，得到通知。
    
    [self dismiss];
}
-(void)webView:(UIWebView*)webView DidFailLoadWithError:(NSError*)error{
    //当在请求加载中发生错误时，得到通知。会提供一个NSSError对象，以标识所发生错误类
    NSLog(@"%@",error);
    [self show:@"加载失败" time:1];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
       [_searchField resignFirstResponder];
}
#pragma mark --点击取消按钮的代理方法

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_searchField resignFirstResponder];
    
    NSString  *urlstr = [NSString stringWithFormat:@"%@%@",self.urlstr,textField.text];
    
    NSURL *url = [NSURL URLWithString:[urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

    
    
   NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
    [_webView loadRequest:request];//加载
  
    _Search = YES;
    return YES;
}
@end
