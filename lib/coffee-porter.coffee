module.exports =
  activate: ->
    atom.commands.add 'atom-workspace', "coffee-porter:convert", => @convert()

  convert: ->
    atom.workspace.observeTextEditors (editor) ->
      js2coffee = require 'js2coffee'
      selection = editor.getSelectedText()
      try
        result = js2coffee.build(selection)
      catch e
        console.error("invalid javascript")

      editor.insertText(result.code)
