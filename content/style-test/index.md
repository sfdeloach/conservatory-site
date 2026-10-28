---
title: Style Test
draft: true
---

A reference page with every Markdown element the site styles. It is a draft, so it appears only with `hugo server -D` and is never published.

## Heading level two

A short paragraph.

A longer paragraph that runs across several lines, to check the reading width and line height. Saint Andrew’s Conservatory of Music trains musicians of every age in a nurturing, Christ-centered context, with private instruction in organ, piano, strings, voice, and trombone. It contains **bold text**, _italic text_, inline `code`, and [an inline link](https://example.com/) in the middle of a sentence.

### Heading level three

A very long URL that must not break the layout on a phone: <https://example.com/a/very/long/path/that/keeps/going/and/going/without/any/spaces/to/break/on/index.html>.

Links of each kind: [an internal page](/summer-academy), [a section on this page](#tables), [an email address](mailto:mconservatory@sachapel.com), and [a link with a title](/faculty "Our faculty").

#### Heading level four

- A bulleted list item.
- A second item, long enough to wrap onto a second line on a narrow screen, so the hanging indent can be checked.
  - A nested item.
  - Another nested item.
- A third item.

1. A numbered list item.
2. A second numbered item.
   1. A nested numbered item.
3. A third numbered item.

> If music is, as Martin Luther says, a gift from God — then we are obliged to develop that gift.

---

## Images

A block image with a caption:

![A violin lying on its side](test-image.jpg "A caption, taken from the Markdown image title.")

An inline image ![A small violin](test-image.jpg) inside a sentence.

## Tables

| Lesson length    | Price  |
| ---------------- | ------ |
| 30-minute lesson | $33.00 |
| 45-minute lesson | $49.50 |
| 60-minute lesson | $66.00 |

A wide table:

| Semester    | Registration opens | Registration closes | Invoices sent | Semester begins | Payment due | Break         | Semester ends | Make-up week    | Recitals           |
| ----------- | ------------------ | ------------------- | ------------- | --------------- | ----------- | ------------- | ------------- | --------------- | ------------------ |
| Spring 2026 | December 1         | December 31         | January 2     | January 5       | January 9   | March 16 – 20 | May 1         | May 4 – 8       | May 4, 5 & 7       |
| Fall 2026   | July 1             | August 3            | August 7      | August 10       | August 14   | October 5 – 9 | December 4    | December 7 – 11 | December 7, 8 & 10 |

An unbroken word: Pneumonoultramicroscopicsilicovolcanoconiosis-and-then-some-more-without-spaces.

## Embeds

A YouTube video through Hugo's built-in shortcode:

{{< youtube id="0RKpf3rK57I" >}}

## Code

```text
A fenced code block with a very long line that should scroll sideways inside its box rather than widen the page on a narrow screen.
```

## Buttons

An ordinary [link to the Schedule](/schedule/) stays underlined, and buttons do not.

{{< destination_button "fullPayment" "installmentPayment" >}}

A closed entry with closed text, followed by a single button:

{{< destination_button "semesterRegistration" "donation" >}}

A paragraph after a button group, with [another link](/registration/), to check the spacing.

## Full bleed

This paragraph has the `full-bleed` class, so it spans the full width of the window instead of the reading column.
{.full-bleed}
