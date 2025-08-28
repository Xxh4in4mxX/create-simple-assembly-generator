#include <stdio.h>

int main()
{
    if (__STDC__)
    {
        printf("The C version is at least C89\n");
#ifdef __STDC_VERSION__
        printf("C standard version: %lu\n", __STDC_VERSION__);
#else
        printf("C89 or earlier (no __STDC_VERSION__ defined)\n");
#endif
    }
    else
    {
        printf("Not a standard-compliant C compiler (K&R C or similar)\n");
    }
    return 0;
}
