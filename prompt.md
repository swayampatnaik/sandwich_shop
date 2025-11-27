You are implementing cart-editing features for a Flutter sandwich shop app. Repo context:
- Models: Sandwich (type, isFootlong, breadType), Cart (add/remove/clear/totalPrice).
- Repository: PricingRepository.totalPrice(quantity, isFootlong).
- Screens: OrderScreen (adds items), Cart screen (list of Cart.items + total).

Task: implement UI + logic to let users modify cart items. For each feature below, implement behavior, UI keys, data-flow, and tests.

1) Change item quantity (increment, decrement, direct edit)
- UI:
  - In cart list row show quantity controls: [-] [qty text or TextField] [+].
  - Keys per row: qty_decrement_{index}, qty_input_{index}, qty_increment_{index}.
  - Display per-line price to the right with key line_price_{index}.
- Behavior:
  - Tapping + calls Cart.updateQuantity(sandwich, current+1), recalc totals via PricingRepository, refresh UI.
  - Tapping - calls updateQuantity(current-1). If result > 0 update; if result == 0 show optional confirmation or remove item (see removal feature). Use undo Snackbar.
  - Editing qty via input validates integer >= 0; on submit call updateQuantity. Non-number resets to prior value.
  - After update, update cart_total_text key and confirmation_text.
- Edge cases:
  - Enforce maxQuantity if applicable.
  - Prevent negative quantities.
  - If two items become identical after edit (e.g., you change size or bread), merge into single CartItem (sum quantities).

2) Remove item entirely
- UI:
  - Add delete IconButton per row with key remove_item_{index}.
  - Add long-press context menu or swipe-to-delete (optional).
- Behavior:
  - Tapping remove removes that CartItem via Cart.remove(sandwich), recalc totals, update UI.
  - Show undo Snackbar ("Removed 2 x Veggie Delight — Undo") that restores the item if tapped.
  - If deletion must be confirmed, show a confirmation dialog; make confirm optional in settings.
- Accessibility:
  - Provide semanticLabel on delete button: "Remove {quantity} {sandwich.name}".

3) Edit item (change size, bread, or sandwich type)
- UI:
  - Add an Edit button/icon per row or tap row to open an Edit dialog/sheet showing current Sandwich options (size, bread, type) and quantity.
  - Keys: edit_item_{index}, edit_dialog_{index}, edit_save_{index}.
- Behavior:
  - On save, if edited attributes produce a different Sandwich identity:
    - If an identical Sandwich exists in cart, merge quantities; otherwise replace the item.
  - Recalculate per-line and total prices using PricingRepository.totalPrice.
  - Update confirmation_text with details: "Updated 1 x Tuna Melt to Footlong, Wheat — new line: £11.00"

4) Price display and recalculation
- Per-row: show line price using PricingRepository.totalPrice(item.quantity, isFootlong: item.sandwich.isFootlong).
- Total: show cart_total_text key updated after every modification.
- Use toStringAsFixed(2) and currency prefix "£".

5) Data flow & APIs
- Call Cart.updateQuantity(Sandwich, int qty) and Cart.remove(Sandwich) for logic.
- UI should call setState or use a state management notifier (ChangeNotifier, Provider) to update reactive UI.
- Keep PricingRepository as single source for price calculations; do NOT hardcode prices in UI.

6) Merge & identity rules
- Two CartItems are identical when Sandwich.type, isFootlong, and breadType match.
- When editing attributes, if a matching item exists, merge and remove edited duplicate.

7) Keys & test hooks (use exact keys)
- Cart list: cart_list
- Cart total: cart_total_text
- Confirmation area: confirmation_text
- Per-row:
  - item_tile_{index}
  - line_price_{index}
  - qty_decrement_{index}
  - qty_input_{index}
  - qty_increment_{index}
  - remove_item_{index}
  - edit_item_{index}

8) UX notes
- Use optimistic UI updates (update immediately, then reconcile if server persistence fails).
- Provide undo Snackbar for destructive actions.
- Keep actions reachable on small screens (use ListView shrinkWrap or ensure visible on taps via tester.ensureVisible).

9) Tests to add
- Unit tests for Cart:
  - updateQuantity increases/decreases quantity and removes when set to 0.
  - remove() removes the correct item; totalPrice recalculates.
  - merging behavior when adding/editing results in combined quantities.
- Widget tests:
  - Tapping qty_increment_{0} increases displayed quantity and updates line_price_0 and cart_total_text.
  - Tapping qty_decrement_{0} decreases, and when reaches 0 shows undo Snackbar or removes item.
  - Tapping remove_item_{0} removes row and updates cart_total_text; Undo restores it.
  - Editing an item to become identical to another merges rows and updates prices.

10) Example user flows (text to display in UI)
- "Added 2 x Veggie Delight (White • Footlong) — £22.00" (confirmation_text)
- Cart row title: "2 x Veggie Delight (White • Footlong)" subtitle: "£22.00" trailing: [Delete]
- Total: "Total: £34.00" (cart_total_text)

11) Implementation hints for the engineer/LLM
- Modify Cart model to expose updateQuantity(Sandwich, int) and optionally a changeItem(Sandwich old, Sandwich updated).
- Ensure Cart.totalPrice() uses PricingRepository for each line.
- Update OrderScreen/CartScreen to display the new UI and wire keys and callbacks.
- Use tester.ensureVisible(...) and pumpAndSettle() in widget tests to avoid off-screen tap errors.

Deliverable for me (the developer) — ask the LLM to produce:
- Code diffs for modified files: lib/models/cart.dart (if changed), lib/views/cart_screen.dart or lib/views/order_screen.dart, lib/repositories/pricing_repository.dart (if needed).
- New/updated widget and unit tests under test/ verifying the behaviors above.
- A short migration note describing breaking changes (if Cart API changed).

Use this prompt to produce the implementation, tests, and brief explanation of reasoning and edge-cases handled.