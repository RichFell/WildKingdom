//
//  AnimalObject.h
//  WildKingdom
//
//  Created by Richard Fellure on 5/31/14.
//  Copyright (c) 2014 Rich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnimalObject : NSObject

@property UIImage *animalImage;

-(AnimalObject *)initWithAnimalImage:(UIImage *)animalImage;

@end
