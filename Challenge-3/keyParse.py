from functools import reduce
def deep_get(dictionary, keys, default=None):
    return reduce(lambda d, key: d.get(key, default) if isinstance(d, dict) else default, keys.split("/"), dictionary)

object1 = {'a':{'b':{'c':'d'}}}
object2 = {'x':{'y':{'z':'a'}}}


if __name__ == '__main__':
    key = input("What key would you like to find?\n")
    print(deep_get(object2,key))