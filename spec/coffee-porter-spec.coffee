CoffeePorter = require '../lib/coffee-porter'

describe "CoffeePorter", ->
  [workspaceElement, activationPromise] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)
    activationPromise = atom.packages.activatePackage('coffee-porter')

  describe "when the coffee-porter:convert event is triggered", ->
    it "successfully runs js2coffee", ->

      atom.commands.dispatch workspaceElement, 'coffee-porter:convert'

      waitsForPromise ->
        activationPromise

      runs ->
