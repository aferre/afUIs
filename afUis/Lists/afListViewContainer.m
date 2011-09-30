//
//  afListViewContainer.m
//  afLibBrowser
//
//  Created by Adrien Ferré on 27/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "afListViewContainer.h"
#import "afHorizontalListView.h"

#define PGHeight 20
#define TITLEHeight 20
#define SUBTITLEHeight 20

@implementation afListViewContainer

@synthesize theTitle,theSubtitle,thePageControl,theListView,style,delegate;
@synthesize hasTitle,hasSubtitle,hasPageControl;

#pragma mark -
#pragma mark == Init ==
#pragma mark -

- (id) initWithFrame:(CGRect)frame
	 andListViewSize:(CGSize)listViewSize{
	
    if ((self = [super initWithFrame:frame])) {
		
		self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
		self.autoresizesSubviews = YES;
		
		theListView = [[afHorizontalListView alloc] initWithFrame:CGRectMake(0, 0, listViewSize.width, listViewSize.height) 
													andDataSource:self 
													 hasNavArrows:YES];
		theListView.selectionDelegate = self;
		[self addSubview:theListView];
		
    }
    return self;
}

- (id) initWithOrigin:(CGPoint)origin
	  andListViewSize:(CGSize)listViewSize
			 andStyle:(afListViewStyle)s{
	
	CGFloat h = listViewSize.height + [self computeViewHeightForStyle:s];
	
    if ((self = [self initWithFrame:CGRectMake(origin.x, origin.y, listViewSize.width, h)
					andListViewSize:listViewSize])) {
		
		[self setStyle:s];
		
    }
    return self;
}

#pragma mark -
#pragma mark == listView DataSource Delegate ==
#pragma mark -

- (int) numberOfItems:(afListView *)listView{
	return 25;
}

- (UIView *) listView:(afListView *)listView 
		 viewForIndex:(int)theIndex{
	UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png",theIndex]];
	UIImageView *iv = [[UIImageView alloc] initWithImage:img];
	iv.userInteractionEnabled = YES;
	return [iv autorelease];
}

#pragma mark -
#pragma mark == listView selection Delegate ==
#pragma mark -

- (void) isUnderSelection:(int)index{
	if (thePageControl) {
		thePageControl.currentPage = index;
	}
	if (theTitle) {
		theTitle.text = [NSString stringWithFormat:@"%d",index];
	}
	if (theSubtitle) {
		theSubtitle.text = [NSString stringWithFormat:@"%d",index];
	}
}

- (void) selectedIndex:(int)index{

}

- (void) hasBeenSelectedByUser:(NSString *)theID{
	
}

- (void) clicked{

}


-(CGFloat) computeViewHeightForStyle:(afListViewStyle) s{
	
	switch (s) {
		case PageControl:
			return PGHeight + 5;
			break;
		case Title:
			return 5 + 20;
			break;
		case PageControl_Title:
			return PGHeight + 5 + 5 + 20;
			break;
		case PageControl_Title_Subtitle:
			return PGHeight + 5 + 5 + 20 + 5 + 20;
			break;
		case Title_Subtitle:
			return 5 + 20 + 5 + 20;
			break;
		default:
			return 0;
			break;
	}
	
}

-(void) pageChanged:(id)sender{
	[theListView setSelectedAndAnimate: thePageControl.currentPage + 1 ];
}

