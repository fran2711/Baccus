//
//  FJLWebViewController.h
//  Baccus
//
//  Created by Fran Lucena on 28/12/15.
//  Copyright © 2015 Fran Lucena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FJLWineModel.h"

@interface FJLWebViewController : UIViewController <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *browserView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@property (strong, nonatomic) FJLWineModel *model;

- (id)initWithModel:(FJLWineModel *) aModel;

@end
