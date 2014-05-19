//
//  DKCBackgroundImage.m
//  Score Cricket
//
//  Created by Dinesh Challa on 5/17/14.
//
//

#import "DKCBackgroundImage.h"
#import "UIImage+ImageEffects.h"

@implementation DKCBackgroundImage

+ (UIImage *)backgroundImage
{
	UIImage *backgroundImage = [UIImage imageNamed:@"ScoreCricketOpeningDarkBlue-568h.png"];
	backgroundImage = [backgroundImage applyBlurWithRadius:50 tintColor:[UIColor colorWithWhite:0.1 alpha:0.7] saturationDeltaFactor:1 maskImage:nil];
	return backgroundImage;
}

+ (UIImage *)backgroundImageWithImage:(UIImage *)image
{
	image = [image applyBlurWithRadius:50 tintColor:nil saturationDeltaFactor:1 maskImage:nil];
	return image;
}

@end
