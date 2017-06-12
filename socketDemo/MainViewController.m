//
//  MainViewController.m
//  socketDemo
//
//  Created by 李自杨 on 2017/6/5.
//  Copyright © 2017年 View. All rights reserved.
//

//屏幕宽高
#define KWidth self.view.bounds.size.width
#define KHeight self.view.bounds.size.height
//根据苹果6的宽获取响应的宽等比
#define KWidthScale [UIScreen mainScreen].bounds.size.width/375
//根据苹果6的高获取响应的高等比
#define KHeightScale [UIScreen mainScreen].bounds.size.height/667

// 定义这个常量，就可以不用在开发过程中使用"mas_"前缀。
#define MAS_SHORTHAND
// 定义这个常量，就可以让Masonry帮我们自动把基础数据类型的数据，自动装箱为对象类型。
#define MAS_SHORTHAND_GLOBALS

#define C1 [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1]

#import "MainViewController.h"
#import <GCDAsyncSocket.h>
#import <Masonry.h>
#import "UILabel+SinceTheCustom.h"
#import "UITextField+SinceTheCustom.h"
#import "UIButton+SinceTheCustom.h"

@interface MainViewController ()<GCDAsyncSocketDelegate>

//IP地址
@property (nonatomic, strong) UITextField *addressTF;
//端口
@property (nonatomic, strong) UITextField *portTF;
//发送消息
@property (nonatomic, strong) UITextField *messageTF;
//显示
@property (nonatomic, strong) UITextView *showMessageTV;

//客户端socket
@property (nonatomic) GCDAsyncSocket *clientSocket;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    
    [self createUI];
    //初始化
    self.clientSocket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
}

