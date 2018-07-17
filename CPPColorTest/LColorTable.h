#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

class LDecoderColorTable{
    
public:
	LDecoderColorTable(NSArray ** strings);
	~LDecoderColorTable(void);
	NSString * Description();
	NSMutableArray<UIColor *> * Colors(int size);
private:
	struct LColorTable
	{
		NSInteger Color;
		CGFloat Scale;
	};
	NSString * FDescription;
	NSMutableArray<UIColor *> * FColors;
	int FSize;
	NSMutableArray * FData;
};

