#include <stdio.h>
#include <stdlib.h>
int i = 1, j = 10;
void reset() {
    i = 0;
    j = 100;
}

int main() {
    float f = atof("1.0e-5");
    printf("%f\n", f);
    return 0;
}
