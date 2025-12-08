import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_auto_dropdowns/src/data/get_default_data.dart';

class AppDropdown<T> extends StatefulWidget {
  final String label;
  final List<T>? items;
  final Mode? mode;
  final T? value;
  final List<T>? selectedItems;
  final bool isMultiSelect;
  final String Function(T) display;
  final void Function(T?)? onChanged;
  final void Function(List<T>)? onMultiChanged;
  final bool searchable;

  // 🔥 FULL TEXTFIELD CONTROLS
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final bool enabled;
  final bool readOnlyText; // user control: typing allowed or not
  final TextAlign? textAlign;
  final TextStyle? style;
  final String? hintText;
  final String? errorText;
  final String? helperText;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onFieldChanged;
  final void Function(String)? onSubmitted;

  // UI Customizations
  final Color? buttonColor;
  final Color? dropdownColor;
  final Color? borderColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final IconData? prefixIcon;
  final Widget? suffix;
  final bool chipsClosable;

  const AppDropdown({
    super.key,
    required this.label,
    required this.display,
    this.items,
    this.mode,
    this.value,
    this.selectedItems,
    this.isMultiSelect = false,
    this.onChanged,
    this.onMultiChanged,
    this.searchable = true,

    // FULL TEXTFIELD FEATURES
    this.controller,
    this.keyboardType,
    this.maxLength,
    this.maxLines = 1,
    this.minLines,
    this.enabled = true,
    this.readOnlyText = false,
    this.textAlign,
    this.style,
    this.hintText,
    this.errorText,
    this.helperText,
    this.inputFormatters,
    this.onFieldChanged,
    this.onSubmitted,

    this.buttonColor,
    this.dropdownColor,
    this.borderColor,
    this.borderRadius,
    this.padding,
    this.prefixIcon,
    this.suffix,
    this.chipsClosable = true,
  });

  @override
  State<AppDropdown<T>> createState() => _AppDropdownState<T>();
}

