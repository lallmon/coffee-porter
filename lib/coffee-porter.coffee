CoffeeporterView      = require './coffee-porter-view'
{CompositeDisposable} = require 'atom'

js2coffee   = require 'js2coffee'
path        = require 'path'
fs          = require 'fs'

module.exports = CoffeePorter =
  wordcountView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @coffeeporterView = new CoffeeporterView(state.coffeeporterViewState)
    @bottomPanel = atom.workspace.addBottomPanel (
      item: @coffeeporterView.getElement(),
      visible: false
    )
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace',
      "coffee-porter:convertTextCoffeescript", =>
        @convertTextCoffee()
    @subscriptions.add atom.commands.add 'atom-workspace',
      "coffee-porter:convertFileCoffeescript", =>
        @convertFileCoffee()
    @subscriptions.add atom.commands.add 'atom-workspace',
      "coffee-porter:pasteAsCoffeescript", =>
        @pasteAsCoffeescript()

  deactivate: ->
    @bottomPanel.destroy()
    @subscriptions.dispose()
    @wordcountView.destroy()

  serialize: ->
    coffeeporterViewState: @coffeeporterView.serialize()

  convertTextCoffee: ->
    currentEditor = atom.workspace.getActiveTextEditor()
    selection = currentEditor.getSelectedText()
    try
      result = js2coffee.build(selection)
      currentEditor.insertText(result.code)
      @coffeeporterView.displayMessage 'Successfully converted to coffeescript!'
      @bottomPanel.show()
      setTimeout (->
        @bottomPanel.destroy()
      ), 1000
    catch e
      @coffeeporterView.displayMessage('Cannot complete conversion: ' + e.description)
      @bottomPanel.show()

  convertFileCoffee: ->
    try
      treeView = atom.packages.getLoadedPackage('tree-view')
      treeView = require(treeView.mainModulePath)
      packageObject = treeView.serialize()
      sourceFile = packageObject.selectedPath
      convertData = fs.readFileSync sourceFile
      try
        result = js2coffee.build convertData
      catch e
        alert e.message

      newPath = sourceFile.replace '.js', '.coffee'
      fs.writeFileSync newPath, result.code
      fs.unlink sourceFile
      treeView.showSelectedEntryInFileManager(sourceFile)


      if result.warnings and result.warnings.length > 0
        result.warnings.forEach (warning) ->
          console.log warning

    catch error
      console.log "Cannnot convert file because" + error.description
      console.log "Stack Trace:" + error.stack

  pasteAsCoffeescript: ->
    currentEditor = atom.workspace.getActiveTextEditor()
    clipboardText = atom.clipboard.read()
    try
      esprima.esvalidate(clipboardText)
    catch

    try
      result = js2coffee.build(clipboardText)
      currentEditor.insertText(result.code)
    catch e
      alert "Cannot complete conversion because " + e.description
