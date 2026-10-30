// pa11y-ci settings for scripts/check-a11y.sh, which runs the check once
// per width in A11Y_WIDTH: 375 is a phone, anything else a desktop.
const phone = process.env.A11Y_WIDTH === "375";

module.exports = {
  defaults: {
    runners: ["axe"],
    // axe's "needs review" results, such as text over an image or a
    // gradient, are warnings; contrast there is checked by hand.
    levelCapWhenNeedsReview: "warning",
    timeout: 30000,
    viewport: phone
      ? { width: 375, height: 812, isMobile: true }
      : { width: 1280, height: 1024 },
    // Ubuntu 24.04 CI runners don't allow Chrome's sandbox.
    chromeLaunchConfig: { args: ["--no-sandbox"] },
  },
};
