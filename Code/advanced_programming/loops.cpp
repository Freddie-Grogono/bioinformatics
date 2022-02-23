#include <iostream>

int main()
{
    std::cout << "Loop 1" << std::endl;
    for (int i=0; i<10; ++i)
    {
        std::cout << i << std::endl;
    }

    std::cout << "Loop 2" << std::endl;
    for (int i=500; i>0; i -= 100)
    {
        std::cout << i << std::endl;
    }

    std::cout << "Loop 3" << std::endl;
    for (int puppy=30; puppy<=100; puppy += 5)
    {
        std::cout << puppy << std::endl;
    }

    std::cout << "Loop 4" << std::endl;
    for (int i=1; i<=3; ++i)
    {
        for (int j=1; j<=3; ++j)
        {
            std::cout << (i*j) << " ";
        }

        std::cout << std::endl;
    }

    return 0;
}