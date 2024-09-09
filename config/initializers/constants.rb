TIN_FORMATS = {
  'AU' => { 'au_abn' => /\A\d{2} \d{3} \d{3} \d{3}\z/, 'au_acn' => /\A\d{3} \d{3} \d{3}\z/ },
  'CA' => { 'ca_gst' => /\A\d{9}RT\d{4}\z/ },
  'IN' => { 'in_gst' => /\A\d{2}[A-Z]{5}\d{1}[A-Z]{1}\d{1}[A-Z]{1}\d{1}[A-Z]{1}\d{1}\z/ }
}.freeze
