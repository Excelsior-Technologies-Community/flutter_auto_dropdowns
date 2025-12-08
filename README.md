# Flutter Auto Dropdowns

A highly customizable **Flutter dropdown widget** with support for **single-select**, **multi-select**, **searchable items**, and **removable selections**. Perfect for forms, filters, or anywhere you need a modern dropdown with advanced features.

---

## Features

- ✅ Single-select and multi-select support  
- ✅ Highlight selected items with **bold text** and **blue background**  
- ✅ Close (X) icon to remove selected items instantly  
- ✅ Searchable dropdown items  
- ✅ Fully customizable UI:
  - Colors (button, dropdown, border)
  - Border radius and padding
  - Prefix and suffix icons
- ✅ Works with `TextField` features:
  - Read-only or editable
  - Max length, max/min lines
  - Keyboard type, text style, input formatters
    
## Installation
Add this to your `pubspec.yaml`:
```
dependencies:
  flutter_auto_dropdowns:
    git:
      url: https://github.com/YourGitHub/flutter_auto_dropdowns.git
      ref: main
```
Then run:
```
flutter pub get
```
##  Properties

| Property           | Type                                | Description |
|-------------------|--------------------------------------|-------------|
| `label`           | `String`                             | Dropdown label text |
| `items`           | `List<T>`                            | Dropdown items list |
| `value`           | `T?`                                 | Selected value for single-select |
| `selectedItems`   | `List<T>?`                           | Initially selected values for multi-select |
| `isMultiSelect`   | `bool`                               | Enable multi-select mode |
| `display`         | `String Function(T)`                 | Convert item to displayable string |
| `searchable`      | `bool`                               | Enable search bar inside dropdown |
| `onChanged`       | `void Function(T?)?`                 | Callback for single-select |
| `onMultiChanged`  | `void Function(List<T>)?`            | Callback for multi-select |
| `controller`      | `TextEditingController?`             | Controller for TextField |
| `buttonColor`     | `Color?`                             | TextField background color |
| `dropdownColor`   | `Color?`                             | Dropdown background color |
| `borderColor`     | `Color?`                             | Border color |
| `borderRadius`    | `double?`                            | Field border radius |
| `prefixIcon`      | `IconData?`                          | Leading icon inside TextField |
| `suffix`          | `Widget?`                            | Trailing widget |
| `chipsClosable`   | `bool`                               | Show close (X) icon on selected chip |
| `textStyle`       | `TextStyle?`                         | Text style for TextField |
| `inputFormatters` | `List<TextInputFormatter>?`          | Format user input |
| `keyboardType`    | `TextInputType?`                     | Keyboard type |
| `readOnly`        | `bool`                               | Make TextField read-only |
| `maxLines`        | `int?`                               | Max lines for TextField |
| `minLines`        | `int?`                               | Min lines for TextField |
| `maxLength`       | `int?`                               | Max length of text |

## Import this package
```
import 'package:flutter_auto_dropdowns/flutter_auto_dropdowns.dart';
```
## Usages
```
AppDropdown<String>(
  label: "Select Fruits",
  items: ["Apple", "Banana", "Mango", "Orange", "Grapes"],
  display: (e) => e,
  isMultiSelect: true,
  searchable: true,
  buttonColor: Colors.grey[100],
  dropdownColor: Colors.white,
  borderColor: Colors.blue,
  borderRadius: 12,
  onMultiChanged: (selectedItems) {
  print("Selected Items: $selectedItems");
  },
),