#pragma mark -- UI
-(void)createUI{
    
    /*
     IP地址
    */
    UILabel *addressLabel = [[UILabel alloc]initWithText:@"IP地址" andTextColor:[UIColor orangeColor] andFont:16.0f andNSTextAlignment:NSTextAlignmentCenter andBorderColor:C1 andBorderWidth:1.0f];
    [self.view addSubview:addressLabel];
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(50 * KHeightScale);
        make.left.mas_equalTo(20 * KWidthScale);
        make.height.mas_equalTo(30 * KHeightScale);
        make.width.mas_equalTo(60 *KWidthScale);
    }];
    
    _addressTF = [[UITextField alloc]initWithText:@"192.168." andPlaceholder:@"请输入IP地址" andTextColor:[UIColor orangeColor] andFont:20.0f andNSTextAlignment:NSTextAlignmentCenter andBorderColor:C1 andBorderWidth:1.0f];
    [self.view addSubview:_addressTF];
    [_addressTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(50 * KHeightScale);
        make.left.mas_equalTo(addressLabel.right).offset(20 * KWidthScale);
        make.right.mas_equalTo(-20 * KWidthScale);
        make.height.mas_equalTo(30 * KHeightScale);
    }];
    
    /*
     端口号
     */
    UILabel *portLabel = [[UILabel alloc]initWithText:@"端口号" andTextColor:[UIColor orangeColor] andFont:16.0f andNSTextAlignment:NSTextAlignmentCenter andBorderColor:C1 andBorderWidth:1.0f];
    [self.view addSubview:portLabel];
    [portLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(addressLabel.bottom).offset(20 * KHeightScale);
        make.left.mas_equalTo(20 * KWidthScale);
        make.height.mas_equalTo(30 * KHeightScale);
        make.width.mas_equalTo(60 * KWidthScale);
    }];
    
    _portTF = [[UITextField alloc]initWithText:@"8888" andPlaceholder:@"请输入端口号" andTextColor:[UIColor orangeColor] andFont:20.0f andNSTextAlignment:NSTextAlignmentCenter andBorderColor:C1 andBorderWidth:1.0f];
    [self.view addSubview:_portTF];
    [_portTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_addressTF.bottom).offset(20 * KHeightScale);
        make.left.mas_equalTo(portLabel.right).offset(20 * KWidthScale);
        make.right.mas_equalTo(-20 * KWidthScale);
        make.height.mas_equalTo(30 * KHeightScale);
    }];
   
    /*
     开始连接
    */
    UIButton *connectBtn = [[UIButton alloc]initWithText:@"开始连接" andTextColor:[UIColor orangeColor] andFont:20.0f andNSTextAlignment:NSTextAlignmentCenter andBorderColor:C1 andBorderWidth:1.0f];
    [self.view addSubview:connectBtn];
    [connectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.centerX);
        make.top.mas_equalTo(_portTF.bottom).offset(20 * KHeightScale);
        make.width.mas_equalTo(100 * KWidthScale);
        make.height.mas_equalTo(30 * KHeightScale);
    }];
    [connectBtn addTarget:self action:@selector(connectClick:) forControlEvents:UIControlEventTouchUpInside];
    
    /*
     发送消息
     */
    _messageTF = [[UITextField alloc]initWithText:@"" andPlaceholder:@"请输入你要发送的消息" andTextColor:C1 andFont:16.0f andNSTextAlignment:NSTextAlignmentLeft andBorderColor:C1 andBorderWidth:1.0f];
    [self.view addSubview:_messageTF];
    [_messageTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(connectBtn.bottom).offset(20 * KHeightScale);
        make.left.mas_equalTo(20 * KWidthScale);
        make.width.mas_equalTo(250 *KWidthScale);
        make.height.mas_equalTo(30 * KHeightScale);
    }];
    
    UIButton *messageBtn = [[UIButton alloc]initWithText:@"发送" andTextColor:[UIColor orangeColor] andFont:16.0f andNSTextAlignment:NSTextAlignmentCenter andBorderColor:C1 andBorderWidth:1.0f];
    [self.view addSubview:messageBtn];
    [messageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_messageTF);
        make.left.mas_equalTo(_messageTF.right).offset(20 * KWidthScale);
        make.right.mas_equalTo(self.view.right).offset(-20 * KWidthScale);
        make.height.equalTo(_messageTF);
    }];
    [messageBtn addTarget:self action:@selector(sendMessageClick:) forControlEvents:UIControlEventTouchUpInside];
    
    /*
     接收消息
     */
    UIButton *receiveBtn = [[UIButton alloc]initWithText:@"接收消息" andTextColor:[UIColor orangeColor] andFont:16.0f andNSTextAlignment:NSTextAlignmentCenter andBorderColor:C1 andBorderWidth:1.0f];
    [self.view addSubview:receiveBtn];
    [receiveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.centerX);
        make.top.mas_equalTo(_messageTF.bottom).offset(20 * KHeightScale);
        make.width.mas_equalTo(100 * KWidthScale);
        make.height.mas_equalTo(30 * KHeightScale);
    }];
    [receiveBtn addTarget:self action:@selector(receiveMessageClick:) forControlEvents:UIControlEventTouchUpInside];
    
    /*
     显示面板
     */
    _showMessageTV = [[UITextView alloc]init];
    _showMessageTV.backgroundColor = C1;
    _showMessageTV.font = [UIFont systemFontOfSize:20.0f];
    [self.view addSubview:_showMessageTV];
    [_showMessageTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(receiveBtn.bottom).offset(20 * KHeightScale);
        make.left.mas_equalTo(20 * KWidthScale);
        make.right.mas_equalTo(-20 * KWidthScale);
        make.bottom.mas_equalTo(-20 *KHeightScale);
    }];

}

#pragma mark -- BTNCLICK
//开始链接
-(void)connectClick:(UIButton *)sender{
    //链接服务器
    [self.clientSocket connectToHost:self.addressTF.text onPort:self.portTF.text.integerValue withTimeout:-1 error:nil];
    
}
//发送消息
-(void)sendMessageClick:(UIButton *)sender{

    NSData *data = [self.messageTF.text dataUsingEncoding:NSUTF8StringEncoding];
    //withTimeout -1 : 无穷大
    //tag : 消息标记
    [self.clientSocket writeData:data withTimeout:-1 tag:0];
}
//接受消息
-(void)receiveMessageClick:(UIButton *)sender{
    
    [self.clientSocket readDataWithTimeout:11 tag:0];
}


#pragma mark -- GCDAsyncSocketDelegate
-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    
    [self showMessageWithStr:@"链接成功"];
    
    [self showMessageWithStr:[NSString stringWithFormat:@"服务器IP:%@",host]];
    
    [self.clientSocket readDataWithTimeout:-1 tag:0];
    
}

//收到消息
-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    
    NSString *text = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    [self showMessageWithStr:text];
    
    [self.clientSocket readDataWithTimeout:-1 tag:0];
    
}

//信息展示
- (void)showMessageWithStr:(NSString*)str{
    
    self.showMessageTV.text = [self.showMessageTV.text stringByAppendingFormat:@"%@\n",str];
    
}

//收键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    
}



@end
