import 'package:flutter_auto_dropdowns/src/data/payment_modes.dart';
import 'package:flutter_auto_dropdowns/src/data/tax_slabs.dart';
import 'package:flutter_auto_dropdowns/src/data/units.dart';

import 'countries.dart';
import 'currencies.dart';
import 'gst_rates.dart';

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
