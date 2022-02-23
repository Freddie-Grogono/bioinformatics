#include <iostream>

int main() // main is a special function 
{
    int n = 42;

    if (n < 0)
    {
        std::cout << n << " is negative." << std::endl;
    }
    else if (n > 100)
    {
        std::cout << n << " is large and positive." << std::endl;
    }
    else if (n == 10)
    {
        for (int i=10; i>0; i-=1)
        {
            std::cout << i << "..." << std::endl;
        }
        std::cout << "Blast off!" << std::endl;
    }
    else if (n == 42)
    {
        std::cout << "The answer to life, the universe and everything!" << std::endl;
    }
    else
    {
        std::cout << "What is " << n << "?" << std::endl;
    }

    return 0;
}
