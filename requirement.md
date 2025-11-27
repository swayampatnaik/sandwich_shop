Cart Editing — Requirements Document


1. Feature overview
Enable users to modify items in their cart from the Cart screen. Modifications include changing item quantity, editing item attributes (size, bread, sandwich type), and removing items. All price calculations must use the existing PricingRepository. The UI must show per-item line prices and the cart total, provide undo for destructive actions, and expose deterministic test hooks (Keys).


2. Purpose
Improve UX by letting users correct or adjust their selection without re-adding items.
Keep pricing accurate and centralized via PricingRepository.
Make interactions testable and accessible.


3. User stories
As a shopper, I can increase the quantity of a cart item so I can order more of the same sandwich.
As a shopper, I can decrease the quantity of a cart item so I can reduce my order without deleting the item.
As a shopper, I can edit an item's attributes (size, bread, type) so I can change my sandwich specification.
As a shopper, I can remove an item entirely from the cart.
As a shopper, I can undo a recent removal from the cart to recover accidentally deleted items.
As a shopper, I see per-item prices and a cart total that always reflect the current cart state.
As a tester/developer, I can target UI elements reliably using Keys.


4. Acceptance criteria (high-level)
A feature is complete when all bullets below pass manual QA and automated tests:

UI

Each cart row displays:
quantity controls: decrement button, quantity display or editable input, increment button
sandwich title (quantity × name + size + bread)
per-line price (formatted "£xx.xx")
an Edit action (opens editor) and a Delete action (removes item)
Cart-level display:
cart_total_text shows the sum of all line totals formatted "Total: £xx.xx"
confirmation_text displays recent add/edit/remove messages
All interactive widgets expose Keys for tests (see Key list below).
Undo for deletions is available as a Snackbar with an "Undo" action.
Behavior / business logic

All price calculations call PricingRepository.totalPrice(quantity, isFootlong).
Incrementing quantity increments the Cart item quantity (Cart.updateQuantity) and updates the UI and totals.
Decrementing quantity decrements the Cart item quantity; when quantity becomes 0 either:
prompt a confirmation OR
remove the item and show undo Snackbar (configurable), and update totals.
Editing an item:
opens a modal or bottom sheet allowing change of sandwich type, size, bread, and quantity.
on save, if the edited sandwich matches an existing Cart item identity (same type, size, bread), merge quantities and remove duplicate row; otherwise update the item in-place.
Removing an item:
immediately removes the item, updates totals, shows undo Snackbar that restores the removed CartItem when tapped.
Cart.totalPrice() must equal the sum of line totals computed by PricingRepository per item.
Edge cases & constraints

Quantities are integers >= 0.
Respect any maxQuantity constraint from OrderScreen where appropriate.
Invalid quantity input is rejected and the field resets to the previous valid value.
Actions remain functional and UI remains responsive under a large number of items.
Tests

Unit tests for Cart:
updateQuantity increments, decrements, removes when zero, and merges items.
totalPrice uses PricingRepository per-line totals and sums correctly.
Widget tests:
qty increment/decrement buttons update displayed quantity and line price and cart_total_text.
editing an item updates or merges and updates prices.
removing an item updates UI and cart_total_text; undo restores it.
finders use Keys to avoid ambiguity.


5. Detailed UI keys (required)
Use Keys exactly as listed for deterministic tests:

Cart container: cart_list
Cart total text: cart_total_text
Confirmation message: confirmation_text
Per-row (replace {index} with row index):
tile container: item_tile_{index}
decrement button: qty_decrement_{index}
quantity input/display: qty_input_{index}
increment button: qty_increment_{index}
per-line price: line_price_{index}
edit action: edit_item_{index}
remove action: remove_item_{index}
Undo snackbar action: undo_remove_action
Note: If index-based keys are brittle for reordering, allow using a deterministic ID: item_tile_{itemId}.


