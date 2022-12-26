// Practica y aprendizaje de la declaración de variables

#include <stdio.h>
#include <math.h>

// Variable declarations
extern char referenceVariable;
char maxima;
int num1, num2, num3;
float dec1, dec2;
double dec3;


int main(){
    // Variable Initialization
    num1 = 200; num2 = 30; num3 = 1;
    maxima = 127;

    // Definition of operations
    int sum = num2 + num3;
    char maxExample = maxima + num3;
    int difference = num1 - num2;

    dec1 = maxima / num2;
    dec2 = sqrt(num2);
    dec3 = sqrt(num2);

    // Printing of results
    printf("Se realizaron las siguientes operaciones:\n");

    printf("Sumas\n >> %d + %d = %d\n >> %d + %d = %d\n", num2, num3, sum, maxima, num3, maxExample);
    printf("Diferencias\n >> %d - %d = %d\n", num1, num2, difference);

    printf("Razones\n >> %d / %d = %f\n", maxima, num2, dec1);
    printf("Raices cuadradas\n >> %.15f\n >> %.15lf\n", dec2, dec3);
    
    printf("De esta última operación comparemos espacio:\n >> float %d bytes\n >> double %d bytes", sizeof(dec2), sizeof(dec3));
    return 0;
}