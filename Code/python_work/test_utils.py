from utils import add_arrays


def test_add_arrays():
    a = [1, 2, 3]
    b = [4, 5, 6]
    expect = [5, 7, 9]

    output = add_arrays(a, b)

    assert output == expect