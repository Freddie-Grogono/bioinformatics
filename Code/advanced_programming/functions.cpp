#include <iostream>

int sum( int a, int b )
{
    int c = a + b;
    return c;
}

void print( std::string s )
{
    std::cout << s << std::endl;
}

double square( double x )
{
    return x * x;
}

std::string join( std::string a, std::string b )
{
    return a + " " + b;
}

void print_hello()
{
    std::cout << "Hello World" << std::endl;
}

int main()
{
    std::cout << "5 + 3 equals " << sum(5,3) << std::endl;

    print("Hello from a function!");

    std::cout << "The square of 3.5 is " << square(3.5) << std::endl;

    std::cout << join("Hello", "World") << std::endl;

    print_hello();

    //you can pass the return value from one function as the argument
    //of another, e.g.
    print( join("Hello", join("from", "C++")) );

    return 0;
}