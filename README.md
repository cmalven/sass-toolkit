# Sass Toolkit

A collection of foundational utilities for Sass.

## Tools

- [Color](#color)
- [Type Styles](#type-styles)
- [Size](#size)
- [Fluid](#fluid)

## Install

```sh
npm install sass-toolkit --save
```

```scss
// in your main.scss
@import "sass-toolkit/color";
@import "sass-toolkit/type-styles";
@import "sass-toolkit/size";
@import "sass-toolkit/fluid";

// Generate custom properties 
@include output-size-custom-properties;
```

## Use

### Requirements & Assumptions

The included tools are based heavily on the frontend development process at Malven Co., and as a result make some assumptions about the tools you're using and how your styles are organized.

#### Outputting Helpers

There are mixins included for outputting helpers. One for each toolkit file..
```
@include output-color-helpers;
@include output-type-helpers;
@include output-size-helpers;
```


#### Media Queries

Sass Toolkit doesn't make any assumptions about what you're using to output media queries, but it does require that you define your breakpoints in a map called `$breakpoints`. The specific breakpoints included can have whatever names or values you want, but they should be in the following format:

```scss
$breakpoints: (
  small: 500px,
  medium: 768px,
  large: 1024px,
  xlarge: 1400px
);
```

If you're interested in using a Sass library to help with outputting media queries based on this map of breakpoints, we recommend [include-media](https://www.npmjs.com/package/include-media), which also expects a map called `$breakpoints`.

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

Automatically generates all type styles for a project, provides a mixin for grabbing a specific set of predefined styles, adjusts type responsively, and provides optional helper classes for your type styles that can be used directly in your HTML. A type style can be any collection of CSS properties.

#### Required Setup

Requires `$type-styles` and `$font-stacks` map variables existing in the following format:

```scss
$font-stacks: (
  futura-bold: (
    font-family: (Futura, 'Trebuchet MS', Arial, sans-serif),
    font-weight: 700,
    font-style: normal
  ),
  helvetica: (
    font-family: ('Helvetica Neue', Helvetica, Arial, sans-serif),
    font-weight: normal,
    font-style: normal
  )
);

$type-styles: (
  heading: (
    stack: futura-bold,
    sizes: (
      default: (
        font-size: 1.4rem,
        line-height: 1,
        text-transform: normal,
        letter-spacing: 0
      ),
      // If you're not setting any properties for a size you only need the `font-size` value
      medium: 1.8rem
    )
  ),

  body: (
    stack: helvetica,
    sizes: (
      default: (
        font-size: 1.6rem,
        line-height: 1.4,
        text-transform: uppercase,
        letter-spacing: 1.2,
      ),
      medium: (
        font-size: 2.4rem,
        line-height: 1.5
      )
    )
  )
);
```

#### With fluid value

If you'd like the values for `font-size` to scale fluidly between breakpoints, just add `fluid: true`. This also requires that you use `px` for your values:

```scss
$type-styles: (
  heading: (
    stack: futura-bold,
    sizes: (
      default: 14px,
      medium: 18px,
      large: 24px
    ),
    fluid: true
  )
)
```

##### Fluid properties other than `font-size`

`fluid: true` will fluidly scale properties other than `font-size` but only if every size for the property uses `px` for the unit:

```scss
$type-styles: (
  heading: (
    stack: futura-bold,
    sizes: (
      default: (
        font-size: 14px,
        line-height: 20px
      ),
      medium: (
        font-size: 19px,
        line-height: 24px
      ),
      large: 24px
    ),
    fluid: true
  )
)
```

#### As an SCSS mixin

##### With responsive sizing

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

##### Without responsive sizing

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

#### Font stack only

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

### Size

The `size` mixin makes it simple to smoothly adjust a value across a range of breakpoints, with precise control over the value at each breakpoint. It’s great for handling responsive margins and padding, but can be used for any numeric value, including font sizes, absolute/relative positioning values, etc. Internally, this mixin extends the `fluid` mixin mentioned later on. If you want a simpler, lower-level way to handle fluid property adjustments, check out the `fluid` mixin.

#### Required Setup

Relies on a `$sizes` map variable existing in the following format:

```scss
$sizes: (
  xs: (
    default: 20px
  ),
  
  s: (
    default: 10px,
    medium: 30px,
    max: 50px
  ),

  m: (
    default: 20px,
    medium: 60px,
    max: 100px
  )
);
```

Each set in `$sizes` can have any key (e.g. `xs`), _must_ include at least a `default` key/value, and can optionally include any other key/value pair representing another breakpoint. Each key/value pair inside of a set should have a key that matches a value from your `$breakpoints` map, and a value that matches the desired value when the viewport width is at that breakpoint.

The `default` key here represents the minimum possible size/value, as defined by the `$fluid-min-width` variable, which is `320px` by default. You can adjust this value by setting a `$fluid-min-width` variable to the smallest possible viewport width you want to handle.

#### As a mixin

```scss
* + * {
  @include size(s); // by default, the value is applied to `margin-top`
}

* + * {
  @include size(m, padding-bottom); // applies the value to any property
}
```

When applied using the `$sizes` map in the example above, the first example here would output a `margin-top` value of `20px` at a viewport width of `320px` wide, which would scale up to a value of `40px` at the `medium` breakpoint, then scale up to a maximum value of `80px` at the `max` breakpoint. The value will never be less than `20px` and never more than `80px`

#### With negative values

You can adjust the mixin to produce negative values from any `$sizes` set by setting the `$negative` parameter to true:

```scss
* + * {
  @include size(s, margin-top, $negative: true);
}
```

#### A note about units

Due to the implementation details of the `calc()` function that is used by this mixin behind the scenes, all `$sizes` values must use `px`, and all values _must_ include a unit, even `0` values (i.e. use `0px` instead of `0`).

#### As an HTML class

Works for any of the following classes:

- `h-size-top-margin-{$amount}`
- `h-size-bottom-margin-{$amount}`
- `h-size-top-padding-{$amount}`
- `h-size-bottom-padding-{$amount}`

```html
<h1 class="h-size-top-margin-s">Ground control to Major Tom</h1>
```

The exact names of the keys in this map aren't important, as long as `@include size(foo)` has a matching key `foo` in the map.

#### CSS Custom Properties (variables)

Sass Toolkit will loop through all size sets in the `$sizes` map and output corresponding, responsive CSS custom properties for each. These are used for the output of `@include sizes()`, but you can also use these custom properties directly (e.g. `margin-top: var(--size-s)`), or you can use them in your own `calc()` declarations. Using the above `$sizes`, you'd end up with the following:

```scss
// Only values for the `s` size set are shown here, but you'd see something similar for all other sets in `$sizes`

:root {
  --size-s: 10px;
}

@media screen and (min-width: 320px) {
  :root {
    --size-s: calc(10px + 20 * ((100vw - 320px) / 448));
  }
}

@media screen and (min-width: 768px) {
  :root {
    --size-s: calc(30px + 20 * ((100vw - 768px) / 672));
  }
}
```

### Fluid

Inspired by the work of [Indrek Paas](https://github.com/indrekpaas) and the writing of [Mike Riethmuller](https://madebymike.com.au/writing/precise-control-responsive-typography/) this mixin allows you to specify a minumum and maximum size for values. Allowing for more fluid websites.

#### As an SCSS mixin

```scss
@include fluid($properties)
/* Single property */
html {
  @include fluid(font-size, 320px, 1440px, 14px, 18px);
}

/* Multiple properties with same values */
h1 {
  @include fluid(padding-bottom padding-top, 320px, 1440px, 200px, 300px);
}

/* If you have a $mq-breakpoints map, you can use its keys in place of values */
p {
  @include fluid(margin-top, medium, large, 100px, 200px);
}

/* …and you can use `default` to refer to your $fluid-min-width value */
p {
  @include fluid(margin-top, default, large, 100px, 200px);
}

/* Substitute vertical units, for queries that respond to device height */
@include fluid(margin-top, 600px, 900px, 100px, 200px, $size-unit: height, $viewport-unit: vh);
```

## Development

### Install dependencies
```sh
npm i
```

### Run tests
```sh
npm test
```

…or…

```sh
npm run test-watch
```

### Release

- Bump `version` in `package.json` appropriately.
- Create a new Github release identifying changes.
- A Github Action will automatically run tests and publish the update.
