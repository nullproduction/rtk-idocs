//
//  HFSUITextView.m
//  iDoc
//
//  Created by mark2 on 12/25/10.
//  Copyright 2010 KORUS Consulting. All rights reserved.
//

#import "iDocUITextView.h"
#import "Constants.h"
#import "iPadThemeBuildHelper.h"


@implementation iDocUITextView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		self.backgroundColor = [UIColor clearColor];
		backgroundTiledView = [[iPadPanelBodyBackgroundView alloc] initWithPrefix:@"modal_popup_background" suffix:@"_subbody" tileSize:15];
		backgroundTiledView.userInteractionEnabled = NO;
		[self addSubview:backgroundTiledView];
		[self sendSubviewToBack:backgroundTiledView];
		
		textEditView = [[UITextView alloc] init];
		textEditView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		textEditView.editable = YES;
		textEditView.scrollEnabled = YES;
		textEditView.enablesReturnKeyAutomatically = YES;
		textEditView.textAlignment = UITextAlignmentLeft;		
		textEditView.font = [UIFont systemFontOfSize:constMediumFontSize];
        textEditView.textColor = [iPadThemeBuildHelper commonTextFontColor1]; 
		textEditView.returnKeyType = UIReturnKeyDefault;
		textEditView.autocorrectionType = UITextAutocorrectionTypeDefault;
		textEditView.autocapitalizationType = UITextAutocapitalizationTypeNone;
		textEditView.keyboardType = UIKeyboardTypeDefault;
        textEditView.keyboardAppearance = UIKeyboardAppearanceDefault;
		textEditView.backgroundColor = [UIColor clearColor];		
		[self addSubview:textEditView];
		
    }
    return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	backgroundTiledView.frame = self.bounds;
	textEditView.frame = CGRectInset(self.bounds, 5, 5);
}

- (void)setDelegate:(id<UITextViewDelegate>)newDelegate {
	textEditView.delegate = newDelegate;
}

- (id<UITextViewDelegate>)getDelegate {
	return textEditView.delegate;
}

- (NSString *)getText {
	return textEditView.text;
}

- (void)setText:(NSString *)newText {
	textEditView.text = newText;
}

- (void)dealloc {
	[textEditView release];
	[backgroundTiledView release];
    
    [super dealloc];
}


@end
