'use strict';

// Generators for blocks defined in `custom_blocks.json`.
Blockly.JavaScript['expression'] = function(block) {
  var value = '\'' + block.getFieldValue('VALUE') + '\'';
  return 'ActionMaker.setExpression(' + value + ');\n';
};

Blockly.JavaScript['action'] = function(block) {
    var value = '\'' + block.getFieldValue('VALUE') + '\'';
    return 'ActionMaker.setAction(' + value + ');\n';
};

Blockly.JavaScript['text_input_block'] = function(block) {
    var text = '\'' + block.getFieldValue('Input') + '\'';
    var delay = '\'' + block.getFieldValue('number') + '\'';
    return 'ActionMaker.setText(' + text + ',' + delay + ');\n';
};

Blockly.JavaScript['title_input_block'] = function(block) {
    var title = '\'' + block.getFieldValue('Input') + '\'';
    var func = Blockly.JavaScript.statementToCode(block,"DO");
    return func + 'ActionMaker.setTitle(' + title + ');\n';
};

