-- One-time: add Stripe shipping details to an orders table created before 2026-10-23. Not re-runnable (ADD COLUMN fails if the column exists).
ALTER TABLE orders ADD COLUMN email TEXT;
ALTER TABLE orders ADD COLUMN ship_name TEXT;
ALTER TABLE orders ADD COLUMN ship_line1 TEXT;
ALTER TABLE orders ADD COLUMN ship_line2 TEXT;
ALTER TABLE orders ADD COLUMN ship_city TEXT;
ALTER TABLE orders ADD COLUMN ship_state TEXT;
ALTER TABLE orders ADD COLUMN ship_zip TEXT;
ALTER TABLE orders ADD COLUMN ship_country TEXT;
ALTER TABLE orders ADD COLUMN phone TEXT;
