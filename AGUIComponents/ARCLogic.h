//
//  ARCLogic.h
//  AGUIComponents
//
//  Created by Austen Green on 8/7/11.
//  Copyright 2011 Austen Green Consulting. All rights reserved.
//

#ifndef AGUIComponents_ARCLogic_h
#define AGUIComponents_ARCLogic_h

#ifndef ARCLOGIC

/*
 * Provides an easier/cleaner way to create a no arc code block:
 * NO_ARC - Compiles the code block argument only if ARC is available
 * example: NO_ARC([obj release])
 * (accepts multi-line arguments)
 *
 * Provides an easier/cleaner way to put an arc conditional inline:
 * IF_ARC - Compiles the one of the code block argument conditionally
 * example: id someVar = IF_ARC(myObj, [myObj autorelease])
 * (accepts multi-line arguments)
 * 
 * STRONGRETAIN & WEAKASSIGN can be used to create @property declarations
 * that will work both in and out of ARC
 * @property (STRONGRETAIN, nonatomic) id foo;
 * (Don't forget weak and assign are mostly the same, but weak is self zeroing in iOS 5
 */

#define HASARC __has_feature(obc_arc)

#if HASARC
#define STRONGRETAIN strong
#define WEAKASSIGN weak
#define NO_ARC(BLOCK_NO_ARC) ;
#define IF_ARC(BLOCK_ARC, BLOCK_NO_ARC) BLOCK_ARC
#else
#define STRONGRETAIN retain
#define WEAKASSIGN assign
#define NO_ARC(BLOCK_NO_ARC) BLOCK_NO_ARC
#define IF_ARC(BLOCK_ARC, BLOCK_NO_ARC) BLOCK_NO_ARC
#endif

#define ARCLOGIC
#endif

#endif
