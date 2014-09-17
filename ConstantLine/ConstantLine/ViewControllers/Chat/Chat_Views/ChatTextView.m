//
//  ChatTextView.m
//  WazZupCafe
//
//  Created by octal i-phone2 on 4/6/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "ChatTextView.h"
#import "Config.h"
#import "AppDelegate.h"
//@protocol ChatTextViewDelegate <NSObject>
//@end

@implementation ChatTextView
@synthesize hPGrowingTextView,isOpen,lblCharacterCount;

- (id)initWithFrame:(CGRect)frame delegate:(id)delegate{
    
    self = [super initWithFrame:frame];
    if (self) {
                
       // if ([checkComment isEqualToString:@"Comment"] || [checkComment isEqualToString:@"UserPost"]) {
            
            self.hPGrowingTextView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(40, 3, 220, 40)];
            self.hPGrowingTextView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
            self.hPGrowingTextView.minNumberOfLines = 1;
            self.hPGrowingTextView.maxNumberOfLines = 6;
            self.hPGrowingTextView.returnKeyType = UIReturnKeyGo;
            self.hPGrowingTextView.font = [UIFont systemFontOfSize:18.0f];
            self.hPGrowingTextView.delegate =delegate;
            self.hPGrowingTextView.internalTextView.autocapitalizationType=UITextAutocapitalizationTypeSentences;
            self.hPGrowingTextView.internalTextView.autocorrectionType=UITextAutocorrectionTypeYes;
            self.hPGrowingTextView.internalTextView.clearsContextBeforeDrawing=TRUE;
            self.hPGrowingTextView.backgroundColor = [UIColor whiteColor];
            self.hPGrowingTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.hPGrowingTextView.returnKeyType=UIReturnKeyDone;
            
            UIImage *rawEntryBackground = [UIImage imageNamed:@"MessageEntryInputField.png"];
            UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
            
            UIImageView *entryImageView = [[UIImageView alloc] initWithImage:entryBackground];
            entryImageView.frame = CGRectMake(40, 0, 220, 40);
            entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            
            UIImage *rawBackground = [UIImage imageNamed:@"MessageEntryBackground.png"];
            
            UIImage *background = [rawBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
            
            UIImageView *imageView = [[[UIImageView alloc] initWithImage:background] autorelease];
            imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
            imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            
            
            
            // view hierachy
            [self addSubview:imageView];
            [self addSubview:self.hPGrowingTextView];
            [self addSubview:entryImageView];
            
           /* UIImage *sendBtnBackground = [[UIImage imageNamed:@"camera.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
            
            UIButton *camaraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            if ([AppDelegate sharedAppDelegate ].appType==kDeviceTypeiPad) {
            camaraBtn.frame = CGRectMake(-234, 5, 35, 32);
            }
            else{
                camaraBtn.frame = CGRectMake(2, 5, 35, 32);    
            }
            camaraBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
            [camaraBtn setTitle:@"" forState:UIControlStateNormal];
            
            [camaraBtn setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.4] forState:UIControlStateNormal];
            camaraBtn.titleLabel.shadowOffset = CGSizeMake (0.0, -1.0);
            camaraBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
            
            [camaraBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [camaraBtn addTarget:delegate action:@selector(camaraBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
            [camaraBtn setImage:sendBtnBackground forState:UIControlStateNormal];
           // [camaraBtn setBackgroundImage:selectedSendBtnBackground forState:UIControlStateSelected];
            [self addSubview:camaraBtn];*/
        
        lblCharacterCount=[[UILabel alloc] initWithFrame:CGRectMake(10, 15, 35, 15)];
        [lblCharacterCount setText:@"330"];
        [lblCharacterCount setTextColor:[UIColor blackColor]];
        [lblCharacterCount setBackgroundColor:[UIColor clearColor]];
        [lblCharacterCount setFont:[UIFont fontWithName:@"Arial" size:12]];
        [self addSubview:lblCharacterCount];
            
            self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
            
            
            UIImage *sendBtnBackground1 = [[UIImage imageNamed:@"loginBtn.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
            UIImage *selectedSendBtnBackground1 = [[UIImage imageNamed:@"MessageEntrySendButton.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
            
            UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            doneBtn.frame = CGRectMake(260, 8, 55, 25);
            doneBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
            [doneBtn setTitle:@"Send" forState:UIControlStateNormal];
            
            [doneBtn setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.4] forState:UIControlStateNormal];
            doneBtn.titleLabel.shadowOffset = CGSizeMake (0.0, -1.0);
            doneBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
            
            [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [doneBtn addTarget:delegate action:@selector(sendCommentBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
            [doneBtn setBackgroundImage:sendBtnBackground1 forState:UIControlStateNormal];
            [doneBtn setBackgroundImage:selectedSendBtnBackground1 forState:UIControlStateSelected];
            [self addSubview:doneBtn];
            
      //  }
      /*  else
        {
            self.hPGrowingTextView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(10, 3, 240, 40)];
            self.hPGrowingTextView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
            self.hPGrowingTextView.minNumberOfLines = 1;
            self.hPGrowingTextView.maxNumberOfLines = 6;
            self.hPGrowingTextView.returnKeyType = UIReturnKeyGo;
            self.hPGrowingTextView.font = [UIFont systemFontOfSize:18.0f];
            self.hPGrowingTextView.delegate =delegate;
            self.hPGrowingTextView.internalTextView.autocapitalizationType=UITextAutocapitalizationTypeSentences;
            self.hPGrowingTextView.internalTextView.autocorrectionType=UITextAutocorrectionTypeYes;
            self.hPGrowingTextView.internalTextView.clearsContextBeforeDrawing=TRUE;
            self.hPGrowingTextView.backgroundColor = [UIColor whiteColor];
            self.hPGrowingTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            
            UIImage *rawEntryBackground = [UIImage imageNamed:@"MessageEntryInputField.png"];
            UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
            
            UIImageView *entryImageView = [[UIImageView alloc] initWithImage:entryBackground];
            entryImageView.frame = CGRectMake(10, 0, 240, 40);
            entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            
            UIImage *rawBackground = [UIImage imageNamed:@"MessageEntryBackground.png"];
            
            UIImage *background = [rawBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
            
            UIImageView *imageView = [[[UIImageView alloc] initWithImage:background] autorelease];
            imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
            imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            
            
            
            // view hierachy
            [self addSubview:imageView];
            [self addSubview:self.hPGrowingTextView];
            [self addSubview:entryImageView];
            self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
            
            
            UIImage *sendBtnBackground = [[UIImage imageNamed:@"loginBtn.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
            UIImage *selectedSendBtnBackground = [[UIImage imageNamed:@"MessageEntrySendButton.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
            
            UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            doneBtn.frame = CGRectMake(250, 8, 55, 25);
            doneBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
            [doneBtn setTitle:@"Send" forState:UIControlStateNormal];
            
            [doneBtn setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.4] forState:UIControlStateNormal];
            doneBtn.titleLabel.shadowOffset = CGSizeMake (0.0, -1.0);
            doneBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
            
            [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [doneBtn addTarget:delegate action:@selector(sendCommentBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
            [doneBtn setBackgroundImage:sendBtnBackground forState:UIControlStateNormal];
            [doneBtn setBackgroundImage:selectedSendBtnBackground forState:UIControlStateSelected];
            [self addSubview:doneBtn];
            

        }*/
        
        [lblCharacterCount release];
        [self.hPGrowingTextView release];
        
    }
    return self;
}
- (void)dealloc {
    [super dealloc];
}


@end
