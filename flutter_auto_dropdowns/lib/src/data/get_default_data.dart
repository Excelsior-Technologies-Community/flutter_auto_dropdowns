import 'package:flutter_auto_dropdowns/src/data/countries.dart';
import 'package:flutter_auto_dropdowns/src/data/currencies.dart';
import 'package:flutter_auto_dropdowns/src/data/gst_rates.dart';
import 'package:flutter_auto_dropdowns/src/data/payment_modes.dart';
import 'package:flutter_auto_dropdowns/src/data/tax_slabs.dart';
import 'package:flutter_auto_dropdowns/src/data/units.dart';

enum Mode { country, gst, unit, currency, paymentMode, taxSlab,  }

List<Object> getDefaultData(Mode mode) {
  switch (mode) {
    case Mode.country:
      return countries;
    case Mode.gst:
      return gst;
    case Mode.unit:
      return units;
    case Mode.currency:
      return currencies;
    case Mode.paymentMode:
      return paymentModes;
    case Mode.taxSlab:
      return taxSlabs;
  }
}
