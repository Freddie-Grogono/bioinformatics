#include <iostream>
#include <string>

int main()
{
    int a = 42;
    float b = 3.14159265;
    std::string c = "Spot the dog";
    bool d = true;

    std::cout << "Use the '<<' operator to push things to print to std::cout, e.g. " << a << std::endl;
    std::cout << "You can print anything you like, e.g. floats such as " << b << std::endl;
    std::cout << " or other strings, like " << c << " or booleans such as " << d << std::endl;
    std::cout << "and when you type, you can go over multiple lines, as 'std::endl' is used to print an 'end of line'." << std::endl;
                     
    return 0;
}

