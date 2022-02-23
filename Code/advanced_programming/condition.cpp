#include <iostream>

int main()
{ 
    int i = 101;

    if (i < 10)
    {
        std::cout << "i is less than 10" << std::endl;
    }
    else if (i >= 100)
    {
        std::cout << "i is more than or equal to 100" << std::endl;
    }
    else
    {
        std::cout << "i is somewhere between 10 and 100" << std::endl;
    }

    return 0;
}