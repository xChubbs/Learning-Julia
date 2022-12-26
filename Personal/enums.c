/*
Practica y aprendizaje de los tipos de datos ENUM
Datos constantes.
*/

#include <stdio.h>

enum elements{
        air = 1,
        water = 3,
        earth = 5,
        fire = 7,

    } element;

int main(void){
    element = earth;
    
    printf("Element power %d", element);
    printf("\nThe size of the element is %d", sizeof(element));
    return 0;
}