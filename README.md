# Sass Toolkit

A collection of foundational utilities for Sass.

## Tools

- [Color](#color)
- [Type Styles](#type-styles)
- [Fluid Size](#fluid-size)
- [Fluid](#fluid)

## Install

```sh
npm install sass-toolkit --save
```

```scss
// in your main.scss
@import "sass-toolkit/color";
@import "sass-toolkit/type-styles";
@import "sass-toolkit/fluid-size";
@import "sass-toolkit/fluid";
```

## Use

### Requirements & Assumptions

The included tools are based heavily on the frontend development process at Malven Co., and as a result make some assumptions about the tools you're using and how your styles are organized.

#### Outputting Helpers

There are variables included for outputting helpers. One for each toolkit file.
```
$output-color-helpers;
$output-type-helpers;
$output-fluid-size-helpers;
```

By default all helpers are output, to turn them off just add the variable and set the variable to `false`.


#### Media Queries

Sass Toolkit uses [sass-mq](https://github.com/sass-mq/sass-mq) for responsive adjustments, which expects you to have a global `$mq-breakpoints` variable that defines your mobile-first breakpoints. The exact sizes you have defined for these breakpoints can be anything, and you can specify additional breakpoints:

```scss
$mq-breakpoints: (
  small: 500px,
  medium: 768px,
  large: 1024px,
  xlarge: 1400px
);
```

### Color

The `color` utility grabs colors and optionally generates helper class for your colors that can be used directly in your HTML.

#### Required Setup

Relies on a `$colors` map variable existing in the following format:

```scss
$colors: (
  black: #222,
  white: #fff,
  gray: #aaa,
  blue: #118bc1,
  yellow: #ffe215
);
```

#### As a SCSS function

```scss
.my-stuff {
  background-color: color(blue);
  color: color(yellow);
}
```

#### As an HTML class

```html
<div class="h-color-bg-blue">
  <h1 class="h-color-text-yellow">We all live in a yellow submarine</h1>
</div>
```

### Type Styles

Automatically generates all of the type styles for a project, provides a mixin for grabbing a specific set of predefined styles, adjusts type responsively, and provides optional helper classes for your type styles that can be used directly in your HTML. A type style can be any collection of CSS properties. Anything you add to the `properties` key of the configuration map will be output by the mixin.

#### Required Setup

Assumes that you are using 10-based `rem` (e.g. `font-size: 1.4rem; // 14 px`) units for sizing across the site, via something like `html { font-size: 62.5%; }`

Also relies on $`type-styles` and `$font-stacks` map variables existing in the following format:

```scss
$font-stacks: (
  futura-bold: (
    font-family: (Futura, 'Trebuchet MS', Arial, sans-serif),
    font-weight: 700,
    font-style: normal
  ),
  helvetica: (
    font-family: ('Helvetica Neue', Helvetica, Arial, sans-serif;),
    font-weight: normal,
    font-style: normal
  )
);

$type-styles: (
  heading: (
    stack: futura-bold,
    sizes: (
      default: 14,
      medium: 18
    ),
    properties: (
      line-height: 1,
      text-transform: normal,
      letter-spacing: 0,
    )
  ),

  body: (
    stack: helvetica,
    font-smoothing: true,
    sizes: (
      default: 16,
      medium: 24
    ),
    properties: (
      line-height: 1.4,
      text-transform: uppercase,
      letter-spacing: 1.2,
    )
  )
);
```

#### As an SCSS mixin

### With responsive sizing

```scss
.my-heading {
  @include type-style(heading);
}

// Outputs the following css

/*
.my-heading {
  font-family: Futura, 'Trebuchet MS', Arial, sans-serif,
  font-size: 1.4rem,
  line-height: 1,
  text-transform: normal,
  letter-spacing: 0
}

@media (min-width: 768px)
  .my-heading {
      font-size: 1.8rem;
  }
}
*/
```

### Without responsive sizing

If you'd like to get a type style at a specific size, without automatically including the responsive adjustments, you can use the `get-type-style` mixin:

```scss
.my-heading {
    @include get-type-style(heading, medium);
}

// Outputs the following css

/*
.my-heading {
  font-family: Futura, 'Trebuchet MS', Arial, sans-serif,
  font-size: 1.8rem,
  line-height: 1,
  text-transform: normal,
  letter-spacing: 0
}
*/
```

### Font stack only

And if you _only_ want the basic styling for a font stack, you can use the `font-stack-styles` mixin:

```scss
.my-heading {
    @include font-stack-styles(futura-bold);
}

// Outputs the following css

/*
.my-heading {
  font-family: (Futura, 'Trebuchet MS', Arial, sans-serif),
  font-weight: 700,
  font-style: normal
}
*/
```

#### As an HTML class

```html
<h1 class="h-type-heading">Ground control to Major Tom</h1>
```

### Fluid Size

The fluid size mixin makes it simple to smoothly adjust a value across a range of breakpoints, with precise control over the value at each breakpoint. It’s great for handling responsive margins and padding, but can be used for any numeric value, including font sizes, absolute/relative positioning values, etc. Interally, this mixin extends the `fluid` mixin mentioned later on. If you want a simpler, lower-level way to handle fluid property adjustments, check out the `fluid` mixin.

#### Required Setup

Relies on a `$fluid-sizes` map variable existing in the following format:

```scss
$fluid-sizes: (
  s: (
    default: 20px,
    medium: 40px,
    max: 80px
  ),

  m: (
    default: 20px,
    medium: 60px,
    max: 100px
  )
);
```

Each set in `$fluid-sizes` can have any key (e.g. `s`) and _must_ include at least a `default` key/value and one other key/value pair representing another breakpoint. Each key/value pair inside of a set should have a key that matches a value from you `$mq-breakpoints` map, and a value that matches the desired value when the viewport width is at that breakpoint.

The `default` key here represents the minimum possible size/value, as defined by the `$fluid-min-width` variable, which is `320px` by default. You can adjust this value by setting a `$fluid-min-width` variable to the smallest possible viewport width you want to handle.

#### As a mixin

```scss
* + * {
  @include fluid-size(s); // by default, the value is applied to `margin-top`
}

* + * {
  @include fluid-size(m, padding-bottom); // applies the value to any property
}
```

When applied using the `$fluid-sizes` map in the example above, the first example here would output a `margin-top` value of `20px` at a viewport width of `320px` wide, which would scale up to a value of `40px` at the `medium` breakpoint, then scale up to a maximum value of `80px` at the `max` breakpoint. The value will never be less than `20px` and never more than `80px`

#### With negative values

You can adjust the mixin to produce negative values from any `$fluid-sizes` set by setting the `$negative` parameter to true:

```scss
* + * {
  @include fluid-size(s, margin-top, $negative: true);
}
```

#### A note about units

Due to some browser inconsistencies when using the CSS `calc()` function that is used by this mixin behind the scenes, we recommend setting all `$fluid-sizes` values in `px`, and all values _must_ include a unit, even `0` values (i.e. use `0px` instead of `0`). Failing to follow these guidelines probably won’t cause issues in all browsers, but cross-browser behavior may be inconsistent.

#### As an HTML class

Works for any of the following classes:

- `h-fluid-size-top-margin-{$amount}`
- `h-fluid-size-bottom-margin-{$amount}`
- `h-fluid-size-top-padding-{$amount}`
- `h-fluid-size-bottom-padding-{$amount}`

```html
<h1 class="h-fluid-size-top-margin-s">Ground control to Major Tom</h1>
```

The exact names of the keys in this map aren't important, as long as `@include spacing(foo)` has a matching key `foo` in the map.

### Fluid

Inspired by the work of [Indrek Paas](https://github.com/indrekpaas) and the writing of [Mike Riethmuller](https://madebymike.com.au/writing/precise-control-responsive-typography/) this mixin allows you to specify a minumum and maximum size for values. Allowing for more fluid websites.

#### As an SCSS mixin

```scss
@include fluid($properties)
/* Single property */
html {
  @include fluid(font-size, 320px, 1366px, 14px, 18px);
}

/* Multiple properties with same values */
h1 {
  @include fluid(padding-bottom padding-top, 20em, 70em, 2em, 4em);
}
```


## Development

### Install dependencies
```sh
yarn
```

### Run tests
```sh
yarn test
```

…or…

```sh
yarn test-watch
```
