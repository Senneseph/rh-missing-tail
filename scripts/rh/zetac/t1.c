#define _GNU_SOURCE
#include <stdio.h>
typedef __float128 f128;
extern f128 cosq(f128);
extern f128 sinq(f128);
extern f128 ldexpq(f128, int);
extern f128 fmaq(f128, f128, f128);
extern f128 floorq(f128);
int main(void)
{
    f128 x = (f128)0.178613;
    printf("x            = %.17g\n", (double)x);
    printf("cosq(x)      = %.17g\n", (double)cosq(x));
    printf("sinq(x)      = %.17g\n", (double)sinq(x));
    f128 big = ldexpq((f128)14488038916154245684ULL, -61);
    f128 bot = ldexpq((f128)432712671756728ULL, -110);
    printf("twopy        = %.17g\n", (double)(big + bot));
    printf("fmaq(3,7,-20)= %.17g\n", (double)fmaq((f128)3, (f128)7, (f128)-20));
    printf("floorq(2.7)  = %.17g\n", (double)floorq((f128)2.7));
    return 0;
}
