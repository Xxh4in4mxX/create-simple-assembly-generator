x = 10.50;
switch (x)
{
case 1:
    x = x + 1;
    
case 2:
    x = x + 2;
    break;
default:
    break;
}

while (x != 0) {
    x = x + 1;
}

for (i = 0; i < 10; i = i + 1) {
    x = x + 2;
    if (x > 3) {
        break;
    }
}
