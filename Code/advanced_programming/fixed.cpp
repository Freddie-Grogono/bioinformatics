#include <iostream>

//Declared with two arguments of type 'int'
int sum(int a, int b);

//Declared with two arguments of type 'double'
double sum(double c, double d);

//Note that it is ok to declare the function twice, even
//using different argument names (as long as the type
//are correct) indeed, you don't have to specify the
//argument names.
double sum(double, double);

int main()
{
    std::cout << sum(10.5, 20.9) << std::endl;
}

//Definitions must use the same types as the declaration,
//and must provide argument names since they are referenced
//in the body of the function. Unlike the type, names don't to
//match those used in the declarations (although it's good
//practice to keep them consistent when names are used.)

//Defined with two arguments of type 'int'
int sum(int c, int d)
{
    std::cout << "Sum of two ints is: ";
    return c + d;
}

//Defined with two arguments of type 'double'
double sum(double a, double b)
{
    std::cout << "Sum of two doubles is: ";
    return a + b;
}

