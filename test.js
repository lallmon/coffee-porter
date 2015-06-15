/*
* Welcome to the new js2coffee 2.0, now
* rewritten to use the esprima parser.
* try it out!
*/
function listen (el, event, handler) {
 if (el.addEventListener) {
   return el.addEventListener(event, handler);
 } else {
   return el.attachEvent("on" + event, function() {
     return handler.call(el);
   });
 }
}
