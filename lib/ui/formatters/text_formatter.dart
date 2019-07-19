import 'package:flutter_web/material.dart';


class DateFormatter extends TextInputFormatter {
    @override
    TextEditingValue formatEditUpdate(
        TextEditingValue oldValue,
        TextEditingValue newValue
        ) {
      final int newTextLength = newValue.text.length;
      int selectionIndex = newValue.selection.end;
      int usedSubstringIndex = 0;
      final StringBuffer newText = StringBuffer();
      if (newTextLength >= 3) {
        newText.write(newValue.text.substring(0, usedSubstringIndex = 2) + '.');
        if (newValue.selection.end >= 2)
          selectionIndex++;
      }
      if (newTextLength >= 5) {
        newText.write(newValue.text.substring(2, usedSubstringIndex = 4) + '.');
        if (newValue.selection.end >= 4)
          selectionIndex++;
      }

      // Dump the rest.
      if (newTextLength >= usedSubstringIndex)
        newText.write(newValue.text.substring(usedSubstringIndex));
      return TextEditingValue(
        text: newText.toString(),
        selection: TextSelection.collapsed(offset: selectionIndex),
      );
    }
}
    

class MaskedTextInputFormatter extends TextInputFormatter {
  final String mask;
  final String separator;
  final String whiteList;

  MaskedTextInputFormatter({
    @required this.mask,
    @required this.separator,
    this.whiteList = '1234567890'
  }) { assert(mask != null); assert (separator != null); }

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length > 0) {
      final char = newValue.text[newValue.text.length - 1];
      if (!whiteList.contains(char) && !(char == separator && char == mask[newValue.text.length - 1])) {
        return oldValue;
      }
    }
    if (newValue.text.length > 0) {
      if (newValue.text.length > oldValue.text.length) {
        if (newValue.text.length > mask.length) 
          return oldValue;
        if (newValue.text.length < mask.length && mask[newValue.text.length - 1] == separator) {
          return TextEditingValue(
            text: '${oldValue.text}${newValue.text.substring(newValue.text.length-1) == separator ? '' : separator}${newValue.text.substring(newValue.text.length-1)}',
            selection: TextSelection.collapsed(
              offset: newValue.selection.end + 1,
            ),
          );
        }
      }
    }
    return newValue;
  }
}