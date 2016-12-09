//
//  LTNPromptView.m
//  lingtouniao
//
//  Created by LiuFeifei on 15/12/3.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "LTNPromptView.h"

@interface LTNPromptView ()<UITextViewDelegate>

@property (nonatomic, strong) UITextView * messageView;

@end

@implementation LTNPromptView

- (instancetype)initWithIcon:(NSString *)iconName iconSpace:(CGFloat)space Text:(NSString *)text font:(UIFont *)font textWidth:(CGFloat)textMaxWidth
{
    self = [super init];
    if (self) {
        [self setupUIWithIcon:(NSString *)iconName iconSpace:(CGFloat)space Text:(NSString *)text font:(UIFont *)font textWidth:(CGFloat)textMaxWidth];
    }
    return self;
}

- (void)setupUIWithIcon:(NSString *)iconName iconSpace:(CGFloat)space Text:(NSString *)text font:(UIFont *)font textWidth:(CGFloat)textMaxWidth
{
    // icon
    UIImage * icon = [UIImage imageNamed:iconName];
    UIImageView * promptImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, icon.size.width, icon.size.height)];
    promptImageView.image = icon;
    
    // TextView
    NSDictionary * attribute = @{NSFontAttributeName : font};
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(textMaxWidth-icon.size.width-space, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    UITextView * messageView = [[UITextView alloc] initWithFrame:CGRectMake(icon.size.width + space, 0, textMaxWidth-icon.size.width-space, textSize.height + 10)];
    messageView.backgroundColor = [UIColor clearColor];
    messageView.editable = NO;
    messageView.contentInset = UIEdgeInsetsMake(-8.f, 0.f, 8.f, 0.f);
    messageView.font = font;
    messageView.linkTextAttributes = @{NSForegroundColorAttributeName : COLOR_MAIN, NSFontAttributeName : kFont(6)};
    messageView.attributedText = [self filterHTML:text];
    messageView.delegate = self;
    messageView.userInteractionEnabled = self.allowUserInteraction;
    self.messageView = messageView;
    
    // promptView
    self.frame = CGRectMake(0, 0, icon.size.width + space + messageView.width, messageView.height);
    [self addSubview:promptImageView];
    [self addSubview:messageView];
}

+ (instancetype)promptWithIcon:(NSString *)iconName iconSpace:(CGFloat)space Text:(NSString *)text font:(UIFont *)font textWidth:(CGFloat)textMaxWidth
{
    LTNPromptView * promptView = [[LTNPromptView alloc] initWithIcon:iconName iconSpace:space Text:text font:font textWidth:textMaxWidth];
    
    return promptView;
}

- (void)setAllowUserInteraction:(BOOL)allowUserInteraction
{
    _allowUserInteraction = allowUserInteraction;
    self.messageView.userInteractionEnabled = allowUserInteraction;
}

// 去掉字符串中的html标签
- (NSMutableAttributedString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    NSMutableArray * rangArray = [NSMutableArray array];
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        [rangArray addObject:@([html rangeOfString:@"<"].location)];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    
    NSMutableAttributedString * stringM = [[NSMutableAttributedString alloc] initWithString:html];
    [stringM addAttribute:NSForegroundColorAttributeName value:HexRGB(0x8a8a8a) range:NSMakeRange(0, html.length)];
    if (rangArray.count >= 2) {
        NSRange linkRange = NSMakeRange([rangArray[0] integerValue], [rangArray[1] integerValue] - [rangArray[0] integerValue]);
        NSString * tel = [html substringWithRange:linkRange];
        [stringM addAttribute:NSLinkAttributeName value:[NSString stringWithFormat:@"username://%@", tel] range:linkRange];
        [stringM addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, html.length)];
    }
    return stringM;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    if ([[URL scheme] isEqualToString:@"username"]) {
        // do something with this username
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"4009999980"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        // ...
        return NO;
    }
    return YES; // let the system open this URL
}

@end
