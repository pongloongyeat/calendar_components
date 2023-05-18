<!--
## Version
### Features
### Fixes
### Documenetation
### Workflow
### Tests
### Others
-->

## 0.2.0

### Features
- Rework API to remove use of `.overflow` and `.noOverflow` constructors.

## 0.1.0

### Features
- `CalendarComponentDayGrid` (and all other grid-based components) now passes its index in its `itemBuilder` to allow for more powerful customisation/handling of UI.
- `CalendarComponentDayGrid` (and all other grid-based components) now has exactly two constructors: a `.overflow` and `noOverflow` to handle overflowing weeks more easily.
- The `.single` and `.multiple` constructors have been removed from `CalendarComponentSelectableDayGrid` in favour of `.overflow` and `.noOverflow`. Because of this, single and multiple selection is now separated into two widgets: `CalendarComponentSingleSelectableDayGrid` and `CalendarComponentMultipleSelectableDayGrid`.
- `RangedSelectionState` has been renamed to `SelectedDateRangeState` and `selectedEnd` has been removed.
- Certain useful `DateTime` extensions have been exported out to the library.

### Documentation
- Added documentation for relevant classes.

### Workflow
- Added CI.

### Tests
- Updated tests to match current API.

### Others
- Update example to use the ranged day grid.

## 0.0.1

* Initial pre-release
