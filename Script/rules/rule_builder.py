''' This is an abstract class that defines the methods on a translator.'''
class Translator:
    def translate():
        raise NotImplementedError

''' This class constructs a rule using a raw rule and a translator '''
class RuleBuilder:
    def __init__(self, translator):
        self.translator = translator

    def build_rule(self, raw_rule):
        return self.translator.translate(raw_rule)

