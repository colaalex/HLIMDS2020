#include "dpi_types.h"
#include "stdio.h"

int c_CarWaiting()
{
    printf("There's a car waiting on the other side. \n");
	printf("Initiate change sequence ...\n");
	sv_YellowLight(); //жёлтый свет
	sv_WaitForRed();  //ожидание 10 ед. времени
	sv_RedLight();    //красный свет
	return 0;
}
