// Function to convert inches to millimeters
function inch_to_mm(inches) = inches * 25.4;
function mm_to_inch(mm) = mm / 25.4;
function val_or_default(val, default) = is_undef(val) ? default : val;

// TODO make this more efficient once search is less insane.
function in(needle, haystack) = let(n = len(haystack))
    (n == 0 || [for (i = [0:n-1]) if (haystack[i] == needle) true][0] == true);

function sum(v, i = 0, r = 0) = i < len(v) ? sum(v, i + 1, r + v[i]) : r;

function accumulate(vals) = [ for (
    a=0, b=0;
    a < len(vals);
    a= a+1, b=b+vals[a-1])
      b
  ];

function remove_intersection(a, b) =
    [for (needle = a) if (len(b) == 0 || !in(needle, b)) needle];

