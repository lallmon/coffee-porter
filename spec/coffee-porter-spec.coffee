CoffeePorter = require '../lib/coffee-porter'
js2coffee = require 'js2coffee'
path      = require 'path'
fs        = require 'fs'

describe "CoffeePorter", ->
  [activationPromise] = []

  beforeEach ->
    activationPromise = atom.packages.activatePackage('coffee-porter')

  describe "when converting selected text", ->
    it "successfully converts selected javasript to coffeescript", ->
      waitsForPromise ->
        activationPromise

      runs ->
        atom.commands.dispatch workspaceElement,
        'coffee-porter:convertTextCoffeescript'
        expect(variable).toBe true

  describe "when the convert file command is selected", ->
    it "successfully converts file to javascript and deletes the previous", ->
      waitsForPromise ->
        activationPromise

      runs ->
        atom.commands.dispatch workspaceElement,
        'coffee-porter:convertFileCoffeescript'
        expect(variable).toBe true

  describe "when paste as javascript command is selected", ->
    it "successfully pastes the javascript in the clipboard as coffeescript", ->
      waitsForPromise ->
        activationPromise

      runs ->
        atom.commands.dispatch workspaceElement,
        'coffee-porter:pasteAsCoffeescript'
        expect(variable).toBe true
