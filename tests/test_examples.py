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
                for element_type in ["Element", "Package", "Reference"]:
                    if element_type in example:
                        element_type_to_be_validated = element_type
                        break
                print("validating", example, "against", element_type_to_be_validated)
                run(["linkml-validate","-s","dist/m30ml.yaml","-C",element_type_to_be_validated,"".join([examples_dir, example])])
            except ValueError as e:
                errors.append(str(e))


if __name__ == "__main__":
    unittest.main()
