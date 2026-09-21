-- One example offer, the shape send-from-postgres expects. Replace the rows
-- with your own; keep offer_id to letters, digits, _ ( ) - (Run settings
-- checks this before interpolating it into SQL).

INSERT INTO offers (offer_id, offer) VALUES
('offer_001', $$<table style="border-collapse: collapse; font-family: Arial, sans-serif; font-size: 14px;">
  <tr style="background: #f3f3f3;">
    <th style="border: 1px solid #ccc; padding: 6px 10px; text-align: left;">Product</th>
    <th style="border: 1px solid #ccc; padding: 6px 10px; text-align: left;">Origin</th>
    <th style="border: 1px solid #ccc; padding: 6px 10px; text-align: left;">Packing</th>
    <th style="border: 1px solid #ccc; padding: 6px 10px; text-align: left;">Price</th>
  </tr>
  <tr><td style="border: 1px solid #ccc; padding: 6px 10px;">Product 1</td><td style="border: 1px solid #ccc; padding: 6px 10px;">Origin A</td><td style="border: 1px solid #ccc; padding: 6px 10px;">20 kg cartons</td><td style="border: 1px solid #ccc; padding: 6px 10px;">on request</td></tr>
  <tr><td style="border: 1px solid #ccc; padding: 6px 10px;">Product 2</td><td style="border: 1px solid #ccc; padding: 6px 10px;">Origin A</td><td style="border: 1px solid #ccc; padding: 6px 10px;">10 kg cartons</td><td style="border: 1px solid #ccc; padding: 6px 10px;">on request</td></tr>
  <tr><td style="border: 1px solid #ccc; padding: 6px 10px;">Product 3</td><td style="border: 1px solid #ccc; padding: 6px 10px;">Origin A</td><td style="border: 1px solid #ccc; padding: 6px 10px;">15 kg cartons</td><td style="border: 1px solid #ccc; padding: 6px 10px;">on request</td></tr>
  <tr><td style="border: 1px solid #ccc; padding: 6px 10px;">Product 4</td><td style="border: 1px solid #ccc; padding: 6px 10px;">Origin A</td><td style="border: 1px solid #ccc; padding: 6px 10px;">20 kg cartons</td><td style="border: 1px solid #ccc; padding: 6px 10px;">on request</td></tr>
</table>
Terms: EXW / delivered, full trucks or partial loads from 5 t. Health certificate on request.$$)
ON CONFLICT (offer_id) DO NOTHING;
