def add_arrays(x, y):
    """
    This function adds together each element of the two passed lists.

    Args:
        x (list): The first list to add
        y (list): The second list to add

    Returns:
        list: the pairwise sums of ``x`` and ``y``.

    Examples:
        >>> add_arrays([1, 4, 5], [4, 3, 5])
        [5, 7, 10]
    """
    z = []
    for x_, y_ in zip(x, y):
        z.append(x_ + y_)

    return z