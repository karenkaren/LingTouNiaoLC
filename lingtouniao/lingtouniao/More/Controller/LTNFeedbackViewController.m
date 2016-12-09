//
//  LTNFeedbackViewController.m
//  lingtouniao
//
//  Created by peijingwu on 12/29/15.
//  Copyright © 2015 lingtouniao. All rights reserved.
//

#import "LTNFeedbackViewController.h"
#import "PlaceHolderTextView.h"
#import "LTNServerConstant.h"

@interface LTNFeedbackViewController () <UITextViewDelegate>

@property (nonatomic) PlaceHolderTextView *contentTextView;
@property (nonatomic) UIButton *commitBtn;

@end

@implementation LTNFeedbackViewController

-(void)back
{
    NSString *string = [Utility trimWhitespace:_contentTextView.text];
    if (string.length > 0)
    {
        
        kWeakSelf
        [Utility showAlertTitle:locationString(@"dialog_call_service_title") msg:locationString(@"uncommitted_suggestion") cancelTitle:locationString(@"btn_cancel") commitBtnTitle:locationString(@"btn_confirm") handlerBlock:^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } onVC:self];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = locationString(@"tab_more_feedback");
    _contentTextView = [[PlaceHolderTextView alloc] initWithFrame:CGRectMake(15, 15, kScreenWidth - 30, 150)];
    _contentTextView.placeholder = locationString(@"feedback_hint");
    _contentTextView.backgroundColor = [UIColor whiteColor];
    _contentTextView.delegate = self;
    _contentTextView.layer.borderWidth = [Utility lineWidth];
    _contentTextView.layer.borderColor = [[UIColor colorWithHex:0xcccccc alpha:1.0] CGColor];
    _contentTextView.font = [CustomerizedFont heiti:16];
    _contentTextView.textColor = [UIColor blackColor];
    [self.view addSubview:_contentTextView];

    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(15, _contentTextView.bottom + 15, kScreenWidth - 30, kGeneralHeight)];
    [btn setTitle:locationString(@"submit") forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"confirmButton"] forState:UIControlStateNormal];
    btn.layer.cornerRadius = 3;
    btn.layer.masksToBounds = YES;
    btn.tappedBlock = ^(UIButton *btn) {
        [self commitAdvice];
    };
    [self.view addSubview:btn];
    _commitBtn = btn;
}

- (void)commitAdvice
{
    if (_loading) {
        return;
    }
    NSString *string = [Utility trimWhitespace:_contentTextView.text];
    if (string.length <= 0)
    {
        [Utility showAlert:locationString(@"empty_suggestion_error")];
        return;
    }
    
    NSDictionary *dict = @{@"feedBack" : string};
    kWeakSelf
    [self apiForPath:kFeedbackUrl method:kPostMethod parameter:dict responseModelClass:nil onComplete:^(id response, id data, NSError *error) {
        if (!error) {
            [Utility showMessageFromServer:data defaultMsg:locationString(@"feed_back_success")];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
}

#pragma mark -- textViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    [self.contentTextView scrollRangeToVisible:NSMakeRange(self.contentTextView.text.length - 1, 1)];
    return YES;
}

//ios 7 bug导致 输入汉字 最后 一行 截断、
- (void)textViewDidChange:(UITextView *)textView
{
    DLog(@"%@",textView.text);
    NSString *rangeStr = [textView textInRange:textView.markedTextRange];
    if (textView.text.length > kCommentMaxInputLength && rangeStr.length == 0) {
        [self performSelector:@selector(delayCutText) withObject:nil afterDelay:0];
    }else
    {
        // 解决 中文输入，遮挡拼音的问题
        [self.contentTextView scrollRangeToVisible:NSMakeRange(self.contentTextView.text.length - 1, 1)];
        
    }
    
    self.commitBtn.enabled = [textView.text length];
}

- (void)delayCutText
{
    NSString *origin = [self.contentTextView.text copy];
    NSString *shouldText = [origin substringWithRange:NSMakeRange(0, kCommentMaxInputLength)];
    self.contentTextView.text = shouldText;
    if (self.contentTextView.text.length > 0) {
        [self.contentTextView scrollRangeToVisible:NSMakeRange(self.contentTextView.text.length - 1, 1)];
    }
}

@end