- (void) setStyle:(afListViewStyle)theStyle{
	style = theStyle;
	switch (theStyle) {
		case PageControl:{
			if (!thePageControl) {
				thePageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0,
																				 theListView.frame.size.height + theListView.frame.origin.y + 5, 
																				 self.frame.size.width, 
																				 PGHeight)];
				thePageControl.backgroundColor = [UIColor blackColor];
				[thePageControl addTarget:self action:@selector(pageChanged) forControlEvents:UIControlEventValueChanged];
				thePageControl.userInteractionEnabled = YES;
				thePageControl.hidden = NO;	
			}
			thePageControl.numberOfPages = [theListView.listViews.subviews count];
			
			if (!thePageControl.superview) {
				[self addSubview:thePageControl];
			}
		}
			break;
		case Title:
		{
			if (!theTitle) {
				theTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 
																	 theListView.frame.size.height + theListView.frame.origin.y + 5, 
																	 self.frame.size.width,
																	 20)];
				[theTitle setTextColor:[UIColor blackColor]];
				[theTitle setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
				[theTitle setBackgroundColor:[UIColor clearColor]];
				[theTitle setTextAlignment:UITextAlignmentCenter];
				[theTitle setLineBreakMode:UILineBreakModeTailTruncation];
				theTitle.numberOfLines = 1;	
				theTitle.hidden = NO;
			}
			[theTitle setText:@"title"];
			if (!theTitle.superview) {
				[self addSubview:theTitle];
			}
			
		}
			break;
		case PageControl_Title:
		{
			if (!thePageControl) {
				thePageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0,
																				 theListView.frame.size.height + theListView.frame.origin.y + 5, 
																				 self.frame.size.width, 
																				 PGHeight)];
				thePageControl.backgroundColor = [UIColor blackColor];
				[thePageControl addTarget:self action:@selector(pageChanged) forControlEvents:UIControlEventValueChanged];
				thePageControl.userInteractionEnabled = YES;
				thePageControl.hidden = NO;	
			}
			thePageControl.numberOfPages = [theListView.listViews.subviews count];
			
			if (!thePageControl.superview) {
				[self addSubview:thePageControl];
			}
			
			
			if (!theTitle) {
				theTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 
																	 thePageControl.frame.size.height + thePageControl.frame.origin.y + 5, 
																	 self.frame.size.width,
																	 20)];
				[theTitle setTextColor:[UIColor blackColor]];
				[theTitle setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
				[theTitle setBackgroundColor:[UIColor clearColor]];
				[theTitle setTextAlignment:UITextAlignmentCenter];
				[theTitle setLineBreakMode:UILineBreakModeTailTruncation];
				theTitle.numberOfLines = 1;	
				theTitle.hidden = NO;
			}
			[theTitle setText:@"title"];
			if (!theTitle.superview) {
				[self addSubview:theTitle];
			}
			
		}
			break;
		case PageControl_Title_Subtitle:
		{
			if (!thePageControl) {
				thePageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0,
																				 theListView.frame.size.height + theListView.frame.origin.y + 5, 
																				 self.frame.size.width, 
																				 PGHeight)];
				thePageControl.backgroundColor = [UIColor blackColor];
				[thePageControl addTarget:self action:@selector(pageChanged:) forControlEvents:UIControlEventValueChanged];
				thePageControl.userInteractionEnabled = YES;
				thePageControl.hidden = NO;	
			}
			thePageControl.numberOfPages = [theListView.listViews.subviews count];
			
			if (!thePageControl.superview) {
				[self addSubview:thePageControl];
			}
			
			
			if (!theTitle) {
				theTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 
																	 thePageControl.frame.size.height + thePageControl.frame.origin.y + 5, 
																	 self.frame.size.width,
																	 20)];
				[theTitle setTextColor:[UIColor blackColor]];
				[theTitle setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
				[theTitle setBackgroundColor:[UIColor clearColor]];
				[theTitle setTextAlignment:UITextAlignmentCenter];
				[theTitle setLineBreakMode:UILineBreakModeTailTruncation];
				theTitle.numberOfLines = 1;	
				theTitle.hidden = NO;
			}
			[theTitle setText:@"title"];
			if (!theTitle.superview) {
				[self addSubview:theTitle];
			}
			
			if (!theSubtitle) {
				
				theSubtitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 
																		theTitle.frame.size.height + theTitle.frame.origin.y + 5, 
																		self.frame.size.width,
																		20)];
				[theSubtitle setTextColor:[UIColor blackColor]];
				[theSubtitle setFont:[UIFont fontWithName:@"Helvetica" size:12]];
				[theSubtitle setBackgroundColor:[UIColor clearColor]];
				[theSubtitle setTextAlignment:UITextAlignmentCenter];
				[theSubtitle setLineBreakMode:UILineBreakModeTailTruncation];
				theSubtitle.numberOfLines = 1;
				theSubtitle.hidden = NO;
			}
			
			[theSubtitle setText:@"subtitle"];
			
			if (!theSubtitle.superview) {
				[self addSubview:theSubtitle];
			}
			
		}
			break;
		case Title_Subtitle:
			if (!theTitle) {
				theTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 
																	 theListView.frame.size.height + theListView.frame.origin.y + 5, 
																	 self.frame.size.width,
																	 20)];
				[theTitle setTextColor:[UIColor blackColor]];
				[theTitle setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
				[theTitle setBackgroundColor:[UIColor clearColor]];
				[theTitle setTextAlignment:UITextAlignmentCenter];
				[theTitle setLineBreakMode:UILineBreakModeTailTruncation];
				theTitle.numberOfLines = 1;	
				theTitle.hidden = NO;
			}
			[theTitle setText:@"title"];
			if (!theTitle.superview) {
				[self addSubview:theTitle];
			}
			
			if (!theSubtitle) {
				
				theSubtitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 
																		theTitle.frame.size.height + theTitle.frame.origin.y + 5, 
																		self.frame.size.width,
																		20)];
				[theSubtitle setTextColor:[UIColor blackColor]];
				[theSubtitle setFont:[UIFont fontWithName:@"Helvetica" size:12]];
				[theSubtitle setBackgroundColor:[UIColor clearColor]];
				[theSubtitle setTextAlignment:UITextAlignmentCenter];
				[theSubtitle setLineBreakMode:UILineBreakModeTailTruncation];
				theSubtitle.numberOfLines = 1;
				theSubtitle.hidden = NO;
			}
			
			[theSubtitle setText:@"subtitle"];
			
			if (!theSubtitle.superview) {
				[self addSubview:theSubtitle];
			}
			
			break;
		default:
			break;
	}
}

