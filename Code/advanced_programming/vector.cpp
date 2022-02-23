#include <iostream>
#include <vector>
// vectors in C++ have to have one type of data, define using the angle brackets 

void print_vec(std::vector <int> v)
{
    std::cout << "std::vector{ ";

    for (int i = 0; i < v.size(); i++)
    { 
        std::cout << v[i] << " ";
    }

    std::cout << "}" << std::endl;
}

int main()
{
    std::vector<int> v; // this vector is a vector of integers 

    v.push_back(4); //append something to the end of this list and (4) means add a 4 to it 
    v.push_back(46);
    v.push_back(454);

    print_vec(v);
    
    return 0;
}