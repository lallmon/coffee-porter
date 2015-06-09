js2coffee = require 'js2coffee'
path      = require 'path'
fs        = require 'fs'

module.exports = CoffeePorter =
  activate: ->
    atom.commands.add 'atom-workspace',
      "coffee-porter:convertTextCoffeescript", =>
        @convertTextCoffee()
    atom.commands.add 'atom-workspace',
      "coffee-porter:convertFileCoffeescript", =>
        @convertFileCoffee()
    atom.commands.add 'atom-workspace',
      "coffee-porter:pasteAsCoffeescript", =>
        @pasteAsCoffeescript()

  convertTextCoffee: ->
    currentEditor = atom.workspace.getActiveTextEditor()
    selection = currentEditor.getSelectedText()
    try
      result = js2coffee.build(selection)
      currentEditor.insertText(result.code)
    catch e
      alert "Cannot complete conversion because " + e.description

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
      result = js2coffee.build(clipboardText)
      currentEditor.insertText(result.code)
    catch e
      alert "Cannot complete conversion because " + e.description
