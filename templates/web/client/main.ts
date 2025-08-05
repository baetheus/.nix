import { render } from "preact";

import { App } from "~/client/app.tsx";

// esbuild dev mode
declare const DEV_MODE: unknown;
try {
  if (DEV_MODE) {
    console.log("DEV MODE ON");
    new EventSource("/esbuild").addEventListener(
      "change",
      () => location.reload(),
    );
  }
} catch (exception) {
  console.error("Exception while setting up dev mode", exception);
}

render(App(), document.body);
