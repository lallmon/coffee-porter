module.exports =
  activate: ->
    atom.commands.add 'atom-workspace', "coffee-porter:convert", => @convert()

  convert: ->
    atom.workspace.observeTextEditors (editor) ->
      js2coffee = require 'js2coffee'
      selection = editor.getSelectedText()
      try
        result = js2coffee.build(selection)
        editor.insertText(result.code)
      catch e
        console.error "Cannot complete conversion because" + e.description
