module.exports =
class CoffeePorterView
  constructor: (serializedState) ->
    @element = document.createElement('div')
    @element.classList.add('coffee-porter')

    message = document.createElement('div')
    message.textContent = "DEFAULT MESSAGE"
    message.classList.add('message')
    @element.appendChild(message)

  serialize: ->

  destroy: ->
    @element.remove()

  getElement: ->
    @element

  displayMessage: (message) ->
    text = "#{message}"
    @element.children[0].textContent = text
