# README

## Roadmap

### 1. Decide how "Areas of Study" is modeled (the most interesting Hugo topic left)

This decision affects several pages, so think it through before building the home page's TODO section. You have three options:

- **Derive the list from the faculty `studios` params** (`uniq` and `sort` across all faculty pages). Simple, but each instrument is just a word, with no description, image or page of its own.
- **Make `areas-of-study` a section with one page per instrument.** Each gets its own description and image, but the link between teachers and instruments has to be maintained by hand in two places.
- **Turn `studios` into a Hugo taxonomy.** This is what taxonomies are for. Hugo automatically generates a page per instrument (`/studios/piano/`) listing every teacher who has it in their front matter, and a page listing all instruments. You disabled taxonomies early on because the default `tags` and `categories` weren't needed. A **custom** taxonomy is different, and it's one of Hugo's strongest features. Each instrument's page can also have its own description and image.

I'd lean toward the taxonomy. It keeps one source of truth (each teacher's front matter), and you'd learn a core part of Hugo along the way.

### 2. Deploy a staging version early

Since you'll be the one hosting this, an early deploy gives church staff something to review and replaces the duckdns preview. It also covers the areas you said you want to learn (security and networking):

- **A multi-stage Docker build:** a Hugo stage builds the site, then an `nginx:alpine` stage serves `public/`. The final image contains no Hugo, Node or Sass, just static files.
- **Nginx configuration:**
  - **long cache lifetimes for fingerprinted assets** (`Cache-Control: immutable`), which is the payoff of the fingerprinting you set up;
  - **security headers:** `Content-Security-Policy`, `Strict-Transport-Security`, `X-Content-Type-Options`, `Referrer-Policy`;
  - HTTPS with automatically renewed certificates.
- **CI (GitHub Actions):** build on every push, with `hugo --panicOnWarning` so warnings fail the build, plus a link checker and an accessibility checker.

### 3. Finish the home page sections

The structure, content and links are in place. What's left is styling the sections and filling in the TODO:

- **Story stats:** your `<dl>` is ready to become a row of large numbers with small labels. Grid with `repeat(auto-fit, minmax(…))` handles the layout without media queries.
- **Faculty preview:** reuse your faculty card markup and `responsive_image.html`, limited to 3–4 people (`first`, or a `featured: true` flag in front matter).
- **Summer Academy and "Ready" bands:** full-width backgrounds using `grid-column: full`, with content kept in the content column, the same subgrid technique as the hero.

### 4. Content styles for Markdown pages

You've put this off for a while, and every content page needs it: the `.prose` wrapper (link styles, readable line length around 65–75ch, spacing between paragraphs and lists) and the link render hook with build-time broken-link checks. Your new `main` content column is 120ch wide, which is too long a line for comfortable reading, so this matters now.

### 5. Forms: decide before you build Registration and Payment

A static site can't process form submissions on its own. The church wanted to get away from a full-stack application, so the realistic options are:

- an **embedded external form service** (Google Forms, Jotform, Tally),
- a **payment provider's hosted checkout page** (Stripe Payment Links, PayPal), so card data never touches your server. That's the safest option by far.
- or a **tiny form-handling service** you run yourself behind Nginx (Go would suit it well), which brings back some of the backend the church wanted to avoid.

This is partly a conversation with church staff, and it shapes those two pages, so raise it early.

### 6. Polish last

Scroll-driven animations, View Transitions between pages, and SEO basics: a meta description, and Open Graph tags so links shared on Facebook show an image and a title. Hugo has built-in templates for those. These go last because they're refinements on content and layout that need to settle first.
