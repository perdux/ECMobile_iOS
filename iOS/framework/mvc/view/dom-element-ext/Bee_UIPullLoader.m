//
//	 ______    ______    ______
//	/\  __ \  /\  ___\  /\  ___\
//	\ \  __<  \ \  __\_ \ \  __\_
//	 \ \_____\ \ \_____\ \ \_____\
//	  \/_____/  \/_____/  \/_____/
//
//
//	Copyright (c) 2014-2015, Geek Zoo Studio
//	http://www.bee-framework.com
//
//
//	Permission is hereby granted, free of charge, to any person obtaining a
//	copy of this software and associated documentation files (the "Software"),
//	to deal in the Software without restriction, including without limitation
//	the rights to use, copy, modify, merge, publish, distribute, sublicense,
//	and/or sell copies of the Software, and to permit persons to whom the
//	Software is furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//	IN THE SOFTWARE.
//

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Bee_UIPullLoader.h"
#import "UIView+BeeUISignal.h"
#import "UIView+BeeUILayout.h"
#import "UIView+LifeCycle.h"

#pragma mark -

#undef	ANIMATION_DURATION
#define ANIMATION_DURATION	(0.3f)

#pragma mark -

@interface BeeUIPullLoader()
{
	BOOL		_animated;
	BOOL		_inited;
	NSUInteger	_state;
}

- (void)initSelf;
//- (void)changeFrame:(CGRect)frame animated:(BOOL)animated;
//- (void)changeState:(NSInteger)state animated:(BOOL)animated;

@end

#pragma mark -

@implementation BeeUIPullLoader

DEF_SIGNAL( STATE_CHANGED )
DEF_SIGNAL( FRAME_CHANGED )

DEF_INT( STATE_NORMAL,	0 )
DEF_INT( STATE_PULLING,	1 )
DEF_INT( STATE_LOADING,	2 )

@synthesize state = _state;
@dynamic pulling;
@dynamic loading;
@synthesize animated = _animated;

static Class	__defaultClass = nil;
static CGSize	__defaultSize = { 0 };

+ (Class)defaultClass
{
	return __defaultClass;
}

+ (CGSize)defaultSize
{
	return __defaultSize;
}

+ (void)setDefaultClass:(Class)clazz
{
	__defaultClass = clazz;
}

+ (void)setDefaultSize:(CGSize)size
{
	__defaultSize = size;
}

+ (BeeUIPullLoader *)spawn
{
	CGRect frame = CGRectMake( 0, 0, __defaultSize.width, __defaultSize.height );
	
	if ( nil == __defaultClass )
	{
		return [[[BeeUIPullLoader alloc] initWithFrame:frame] autorelease];
	}
	else
	{
		return [[[__defaultClass alloc] initWithFrame:frame] autorelease];
	}
}

- (id)init
{
	self = [super init];
	if ( self )
	{
		[self initSelf];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if ( self )
	{
		[self initSelf];
		[self changeFrame:frame animated:NO];
    }
    return self;
}

- (void)initSelf
{
	self.backgroundColor = [UIColor clearColor];
//	self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	
	if ( NO == _inited )
	{
		_state = BeeUIPullLoader.STATE_NORMAL;
		_inited = YES;

//		[self load];
		[self performLoad];
	}
}

- (void)dealloc
{
//	[self unload];
	[self performUnload];

    [super dealloc];
}

- (void)setFrame:(CGRect)frame
{
	if ( NO == CGRectEqualToRect( self.frame, frame ) )
	{
		[super setFrame:frame];
		[self changeFrame:frame animated:NO];
	}
}

- (BOOL)pulling
{
	return (BeeUIPullLoader.STATE_PULLING == _state) ? YES : NO;
}

- (void)setPulling:(BOOL)flag
{
	if ( flag )
	{
		[self changeState:BeeUIPullLoader.STATE_PULLING animated:YES];
	}
	else
	{
		[self changeState:BeeUIPullLoader.STATE_NORMAL animated:YES];
	}
}

- (BOOL)loading
{
	return (BeeUIPullLoader.STATE_LOADING == _state) ? YES : NO;
}

- (void)setLoading:(BOOL)flag
{
	if ( flag )
	{
		[self changeState:BeeUIPullLoader.STATE_LOADING animated:YES];
	}
	else
	{
		[self changeState:BeeUIPullLoader.STATE_NORMAL animated:YES];
	}
}

- (void)changeFrame:(CGRect)frame animated:(BOOL)animated
{
	if ( NO == _inited )
		return;

	[self setAnimated:animated];
	[self sendUISignal:BeeUIPullLoader.FRAME_CHANGED];

	self.RELAYOUT();
}

- (void)changeState:(NSInteger)state animated:(BOOL)animated
{
	if ( NO == _inited || _state == state )
		return;

	_state = state;

	[self setAnimated:animated];
	[self sendUISignal:BeeUIPullLoader.STATE_CHANGED];
	
	self.RELAYOUT();
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
