from subprocess import run
import unittest
from os import listdir

class M30MLTestCase(unittest.TestCase):
    def test_m30ml_example_element(self):
        """ Validate example element against m30ml schema """
        examples_dir = "src/data/examples/"
        examples_list = listdir(examples_dir)
        examples_list.sort()
        for example in examples_list:
            try:
                run(["linkml-validate","-s","dist/m30ml.yaml","-C","Element","".join([examples_dir, example])])
            except ValueError as e:
                errors.append(str(e))


if __name__ == "__main__":
    unittest.main()