6. Data and identity rules
CartItem identity = Sandwich.type + Sandwich.isFootlong + Sandwich.breadType.
When an edit produces an item with the same identity as an existing row, merge by summing quantities and removing the edited duplicate.
Cart API expectations:
add(Sandwich, int qty)
remove(Sandwich) -> bool
updateQuantity(Sandwich, int qty) -> bool (returns whether an existing item changed/removed)
totalPrice() -> double (uses PricingRepository internally for each CartItem)
If the Cart API needs changes, update unit tests and add a short migration note.


7. UX details and text examples
Confirmation message examples (confirmation_text):
Add: "Added 2 x Veggie Delight (White • Footlong) — £22.00"
Edit: "Updated 1 x Tuna Melt to Six-inch, Wheat — new line: £7.00"
Remove: "Removed 2 x Chicken Teriyaki — Undo"
Cart row title example: "2 x Veggie Delight (White • Footlong)"
Line price example: "£22.00"
Total example: "Total: £34.00"


8. Error handling & validation
If PricingRepository throws or fails, show an inline error and keep UI usable.
If user inputs invalid quantity, show inline validation error and revert.
If an undo times out, removal becomes permanent; show a brief toast confirming deletion.


9. Accessibility & internationalization
Provide semantic labels for buttons (e.g., "Increase quantity of Veggie Delight").
Use localized currency formatting if the app later supports multiple locales (for now use "£" and toStringAsFixed(2)).
Ensure controls have sufficient size and contrast.


10. Non-functional requirements
All UI updates must be immediate (optimistic) and stable under typical mobile frame budgets.
Tests must run reliably on CI; prefer find.byKey and find.textContaining to avoid flakiness.


11. Subtasks (developer checklist)
Design & API

Confirm Cart API signatures and merge behavior.
Confirm whether decrement-to-zero removes automatically or shows confirm.
Model & repository

Ensure PricingRepository is available to Cart or CartScreen for per-line calculation.
UI (Cart screen)

Implement cart list rows with quantity controls, line price, edit and remove actions.
Add confirmation_text and cart_total_text with Keys.
Implement Edit modal/bottom sheet to change sandwich attributes.
Undo & Snackbar

Implement undo semantics for deletes with undo_remove_action key.
Logic

Wire quantity controls to Cart.updateQuantity and recalc prices.
Merge edited items when necessary.
Tests

Add/modify unit tests for Cart (quantity updates, merging, total price).
Add widget tests using Keys for increment, decrement, edit, remove, undo, and verify price updates.
Documentation

Update README and prompt.md with new Keys and behaviors.
Add migration note if Cart API changed.
QA

Manual QA across flows: add, edit to merge with existing, decrement to zero, remove+undo, price recalculation.
Run tests under CI.


12. Example acceptance test scenarios (concrete)
Scenario A — increment:

Given cart contains 1 x Footlong Veggie Delight,
When user taps qty_increment_0,
Then row shows "2 x Veggie Delight (...)", line_price_0 shows £22.00 and cart_total_text shows updated total.
Scenario B — edit -> merge:

Given cart contains 1 x Footlong Tuna and 1 x Six-inch Tuna,
When user edits Six-inch Tuna to Footlong and saves,
Then cart shows a single row "2 x Tuna (Footlong)" and total updates to 2 × footlong price.
Scenario C — remove + undo:

Given cart contains 2 x Chicken,
When user taps remove_item_0,
Then item is removed and cart_total_text updates; an undo Snackbar appears with undo_remove_action.
When user taps the undo action within timeframe,
Then the removed item is restored and totals restored.


13. Notes & constraints for implementer
Keep PricingRepository as the single source of price truth.
Prefer deterministic Keys rather than byType finders in tests.
Make destructive actions reversible via Snackbar to reduce accidental data loss.
Keep UI touch targets large and ensure elements are visible before attempting programmatic taps in tests (use tester.ensureVisible).