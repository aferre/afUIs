//
//  EtudiantNavBar.h
//  Etudiant
//
//  Created by adrien ferré on 14/07/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EtudiantNavBar : UIView {
	
	UIButton *backButton;
	
	UIButton *modifyButton;
	
	UILabel *titleLabel;
	
	UILabel *subtitleLabel;
	
	UILabel *rightLabel;
	
	UIImageView *logoImage;
}
@property (nonatomic,retain) UIImageView *logoImage;
@property (nonatomic,retain) UIButton *backButton;
@property (nonatomic,retain) UIButton *modifyButton;
@property (nonatomic,retain) UILabel *titleLabel;
@property (nonatomic,retain) UILabel *subtitleLabel;
@property (nonatomic,retain) UILabel *rightLabel;

-(void)showModifyButton:(BOOL)showIt animated:(BOOL)animated;
-(void)showBackButton:(BOOL)showIt animated:(BOOL)animated;

@end
