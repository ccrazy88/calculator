# Calculator

## Notes About Required Tasks

> Get the Calculator working as demonstrated in lectures 1 and 2. The
> Autolayout portion at the end of the lecture is extra credit, but give it a
> try because getting good at autolayout requires experience. If you do not do
> autolayout, be sure to position everything so that it is visible on all
> iPhones (i.e. the upper left corner of the scene).

Code is equivalent to the code provided in lecture with the following
exceptions:

- "MARK" comments added for increased readability
- Used standard values for autolayout constraints rather than hard-coded value
  of 8
- Made all properties and functions private

> Add the following operation to your Calculator:
>
> - π: calculates (well, conjures up) the value of π. For example, 3 π × should
>      put three times the value of π into the display on your calculator.
>      Ditto 3 ↲ π x and also π 3 ×.

π is implemented as an operation.

> Add a UILabel to your UI which shows a history of every operand and operation
> input by the user. Place it at an appropriate location in your UI.

The UILabel does not show results of operations.

## Notes About Extra Credit

> Implement a "backspace" button for the user to touch if they hit the wrong
> digit button. It is up to you to decide how to handle the case where the user
> backspaces away the entire number they are in the middle of typing, but
> having the display go completely blank is probably not very user-friendly.

Backspacing away the entire number will return the display to "0."

> When the user hits an operation button, put an = on the end of the UILabel
> you added in the Required Task above.

The equals sign will disappear once outside of an operation as well.