- (void) setHasTitle:(BOOL)hasIt{
	hasTitle = hasIt;
	if (hasIt) {
		
		if (!theTitle) {
			if (!thePageControl) theTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 
																					  theListView.frame.size.height + theListView.frame.origin.y + 5, 
																					  self.frame.size.width,
																					  20)];
			else theTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 
																	  thePageControl.frame.size.height + thePageControl.frame.origin.y + 5, 
																	  self.frame.size.width,
																	  20)];
		}
		[theTitle setTextColor:[UIColor blackColor]];
		[theTitle setText:@"title"];
		[theTitle setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
		[theTitle setBackgroundColor:[UIColor clearColor]];
		[theTitle setTextAlignment:UITextAlignmentCenter];
		[theTitle setLineBreakMode:UILineBreakModeTailTruncation];
		//	 theTitle.shadowColor = [UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1.0];
		//	 theTitle.shadowOffset = CGSizeMake(0,1);
		theTitle.numberOfLines = 1;	
		theTitle.hidden = NO;
		
		if (!theTitle.superview) {
			[self addSubview:theTitle];
		}
	}
	else {
		if (theTitle) {
			theTitle.hidden = YES;
		}
	}
	
}

- (void) setHasSubtitle:(BOOL) hasIt{
	hasSubtitle = hasIt;
	if (hasIt) {
		
		if (!theSubtitle) {
			
			if (theTitle) {
				theSubtitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 
																		theTitle.frame.size.height + theTitle.frame.origin.y + 5, 
																		self.frame.size.width,
																		20)];
				
			}
			else if (thePageControl) {
				theSubtitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 
																		thePageControl.frame.size.height + thePageControl.frame.origin.y + 5, 
																		self.frame.size.width,
																		20)];
				
			}
			
		}
		
		[theSubtitle setTextColor:[UIColor blackColor]];
		[theSubtitle setText:@"subtitle"];
		[theSubtitle setFont:[UIFont fontWithName:@"Helvetica" size:12]];
		[theSubtitle setBackgroundColor:[UIColor clearColor]];
		[theSubtitle setTextAlignment:UITextAlignmentCenter];
		[theSubtitle setLineBreakMode:UILineBreakModeTailTruncation];
		//	 theTitle.shadowColor = [UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1.0];
		//	 theTitle.shadowOffset = CGSizeMake(0,1);
		theSubtitle.numberOfLines = 1;
		theSubtitle.hidden = NO;
		if (!theSubtitle.superview) {
			[self addSubview:theSubtitle];
		}
	}
	else {
		if (theSubtitle) {
			theSubtitle.hidden = YES;
		}
	}
	
	
}

- (void) setHasPG:(BOOL)hasIt{
	hasPageControl = hasIt;
	if (hasIt) {
		
		if (!thePageControl) 
			thePageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0,
																			 theListView.frame.size.height + theListView.frame.origin.y + 5, 
																			 self.frame.size.width, 
																			 5)];
		
		thePageControl.backgroundColor = [UIColor blackColor];
		thePageControl.numberOfPages = [theListView.listViews.subviews count];
		
		[thePageControl addTarget:self action:@selector(pageChanged) forControlEvents:UIControlEventValueChanged];
		thePageControl.userInteractionEnabled = YES;
		thePageControl.hidden = NO;	
		if (!thePageControl.superview) {
			[self addSubview:thePageControl];
		}
	}
	else {
		if (thePageControl) 
			thePageControl.hidden = YES;
	}
	
}

- (void)dealloc {
	[super dealloc];
}


@end
