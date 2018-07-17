#include "LColorTable.h"

void IntToRGB(const NSInteger d,NSInteger &R,NSInteger &G,NSInteger &B)
{
	R = (d&0xff0000)>>16;
	G = (d&0xff00)>>8;
	B = d&0xff;
}

#pragma mark - 构造函数

LDecoderColorTable::LDecoderColorTable(NSArray ** strings)
{
	FSize = 0;
	FColors = NULL;
	FDescription = @"";
    FData = [[NSMutableArray alloc] initWithCapacity:3];
    
	for(int i=0;i<[*strings count];i++)
	{
        NSString * str = [*strings objectAtIndex:i];
		if([str hasPrefix:@";"])
        {
            NSString * subString = [str substringFromIndex:2];
            FDescription = [FDescription stringByAppendingString:subString];
        }
		else
		{
            NSRange range = [str rangeOfString:@","];
			if(range.location != NSNotFound)
			{
                LColorTable d;
                NSString * value = [str substringToIndex:range.location];
                const char *hexChar = [value cStringUsingEncoding:NSUTF8StringEncoding];
                int hexNumber;
                sscanf(hexChar, "%x", &hexNumber);
                d.Color = (NSInteger)hexNumber;
                d.Scale = [[str substringFromIndex:range.location + 1] doubleValue];
                NSValue *d_ns_value = [NSValue valueWithBytes:&d objCType:@encode(struct LColorTable)];
                [FData addObject:d_ns_value];
			} 
		}
	}
}


#pragma mark - 析构函数
LDecoderColorTable::~LDecoderColorTable(void)
{
	this->FColors = NULL;
}


# pragma mark - 成员函数

NSString * LDecoderColorTable::Description()
{
	return FDescription;
}

NSMutableArray<UIColor *> * LDecoderColorTable::Colors(int size)
{
	if(size == FSize && FColors != NULL)
		return FColors;
	if(FColors != NULL)
        this->FColors = NULL;
	float start,end;
	float offset;
	float R1,R2,G1,G2,B1,B2;
	float Roffset,Goffset,Boffset;
	
	NSInteger R,G,B;
    FColors = [[NSMutableArray alloc] initWithCapacity:size];
	
	if([FData count] == 0)
		return FColors;
    
    for (int i = 0; i < [FData count]-1; i++)
    {
        NSValue * d_ns_value_1 = [FData objectAtIndex:i];
        LColorTable color_table_temp_1;
        [d_ns_value_1 getValue:&color_table_temp_1];
        
        NSValue * d_ns_value_2 = [FData objectAtIndex:i+1];
        LColorTable color_table_temp_2;
        [d_ns_value_2 getValue:&color_table_temp_2];
    
		IntToRGB(color_table_temp_1.Color,R,G,B);
		R1=R;
		G1=G;
		B1=B;
		IntToRGB(color_table_temp_2.Color,R,G,B);
		R2=R;
		G2=G;
		B2=B;
		start = ceil((float)size * color_table_temp_1.Scale);
		end = ceil((float)size * color_table_temp_2.Scale);
		offset = end-start;
		Roffset = (R2-R1)/offset;
		Goffset = (G2-G1)/offset;
		Boffset = (B2-B1)/offset;
		for(int j=start;j<end;j++)
		{
			R = floor(R1+Roffset*(j-start)+0.5);
			G = floor(G1+Goffset*(j-start)+0.5);
			B = floor(B1+Boffset*(j-start)+0.5);
            
            UIColor * color = [UIColor colorWithRed:R / 255.0 green:G / 255.0 blue:B / 255.0 alpha:1];
            [FColors addObject:color];
		}
	}
	return FColors;
}
