function  [descaled_x] = descale(x, maximum, minimum)

descaled_x = x * (maximum - minimum) + minimum;
