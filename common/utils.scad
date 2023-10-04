// Function to convert inches to millimeters
function inch_to_mm(inches) = inches * 25.4;
function mm_to_inch(mm) = mm / 25.4;
function val_or_default(val, default) = is_undef(val) ? default : val;
function in(needle, haystack) = len(haystack) > 0 && len(search(needle, haystack)) >= len(needle);