class _AppDropdownState<T> extends State<AppDropdown<T>> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  final GlobalKey _fieldKey = GlobalKey();
  final FocusNode _focusNode = FocusNode();

  late TextEditingController _controller;
  TextEditingController _searchController = TextEditingController();

  late List<T> _filteredItems;
  late List<T> _selectedItems;

  @override
  void initState() {
    super.initState();

    _controller = widget.controller ?? TextEditingController();
    _selectedItems = List<T>.from(widget.selectedItems ?? []);

    _filteredItems = widget.items ??
        (widget.mode != null
            ? List<T>.from(getDefaultData(widget.mode!) as List<T>)
            : []);

    _updateTextField();

    // search as user types
    _searchController.addListener(() {
      setState(() {
        final query = _searchController.text.toLowerCase();
        _filteredItems = (widget.items ??
            (widget.mode != null
                ? List<T>.from(getDefaultData(widget.mode!) as List<T>)
                : []))
            .where((e) => widget.display(e).toLowerCase().contains(query))
            .toList();
      });
      _overlayEntry?.markNeedsBuild();
    });

    // live text typing sync
    _controller.addListener(() {
      widget.onFieldChanged?.call(_controller.text);
    });

    _focusNode.addListener(() {
      if (!widget.readOnlyText && _focusNode.hasFocus) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_overlayEntry == null) {
            _showOverlay();
          }
        });
      }
    });
  }

  @override
  void didUpdateWidget(covariant AppDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _updateTextField();
    }
    if (widget.selectedItems != oldWidget.selectedItems) {
      _selectedItems = List<T>.from(widget.selectedItems ?? []);
      _updateTextField();
    }
  }

  void _updateTextField() {
    if (widget.isMultiSelect && _selectedItems.isNotEmpty) {
      _controller.text = _selectedItems.map((e) => widget.display(e)).join(", ");
    } else if (widget.value != null) {
      _controller.text = widget.display(widget.value!);
    } else {
      _controller.text = '';
    }
  }

  void _toggleItem(T item) {
    if (widget.isMultiSelect) {
      setState(() {
        if (_selectedItems.contains(item)) {
          _selectedItems.remove(item);
        } else {
          _selectedItems.add(item);
        }
      });

      widget.onMultiChanged?.call(_selectedItems);
      _updateTextField();
    } else {
      widget.onChanged?.call(item);
      _controller.text = widget.display(item);
      _searchController.text = '';
      _removeOverlay();
      _focusNode.unfocus();
    }
    _overlayEntry?.markNeedsBuild();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {});
  }

  void _showOverlay() {
    if (_overlayEntry != null) return;

    final renderBox = _fieldKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _removeOverlay,
        child: Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              Positioned(
                width: size.width,
                child: CompositedTransformFollower(
                  link: _layerLink,
                  offset: Offset(0, size.height + 5),
                  child: Container(
                    decoration: BoxDecoration(
                      color: widget.dropdownColor ?? Colors.white,
                      borderRadius:
                      BorderRadius.circular(widget.borderRadius ?? 8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: 300),
                      child: Column(
                        children: [
                          if (widget.searchable)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: _searchController,
                                autofocus: true,
                                decoration: InputDecoration(
                                  hintText: 'Search...',
                                  prefixIcon: Icon(Icons.search),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),

                          // ⭐⭐⭐ HIGHLIGHT + CLOSE ICON VERSION ⭐⭐⭐
                          Expanded(
                            child: _filteredItems.isEmpty
                                ? Center(child: Text('No items found'))
                                : ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: _filteredItems.length,
                              itemBuilder: (context, index) {
                                final item = _filteredItems[index];
                                final selected = widget.isMultiSelect
                                    ? _selectedItems.contains(item)
                                    : widget.value == item;

                                return Container(
                                  decoration: BoxDecoration(
                                    color: selected
                                        ? Colors.blue.withOpacity(0.15)
                                        : Colors.white,
                                    border: selected
                                        ? Border(
                                      left: BorderSide(
                                        color: Colors.blue,
                                        width: 4,
                                      ),
                                    )
                                        : null,
                                  ),
                                  child: ListTile(
                                    leading: widget.isMultiSelect
                                        ? Checkbox(
                                      value: selected,
                                      onChanged: (_) =>
                                          _toggleItem(item),
                                    )
                                        : null,

                                    title: Text(
                                      widget.display(item),
                                      style: TextStyle(
                                        fontWeight: selected
                                            ? FontWeight.w600
                                            : FontWeight.normal,
                                        color: selected
                                            ? Colors.blue
                                            : Colors.black,
                                      ),
                                    ),

                                    // ⭐ CLOSE ICON FOR SELECTED ITEMS ⭐
                                    trailing: selected
                                        ? InkWell(
                                      onTap: () {
                                        if (widget.isMultiSelect) {
                                          setState(() {
                                            _selectedItems.remove(item);
                                          });
                                          widget.onMultiChanged
                                              ?.call(_selectedItems);
                                        } else {
                                          widget.onChanged?.call(null);
                                          _controller.text = "";
                                        }
                                        _updateTextField();
                                        _overlayEntry?.markNeedsBuild();
                                      },
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.red,
                                        size: 20,
                                      ),
                                    )
                                        : null,

                                    onTap: () => _toggleItem(item),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    setState(() {});
  }

  @override
  void dispose() {
    _focusNode.dispose();
    if (widget.controller == null) {
      _controller.dispose();
    }
    _searchController.dispose();
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Container(
        key: _fieldKey,
        child: Stack(
          children: [
            TextField(
              controller: _controller,
              focusNode: _focusNode,
              readOnly: widget.readOnlyText,
              enabled: widget.enabled,

              // FULL TEXTFIELD FEATURES
              keyboardType: widget.keyboardType,
              maxLength: widget.maxLength,
              maxLines: widget.maxLines,
              minLines: widget.minLines,
              textAlign: widget.textAlign ?? TextAlign.left,
              inputFormatters: widget.inputFormatters,
              style: widget.style,
              decoration: InputDecoration(
                labelText: widget.label,
                hintText: widget.hintText,
                errorText: widget.errorText,
                helperText: widget.helperText,
                prefixIcon:
                widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
                filled: true,
                fillColor: widget.buttonColor ?? Colors.grey[100],

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
                  borderSide:
                  BorderSide(color: widget.borderColor ?? Colors.grey),
                ),

                contentPadding: widget.padding ??
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

                // give space for dropdown button
                suffixIcon: SizedBox(width: 40),
              ),

              onSubmitted: widget.onSubmitted,
              onTap: widget.readOnlyText
                  ? null
                  : () {
                if (_overlayEntry == null) {
                  _showOverlay();
                }
              },
            ),

            // DROPDOWN ICON (right side)
            Positioned(
              right: 4,
              top: 0,
              bottom: 0,
              child: IconButton(
                icon: Icon(
                  _overlayEntry == null
                      ? Icons.keyboard_arrow_down
                      : Icons.keyboard_arrow_up,
                ),
                onPressed: () {
                  if (_overlayEntry == null) {
                    _showOverlay();
                  } else {
                    _removeOverlay();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}