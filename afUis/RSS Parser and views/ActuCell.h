//
//  ActuCell.h
//  Etudiant
//
//  Created by Mac Mini 1 MoMac on 13/07/10.
//  Copyright 2010 MoMac. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ActuCell : UITableViewCell {
	
	UILabel *theTitleLabel;
	UILabel *theSubtitleLabel;
	
	UIImageView *theCornerView;
	
}

@property (nonatomic,retain) IBOutlet UILabel *theTitleLabel;
@property (nonatomic,retain) UIImageView *theCornerView;
@property (nonatomic,retain) IBOutlet UILabel *theSubtitleLabel;

-(void)hasCornerView:(BOOL)hasIt;

@end
